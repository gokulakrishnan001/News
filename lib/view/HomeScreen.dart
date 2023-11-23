import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news/model/NewsModel.dart';
import 'package:news/network/Response.dart';
import 'package:news/view/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Results>? newsModel = [];

  ApiService service = ApiService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 105, 54, 244),
          title: const Text('Feeds'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: (() async {
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }),
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: FutureBuilder(
            future: service.getNews(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Results>> snapshot) {
              if (snapshot.hasData) {
                List<Results>? news = snapshot.data;
                return ListView.builder(
                    itemCount: news?.length,
                    itemBuilder: (context, index) =>
                        customExpandTile(news![index], context));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Future<dynamic> Logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}

Widget customExpandTile(Results news, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ExpandPage(news: news)));
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          news.urlToImage != null
              ? Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(news.urlToImage.toString()),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                )
              : Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/not.png'), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black12, Colors.white, Colors.black12]),
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              news.source.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            news.title.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    ),
  );
}

class ExpandPage extends StatelessWidget {
  final Results news;

  const ExpandPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title.toString()),
        backgroundColor: Color.fromARGB(255, 105, 54, 244),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            news.urlToImage != null
                ? Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(news.urlToImage.toString()),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  )
                : Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/not.png'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black12, Colors.white, Colors.black12]),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                news.source.name,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              news.description.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
