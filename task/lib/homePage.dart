import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State {
  final TextEditingController _searchController = TextEditingController();

  List data = [];
  bool showImg = false;
  int pageNumber = 0;
  getData() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/?client_id=IKPXpot9DDDV4ymCOHuxtGr6hUWcvXjYnIYWhcPNP2I&page=$pageNumber&per_page=10'));

    data = jsonDecode(response.body);
    _assign();
    setState(() {
      showImg = true;
    });
  }

  _assign() {
    for (var i = 0; i < data.length; i++) {
      images.add(data.elementAt(i)["urls"]["regular"]);
      print("LENGTH:${images.length}");
    }
  }

  List<String> images = [];

  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          // Load more data when reaching the end
          print("INCREMENT PAGE NUMBER");
          setState(() {
            pageNumber = pageNumber + 1;
          });
          getData();
        }
      });
  }

  Future<void> _searchImages(String query) async {
    final String clientId = 'YOUR_UNSPLASH_ACCESS_KEY';
    final url =
        'https://api.unsplash.com/search/photos?page=$pageNumber&per_page=10&client_id=$clientId&query=$query';

    setState(() {
      showImg = false;
    });

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      data = result['results'];

      _assign(); // Same as your existing _assign method
      setState(() {
        showImg = true;
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HomePage",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Welome to the Home Page!"),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search images...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        setState(() {
                          pageNumber = 0;
                          images
                              .clear(); // Clear current images for new search results
                        });
                        _searchImages(_searchController.text);
                      }
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Add spacing between search bar and image list

            Container(
              height: 200,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: !showImg
                        ? CircularProgressIndicator()
                        : Image.network(images[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
