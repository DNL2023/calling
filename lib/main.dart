import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nextcloud Integration',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    Uri loginUrl = Uri.parse('https://< SERVER URL >/ocs/v1.php/nextcloud/user?format=json&password=$password&username=$username');

    var response = await http.post(
      loginUrl,
      headers: {
        'OCS-APIRequest': 'true',
        'User-Agent': 'flutter-call',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('Decoded Data: $data');

      if (data['ocs']['meta']['status'] == 'ok') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TalkPage(loginUrl: loginUrl),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid login credentials.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while sending the request to the server.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nextcloud Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class TalkPage extends StatelessWidget {
  final Uri loginUrl;

  TalkPage({required this.loginUrl});

  void _startNextcloudTalk() {
    // Open Nextcloud Talk in a web view or use another method to display the Talk functionality
    // Example: LaunchUrl.launch('${loginUrl}/apps/talk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nextcloud Talk'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startNextcloudTalk,
          child: const Text('Open Nextcloud Talk'),
        ),
      ),
    );
  }
}
