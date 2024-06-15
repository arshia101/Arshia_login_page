import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String imageSource = 'images/question-mark.png';
  final storage = const FlutterSecureStorage();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    String savedLoginName = await storage.read(key: 'loginName') ?? '';
    String savedPassword = await storage.read(key: 'password') ?? '';

    if (savedLoginName.isNotEmpty && savedPassword.isNotEmpty) {
      setState(() {
        loginController.text = savedLoginName;
        passwordController.text = savedPassword;
      });

      _showBasicSnackBar();
    }
  }

  Future<void> _clearStoredCredentials() async {
    await storage.delete(key: 'loginName');
    await storage.delete(key: 'password');
  }

  void _handleLogin() {
    String loginName = loginController.text;
    String password = passwordController.text;

    setState(() {
      if (password == 'QWERTY123') {
        imageSource = 'images/light-bulb.png';
      } else {
        imageSource = 'images/stop-sign.png';
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials?'),
          content: const Text('Do you want to save your login credentials?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveCredentials(loginName, password); // Save credentials securely
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCredentials(String loginName, String password) async {
    await storage.write(key: 'loginName', value: loginName);
    await storage.write(key: 'password', value: password);
  }

  void _showBasicSnackBar() {
    final snackBar = SnackBar(
      content: const Text('Previous login credentials loaded.'),
      action: SnackBarAction(
        label: 'Clear saved data',
        onPressed: () {
          // Code to execute when the button is pressed, if needed.
          _clearStoredCredentials();
          loginController.clear();
          passwordController.clear();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: loginController,
                decoration: const InputDecoration(labelText: 'Login name'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showBasicSnackBar,
                child: const Text('Show SnackBar'),
              ),
              const SizedBox(height: 20),
              Image.asset(
                imageSource,
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
