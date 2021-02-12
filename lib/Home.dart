import 'package:Flash/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:Flash/Api_class.dart';
import 'package:Flash/models/topnews_model.dart';
import 'package:google_fonts/google_fonts.dart';

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
        child: ListView(children: [
      Container(
          height: 70,
          child: Center(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: "Flash⚡", style: GoogleFonts.lato(fontSize: 35)),
                TextSpan(
                    text: "News",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        fontSize: 30))
              ]),
            ),
          )),
      SizedBox(height: 600, child: card(data))
    ]));
  }

  Widget card(data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: data.articles.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    author: data.articles[index].author,
                                    publishedAt:
                                        data.articles[index].publishedAt,
                                    description:
                                        data.articles[index].description,
                                    title: data.articles[index].title,
                                    urlToImage: data.articles[index].urlToImage,
                                    content: data.articles[index].content,
                                  ))),
                      child: Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return RadialGradient(
                              radius: 2,
                              center: Alignment.bottomCenter,
                              colors: <Color>[Colors.black87, Colors.grey],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(data.articles[index].urlToImage),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        height: 210,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          data.articles[index].title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
