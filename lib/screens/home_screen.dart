import 'package:flutter/material.dart';
import 'package:new_app_api_integration/gateway/news_gateway.dart';
import 'package:new_app_api_integration/model/news.dart';
import 'package:new_app_api_integration/services/data%20provider/data_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  News? news;
  String selectedNewsType = NewsGateway.allHeadlinesNews;

  final List<Map<String, String>> newsTypes = [
    {"name": "All News", "url": NewsGateway.allHeadlinesNews},
    {"name": "Business News", "url": NewsGateway.allBusinessNews},
    {"name": "Teach News", "url": NewsGateway.allTeachNews},
    {"name": "News Articles", "url": NewsGateway.allNewsArticles},
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final data = await DataProvider.getNews(selectedNewsType);
    setState(() {
      news = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: newsTypes.map((type) {
                final isSelected = type['url'] == selectedNewsType;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint(type['name']);
                        setState(() {
                          selectedNewsType = type['url']!;
                          news = null;
                          getData();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.deepPurpleAccent[700]
                            : Colors.grey,
                      ),
                      child: Text(
                        type['name']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Center(
              child: news == null
                  ? const CircularProgressIndicator()
                  : ListView.separated(
                      itemCount: news!.articles!.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        final article = news!.articles![index];
                        return ListTile(
                          title: Text(article.title.toString()),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: SizedBox(
                              height: 60,
                              width: 100,
                              child: article.urlToImage != null
                                  ? FadeInImage.assetNetwork(
                                      placeholder: 'assets/loading.gif',
                                      image: article.urlToImage.toString(),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      fit: BoxFit.cover,
                                      'assets/loading.gif',
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
