import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  void checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName;
    final email = user?.email;
    print("name");
    print(name);
    print("email");
    print(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.green,
            child: const Icon(Icons.logout_rounded),
          ),
          body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Image.network(
                      'https://geographical.co.uk/wp-content/uploads/somalaya-mountain-range-title.jpg')),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Oeschinen Lake Campground',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Kanderesteg, Iceland',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )),
                      Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.red[500]),
                              const Text('41')
                            ],
                          ))
                    ],
                  )),
            ],
          )),
    );
  }
}
