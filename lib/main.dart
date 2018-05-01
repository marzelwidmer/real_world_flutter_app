import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWoldState();
  }
}

class RealWoldState extends State<RealWorldApp> {
  var _isLoading = true;
  var videos;

  _fetchData() async {
    print("Attempting to fetch data from network.");
    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosJson = map["videos"];
      this.videos = videosJson;

      // videosJson.forEach((video){
      //     // print(video["name"]);
      //     var v = new Video.fromJson(video);
      //     print(v.name);
      // });

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Real World App Bar"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  print("Reloading....");
                  setState(() {
                    _isLoading = true;
                  });

                  _fetchData();
                }),
          ],
        ),
        body: new Center(
            child: _isLoading
                ? new CircularProgressIndicator()
                : new ListView.builder(
                    itemCount: this.videos != null ? this.videos.length : 0,
                    itemBuilder: (context, i) {
                      final video = this.videos[i];
                      return new Column(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(16.0),
                            child: new Column(
                              children: <Widget>[
                                new Image.network(video["imageUrl"]),
                                new Container(height: 6.0,),
                                new Text(video["name"]),
                              ],
                            ),
                          ),
                          new Divider()
                        ],
                      );
                      // return new Text("Row $i");
                    })),
      ),
    );
  }
}

// {
// "id": 1,
// "name": "Instagram Firebase - Learn How to Create Users, Follow, and Send Push Notifications",
// "link": "https://www.letsbuildthatapp.com/course/instagram-firebase",
// "imageUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/04782e30-d72a-4917-9d7a-c862226e0a93",
// "numberOfViews": 20000,
// "channel": {
// "name": "Lets Build That App",
// "profileImageUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/dda5bc77-327f-4944-8f51-ba4f3651ffdf",
// "numberOfSubscribers": 100000
// }
class Video {
  final int id;
  final String name;
  final String link;
  final String imageUrl;

  Video({this.id, this.name, this.link, this.imageUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      imageUrl: json['imageUrl'],
    );
  }
}
