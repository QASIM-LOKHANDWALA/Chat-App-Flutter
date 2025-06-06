import 'package:chat_app_flutter/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Messages Found!"));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong.'));
        }
        final loadedMessages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, idx) {
            final chatMessage = loadedMessages[idx];
            final nextChatMessage =
                idx + 1 < loadedMessages.length ? loadedMessages[idx] : null;
            final currentUserId = chatMessage['userId'];
            final nextUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextUserId == currentUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authUser!.uid == currentUserId,
              );
            } else {
              return MessageBubble.first(
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authUser!.uid == currentUserId,
              );
            }
          },
        );
      },
    );
  }
}
