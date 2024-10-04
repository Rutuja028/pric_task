import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State {
  final TextEditingController _searchController = TextEditingController();

  List<String> searchHistory = [];
  List data = [];
  bool showImg = false;
  int pageNumber = 0;

  getHistory() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("search_history").get();

    List<QueryDocumentSnapshot> list = querySnapshot.docs;
    log(list.toString());
  }

  getData() async {
    http.Response response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/?client_id=IKPXpot9DDDV4ymCOHuxtGr6hUWcvXjYnIYWhcPNP2I&page=$pageNumber&per_page=10'));

    data = jsonDecode(response.body);
    // log(data.toString());

    _assign();
    setState(() {
      showImg = true;
    });
  }

  _assign() {
    for (var i = 0; i < data.length; i++) {
      images.add(data.elementAt(i)["urls"]["small_s3"]);
      // log(data.elementAt(i)["urls"]["regular"].toString());
      print("LENGTH:${images.length}");
    }
    // log(images.toString());
  }

  List<String> images = [];

  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getHistory();
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
    String clientId = 'IKPXpot9DDDV4ymCOHuxtGr6hUWcvXjYnIYWhcPNP2I';
    log("In search images");
    final url =
        'https://api.unsplash.com/search/photos?page=$pageNumber&per_page=10&client_id=$clientId&query=$query';

    setState(() {
      showImg = false;
    });

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      data = result['results'];

      _assign();
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
            DropdownMenu(
              // initialSelection: menuItems.first,

              trailingIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    pageNumber = 0;
                    images
                        .clear(); // Clear current images for new search results

                    _searchImages(_searchController.text);
                    searchHistory.add(_searchController.text);

                    setState(() {});
                  }
                },
              ),
              controller: _searchController,
              width: 300,
              hintText: "Select Menu",
              requestFocusOnTap: true,
              enableFilter: true,
              menuStyle: MenuStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightBlue.shade50),
              ),

              label: const Text('Select Menu'),
              onSelected: (data) {},
              enableSearch: true,

              dropdownMenuEntries:
                  searchHistory.map<DropdownMenuEntry>((String varHistory) {
                return DropdownMenuEntry(
                  value: varHistory,
                  label: varHistory,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  log("Images  ${images[0].toString()}");
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: !showImg
                        ? const CircularProgressIndicator()
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
