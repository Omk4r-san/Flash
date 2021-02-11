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
    return Container(
      child: Center(
        child: Text(widget.content.toString()),
      ),
    );
  }
}
