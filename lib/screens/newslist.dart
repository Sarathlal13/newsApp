import 'package:flutter/material.dart';
import 'package:news_app/networking.dart';
import 'package:news_app/screens/newsread.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<dynamic> newsList;
  bool isLoading = true;
  bool hasData = false;
  Future<void> loadNews() async {
    NetWorking newsCenter = NetWorking();
    var newsData = await newsCenter.getDatafromServer();
    newsList = newsData["articles"];
    if (newsList.length != 0) {
      setState(() {
        hasData = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home_filled),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "LATEST NEWS",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 3,
                  color: Colors.black,
                ),
                hasData
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            return Card(
                                elevation: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsReadPage(
                                          selectedNews: newsList[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 160,
                                        child: newsList[index]['urlToImage'] !=
                                                null
                                            ? Image.network(
                                                newsList[index]['urlToImage'],
                                                fit: BoxFit.fill,
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace stackTrace) {
                                                  return Text('No Image');
                                                },
                                              )
                                            : Image.network(
                                                'https://images.news18.com/ibnlive/uploads/2021/07/1627283897_news18_logo-1600x900.jpg',
                                                fit: BoxFit.fill,
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace stackTrace) {
                                                  return Text('No Image');
                                                },
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Column(
                                            children: [
                                              Text(
                                                newsList[index]['title'] ??
                                                    'No title',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              Text(
                                                newsList[index]
                                                        ['description'] ??
                                                    'No Description',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                                //overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          },
                        ),
                      )
                    : Center(
                        child: Text('No Data'),
                      )
              ],
            ),
    );
  }
}
