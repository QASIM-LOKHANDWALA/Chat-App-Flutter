import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () async {
              try {
                FirebaseAuth.instance.signOut();
              } on FirebaseAuthException {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error signing out!')),
                );
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text("Hello!")),
    );
  }
}
