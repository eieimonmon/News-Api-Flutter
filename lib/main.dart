import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class News{
  final String title;
  final String description;
  final String author;
  final String urlToImage;
  final String publishedAt;

  News(this.title, this.description, this.author, this.urlToImage, this.publishedAt);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: NewsHome(),

    );
  }
}


class NewsHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NewsState();
    throw UnimplementedError();
  }

}

class _NewsState extends State<NewsHome>{

  Future <List<News>> getNews() async {
    var data = await http.get(
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=abde576eac1749d2bddc6287822cbb14'
    );
    var jsonData = json.decode(data.body);
    var newsData = jsonData['articles'];
    List<News> news = [];
    for(var data in newsData){
      News newsItem = News(
        data['title'],
        data['description'],
        data['author'],
        data['urlToImage'],
        data['publishedAt'],
      );
      news.add(newsItem);

    }
    return news;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Headline News'),
      ),
      body: Container(
        child: FutureBuilder(
          future: getNews(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: (){
                      News news = new News(snapshot.data[index].title,
                          snapshot.data[index].description,
                          snapshot.data[index].author,
                          snapshot.data[index].urlToImage,
                          snapshot.data[index].publishedAt);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => new Detail(news))
                      );
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            width: 120.0,
                            height: 120.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0)
                              ),
                              child: (snapshot.data[index].urlToImage == null)
                              ?Image.network('https://www.bing.com/images/search?view=detailV2&ccid=MKQV%2bbgw&id=C6234BE27971CA8D69897DD27520ED998A72CF4E&thid=OIP.MKQV-bgwRP7xGPnrUmi2_QFxCp&mediaurl=https%3a%2f%2ffiles.northernbeaches.nsw.gov.au%2fsites%2fdefault%2ffiles%2fstyles%2fgi--main-thumbnail%2fpublic%2fimages%2fgeneral-information%2flatest-news%2flatest-news.jpg%3fitok%3dWZeytozR&exph=396&expw=863&q=news+image+jpg&simid=608038687466524485&ck=65FFAA893334305B6D0BF28D53152369&selectedIndex=5&qpvt=news+image+jpg')
                              :Image.network(
                                snapshot.data[index].urlToImage,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(snapshot.data[index].title),
                              subtitle: Text(snapshot.data[index].author == null
                                  ?'Unknow': snapshot.data[index].author),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
    throw UnimplementedError();
  }

}
class Detail extends StatelessWidget{
  final News news;
  Detail(this.news);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 350,
                    child: Image.network(
                      this.news.urlToImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                  AppBar(
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    elevation: 0,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text(this.news.title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                    wordSpacing: 0.6
                  ),),
                  SizedBox(height: 20,),
                  Text(
                    this.news.description,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      letterSpacing: 0.2,
                      wordSpacing: 0.3
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        this.news.author == null
                            ?'Unknow' : this.news.author,
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      Text(
                        this.news.publishedAt,
                        style: TextStyle(
                          color: Colors.blueGrey,
                            fontSize: 16,
                            letterSpacing: 0.2,
                            wordSpacing: 0.3
                        ),
                      )
                    ],
                  )
                ],
              ),
              )
            ],
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }

}