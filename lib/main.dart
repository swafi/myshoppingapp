import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Mazao_Connect());
}

class Mazao_Connect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mazao Connect',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mazao Connect',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        backgroundColor: Colors.green[200], // Background color
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bac.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BrowseProductsScreen()),
                    );
                  },
                  child: Text(
                    'Browse Products',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
                SizedBox(height: 75),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
                SizedBox(height: 75),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product({required this.name, required this.imageUrl, required this.price});
}

class BrowseProductsScreen extends StatelessWidget {
  final Map<String, List<Product>> products = {
    'Chicken': [
      Product(name: 'Broiler Chicken', imageUrl: 'assets/broiler1.jpg', price: 500.00),
      Product(name: 'Boneless Broiler', imageUrl: 'assets/boness1.jpg', price: 600.00),
      Product(name: 'Kienyeji Chicken', imageUrl: 'assets/kienyeji.jpg', price: 700.00),
      Product(name: 'Ex-Broiler', imageUrl: 'assets/ex broilers1.jpg', price: 400.00),
    ],
    'Fish': [
      Product(name: 'Tilapia', imageUrl: 'assets/tilapia.jpg', price: 300.00),
      Product(name: 'Catfish', imageUrl: 'assets/catfish.jpg', price: 400.00),
      Product(name: 'Fish Fillet', imageUrl: 'assets/fish fillet.jpg', price: 500.00),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browse Products',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        backgroundColor: Colors.green, // Background color
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/url.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          ListView(
            children: products.keys.map((category) {
              return ExpansionTile(
                title: Text(
                  category,
                  style: TextStyle(
                    color: Colors.black, // Changed text color to black
                    fontSize: 20.0, // Increased font size to 20.0
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: products[category]!.map((product) {
                  return ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(
                        color: Colors.black, // Changed text color to black
                        fontSize: 25.0, // Font size for sub-items
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Image.asset(
                      product.imageUrl,
                      width: 100,
                      height: 100,
                    ),
                    subtitle: Text(
                      'Ksh ${product.price.toString()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: QuantitySelector(
                      product: product,
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final Product product;

  QuantitySelector({required this.product});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 0; // Set initial quantity to 0

  void _addToCart() {
    // Implement cart addition logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.name} added to cart with quantity $quantity')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (quantity > 0) {
              setState(() {
                quantity--;
              });
            }
          },
        ),
        Text('$quantity'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              quantity++;
            });
          },
        ),
        ElevatedButton(
          onPressed: _addToCart,
          child: Text('Add to Cart'),
        ),
      ],
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    var url = Uri.parse('https://mazao.onrender.com/mazao/api/users/');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully')),
        );
        // Navigate to another screen after successful registration if needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed')),
        );
      }
    } catch (e) {
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during registration')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        backgroundColor: Colors.green, // Background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    var url = Uri.parse('https://mazao.onrender.com/mazao/api/users/login/');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'username': _usernameController.text.trim(),
      'password': _passwordController.text,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User logged in successfully')),
        );
        // Navigate to another screen after successful login if needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        backgroundColor: Colors.green, // Background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _loginUser();
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
