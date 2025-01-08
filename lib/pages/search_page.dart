import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimal_chat_app/components/search_results.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _search = TextEditingController();
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          
          children: [
            TextField(
                onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
                controller: _search,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Iconsax.search_normal),
                  hintText: "Search here",
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Theme.of(context).colorScheme.primary,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            Expanded(child: SearchResults(searchQuery: searchQuery,)),
          ],
        ),
      ),
    );
  }
}
