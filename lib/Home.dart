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
  var updateNews;
  GlobalKey<RefreshIndicatorState> refreshkey;
  String dropdownValue = "Top";
  String bbcnews = "sources=bbc-news";
  String endpoint = "sources=bbc-new";
  List<String> _dropdownList = ['Top', 'BBC', 'Trump', 'News now'];
  updatenews() {
    setState(() {});
  }

  Future<void> refreshNews() async {
    await Future.delayed(Duration(seconds: 1));
    updatenews();
    return null;
  }

  @override
  void initState() {
    refreshkey = GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TopNewsModel>(
          future: ApiManager().getNews(endpoint),
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
          child: Row(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Flash⚡",
                      style: GoogleFonts.sourceCodePro(
                          fontSize: 35, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "News",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 30))
                ]),
              ),
              _dropdown()
            ],
          )),
      SizedBox(
          height: 600,
          child: RefreshIndicator(
              key: refreshkey,
              onRefresh: () async {
                await refreshNews();
              },
              child: card(data)))
    ]));
  }

  Widget _dropdown() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.line_weight),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        if (newValue == "Top") {
          dropdownValue = newValue;
          setState(() {
            endpoint = "country=us";
          });
        } else if (newValue == "BBC") {
          setState(() {
            endpoint = "sources=bbc";
          });
        } else if (newValue == "Trump") {
          setState(() {
            endpoint = "q=trump";
          });
        } else {
          setState(() {
            endpoint = "country=de&category=business";
          });
        }
      },
      items: _dropdownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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
                            child: data.articles[index].urlToImage != null
                                ? Image(
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.network(
                                          "https://webhostingmedia.net/wp-content/uploads/2018/01/http-error-404-not-found.png");
                                    },
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        data.articles[index].urlToImage),
                                  )
                                : Image.network(
                                    "https://webhostingmedia.net/wp-content/uploads/2018/01/http-error-404-not-found.png"),
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
