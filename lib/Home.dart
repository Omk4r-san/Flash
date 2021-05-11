import 'package:Flash/detailpage.dart';
import 'package:Flash/urls/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Flash/models/topnews_model.dart';
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
  String dropdownValue = "Top News US";
  String endpoint = TopHeadLinesEndponint().topbusinessNewsUs;
  String mainEndPoint = TopHeadLinesEndponint().mainEndpoint;
  List<String> _dropdownList = [
    'Top News US',
    'Top News Germany',
    'Techcrunch',
    'BBC News',
    'Trump',
    'Apple',
    'Tesla',
  ];

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
          future: getNews(endpoint, mainEndPoint),
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
      Center(
        child: Container(
            height: 45,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Flash⚡",
                      style: GoogleFonts.sourceCodePro(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "News",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 21))
                ]),
              ),
            )),
      ),
      _dropdown(),
      SizedBox(
          height: 600,
          child: RefreshIndicator(
              key: refreshkey,
              onRefresh: () async {
                await refreshNews();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: card(data),
              )))
    ]));
  }

  Widget _dropdown() {
    return DropdownButtonHideUnderline(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          disabledHint: Text(""),
          value: dropdownValue,
          icon: Icon(Icons.more_vert_rounded),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.white),
          onChanged: (String newValue) {
            if (newValue == "Top News Germany") {
              setState(() {
                dropdownValue = newValue;
                endpoint = TopHeadLinesEndponint().topbusinessNewsGm;
                mainEndPoint = TopHeadLinesEndponint().mainEndpoint;
              });
            } else if (newValue == "BBC News") {
              setState(() {
                dropdownValue = newValue;
                endpoint = TopHeadLinesEndponint().bbcNews;
                mainEndPoint = TopHeadLinesEndponint().mainEndpoint;
              });
            } else if (newValue == "Trump") {
              setState(() {
                dropdownValue = newValue;
                endpoint = TopHeadLinesEndponint().trumpnNews;
                mainEndPoint = TopHeadLinesEndponint().mainEndpoint;
              });
            } else if (newValue == "Apple") {
              setState(() {
                dropdownValue = newValue;
                endpoint = EveryThingEndpoint().appleNews;
                mainEndPoint = EveryThingEndpoint().mainEndPoint;
              });
            } else if (newValue == "Tesla") {
              setState(() {
                dropdownValue = newValue;
                endpoint = EveryThingEndpoint().teslaNews;
                mainEndPoint = EveryThingEndpoint().mainEndPoint;
              });
            } else if (newValue == "Techcrunch") {
              setState(() {
                dropdownValue = newValue;
                endpoint = TopHeadLinesEndponint().techCrunch;
                mainEndPoint = TopHeadLinesEndponint().mainEndpoint;
              });
            }
          },
          items: _dropdownList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(value),
              ),
            );
          }).toList(),
        ),
      ),
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
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 1),
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
                      child: Column(
                        children: [
                          Container(
                            height: 230,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
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
                                  : Hero(
                                      tag: "newsImage",
                                      child: Image.network(
                                          "https://webhostingmedia.net/wp-content/uploads/2018/01/http-error-404-not-found.png"),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.articles[index].title,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<TopNewsModel> getNews(endpoint, String mainEndPoint) async {
    String mainEndpoints = mainEndPoint;
    String url =
        "http://newsapi.org/v2/top-headlines?everything&apiKey=c62d2a326a874c998b523ca02bdd1674";
    print("url=");
    print(url);
    var response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonString = response.body;
        final topNews = topNewsModelFromJson(jsonString.toString());
        return topNews;
      }
    } catch (Exception) {
      print(Exception.toString());
    }
    return null;
  }
}
