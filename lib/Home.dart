import 'package:Flash/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:Flash/Api_class.dart';
import 'package:Flash/models/topnews_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<TopNewsModel> _topNews;
  @override
  void initState() {
    _topNews = ApiManager().getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TopNewsModel>(
          future: _topNews,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return mainPage(snapshot.data);
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget mainPage(data) {
    return SafeArea(
      child: ListView.builder(
        itemCount: data.articles.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          author: data.articles[index].author,
                          publishedAt: data.articles[index].publishedAt,
                          description: data.articles[index].description,
                          title: data.articles[index].title,
                          urlToImage: data.articles[index].urlToImage,
                          content: data.articles[index].content,
                        ))),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: Center(
                  child: Image(
                image: NetworkImage(data.articles[index]),
              )),
            ),
          );
        },
      ),
    );
  }
}
