import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  LockScreen({super.key});

  void _submitPassword(BuildContext context) async {
    const platform = MethodChannel('com.example.app_locker/accessibility');
    try {
      final bool result = await platform.invokeMethod('checkPassword', {'password': _passwordController.text});
      if (result) {

          Navigator.of(context).pop(true);

        // Close the lock screen with success
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      }
    } on PlatformException catch (e) {
      print("Failed to check password: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter Password',
                style: TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _submitPassword(context),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
