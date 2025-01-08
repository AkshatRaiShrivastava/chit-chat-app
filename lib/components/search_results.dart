import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/user_tile.dart';
import 'package:minimal_chat_app/pages/chat_page.dart';
import 'package:rxdart/rxdart.dart';

class SearchResults extends StatelessWidget {
  final String searchQuery;

  SearchResults({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) {
      return Center(child: Text('Start typing to search.'));
    }

    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: searchUsers(searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        final results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final data = results[index].data() as Map<String, dynamic>;
            return UserTile(
              name: data['name'],
              email: data['email'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverEmail: data["email"],
                      receiverId: data["uid"],
                      receiverName: data["name"],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// Search for users by name or email
  Stream<List<QueryDocumentSnapshot>> searchUsers(String query) {
  // Query for names
  final nameQuery = FirebaseFirestore.instance
      .collection('Users')
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThanOrEqualTo: query + '\uf8ff')
      .snapshots()
      .map((snapshot) => snapshot.docs);

  // Query for emails
  final emailQuery = FirebaseFirestore.instance
      .collection('Users')
      .where('email', isGreaterThanOrEqualTo: query)
      .where('email', isLessThanOrEqualTo: query + '\uf8ff')
      .snapshots()
      .map((snapshot) => snapshot.docs);

  // Combine both streams using rxdart
  return Rx.combineLatest2<List<QueryDocumentSnapshot>, List<QueryDocumentSnapshot>, List<QueryDocumentSnapshot>>(
    nameQuery,
    emailQuery,
    (nameResults, emailResults) {
      final combinedResults = [...nameResults, ...emailResults];

      // Remove duplicates by using a map with unique IDs
      final uniqueResults = <String, QueryDocumentSnapshot>{};
      for (var doc in combinedResults) {
        uniqueResults[doc.id] = doc; // Use document ID as the key to ensure uniqueness
      }
      
      return uniqueResults.values.toList(); // Return unique results as a list
    },
  );
}

}
