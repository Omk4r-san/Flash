import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final String author, title, description, urlToImage, content;
  final DateTime publishedAt;

  const DetailPage(
      {Key key,
      this.author,
      this.title,
      this.description,
      this.urlToImage,
      this.content,
      this.publishedAt})
      : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var _dateFormat = DateFormat("MMM dd, yyyy ");
    var _date = _dateFormat.format(widget.publishedAt);
    print(_date);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.urlToImage),
                      )),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ]),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(
                      width: 15,
                    ),
                    Text(_date)
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.description,
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Text(
                  widget.content,
                  style: TextStyle(fontSize: 20),
                  overflow: TextOverflow.clip,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(children: [
                  TextSpan(
                      text: "Aritcle by: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  TextSpan(text: widget.author, style: TextStyle(fontSize: 15)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
