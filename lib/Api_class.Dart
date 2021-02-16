import 'package:http/http.dart' as http;
import 'package:Flash/models/topnews_model.dart';


class ApiManager{
  Future<TopNewsModel> getNews(endpoint) async {
    String url = "http://newsapi.org/v2/top-headlines?$endpoint&apiKey=c62d2a326a874c998b523ca02bdd1674";
    print("url=");
    print(url);
    var response = await http.get(url);  
    try {   
      if (response.statusCode == 200){
        var jsonString = response.body;
        final topNews = topNewsModelFromJson(jsonString.toString());
        return topNews;
        }
    }
    catch(Exception) {
      print(Exception.toString());
    }
    return null;
        
    }
}