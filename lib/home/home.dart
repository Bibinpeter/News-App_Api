import 'dart:convert';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:news/constant/cobnstant.dart';
import 'package:news/data/data.dart';
import 'package:news/main.dart';
import 'package:news/widget/article.dart';
import 'package:news/widget/dropdownwidget.dart';
import 'package:news/widget/headline.dart';
import 'package:news/widget/wrapindicator.dart';
import 'package:switcher_button/switcher_button.dart';

class MyAppState extends State<MyApp> {
  dynamic cName;
  dynamic country;
  dynamic category;
  dynamic findNews;
  int pageNum = 1;
  bool ispageloading = false;
  late ScrollController controller;
  int pageSize = 10;
  bool isSwitched = false;
  List<dynamic> news = [];
  bool notFound = false;
  List<int> data = [];
  bool isloading = false;
  String baseApi = 'https://newsapi.org/v2/top-headlines?';

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEWS',
      theme: isSwitched
          ? ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              brightness: Brightness.light,
            )
          : ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              brightness: Brightness.dark,
            ),
      home: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 32),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (country != null)
                    Text('Country = $cName')
                  else
                    Container(),
                  const SizedBox(height: 10),
                  if (category != null)
                    Text('Category = $category')
                  else
                    Container(),
                  const SizedBox(height: 20),
                ],
              ),
              ExpansionTile(
                title: const Text("COUNTRY"),
                children: <Widget>[
                  for (int i = 0; i < listOfCountry.length; i++)
                    DropDownList(
                        name: listOfCountry[i]['name']!.toUpperCase(),
                        call: () {
                          country = listOfCountry[i]['code'];
                          cName = listOfCountry[i]['name']!.toUpperCase();
                          getNews();
                        })
                ],
              ),
              ExpansionTile(
                title: const Text('Category'),
                children: [
                  for (int i = 0; i < listOfCategory.length; i++)
                    DropDownList(
                      call: () {
                        category = listOfCategory[i]['code'];
                        getNews();
                      },
                      name: listOfCategory[i]['name']!.toUpperCase(),
                    )
                ],
              ),
              ExpansionTile(
                title: const Text('Channel'),
                children: [
                  for (int i = 0; i < listOfNewsChannel.length; i++)
                    DropDownList(
                      call: () =>
                          getNews(channel: listOfNewsChannel[i]['code']),
                      name: listOfNewsChannel[i]['name']!.toUpperCase(),
                    ),
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent.withOpacity(0.5),
          centerTitle: true,
          title:  const headlinewidget(),
          actions: [
            AnimSearchBar(
              color: Colors.blueGrey,
              textFieldIconColor: Colors.amberAccent,
              helpText: "find keyword",
              width: 270,  
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              },
              onSubmitted: (String val) async {
                setState(() {
                  findNews = val;
                });
                await getNews(searchKey: findNews);
              },
            ),
            const SizedBox(width: 10,),
            SwitcherButton(
              offColor: const Color.fromARGB(221, 135, 134, 134),
              size: 42,
              value: isSwitched,
              onChange: (value) {
                setState(() {
                  isSwitched = value;
                });
               // print(value);
              },
            ),
             const SizedBox(width: 10,),
          ],
        ),
        body: WarpIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 2)),
          child: notFound
              ? const Center(
                  child: Text('Not Found', style: TextStyle(fontSize: 30)),
                )
              : news.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.yellow,
                      ),
                    )
                  : ListView.builder(
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (BuildContext context) =>
                                            ArticleNews(
                                          newsUrl: news[index]['url'] as String,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            if (news[index]['urlToImage'] ==
                                                null)
                                              Container()
                                            else
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  placeholder:
                                                      (BuildContext context,
                                                              String url) =>
                                                          Container(),
                                                  errorWidget:
                                                      (BuildContext context,
                                                              String url,
                                                              error) =>
                                                          const SizedBox(),
                                                  imageUrl: news[index]
                                                      ['urlToImage'] as String,
                                                ),
                                              ),
                                            Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: Card(
                                                elevation: 10,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.8),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  child: Text(
                                                    "${news[index]['source']['name']}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Text(
                                          "${news[index]['title']}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (index == news.length - 1 && isloading)
                              const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.yellow,
                                ),
                              )
                            else
                              const SizedBox(),
                          ],
                        );
                      },
                      itemCount: news.length,
                    ),
        ),
      ),
    );
  }

  Future<void> getDataFromApi(String url) async {
    final http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      if (jsonDecode(res.body)['totalResults'] == 0) {
        notFound = !isloading;
        setState(() => false);
      } else {
        if (isloading) {
          final newData = jsonDecode(res.body)['articles'] as List<dynamic>;
          for (final e in newData) {
            news.add(e);
          }
        } else {
          news = jsonDecode(res.body)['articles'] as List<dynamic>;
        }
        setState(() {
          notFound = false;
          isloading = false;
        });
      }
    } else {
      setState(() => notFound = true);
    }
  }

  Future<void> getNews({
    String? channel,
    String? searchKey,
    bool reload = false,
  }) async {
    setState(() => notFound = false);

    if (!reload && !isloading) {
    } else {
      country = null;
      category = null;
    }
    if (isloading) {
      pageNum++;
    } else {
      setState(() => news = []);
      pageNum = 1;
    }
    baseApi = 'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&';

    baseApi += country == null ? 'country=in&' : 'country=$country&';
    baseApi += category == null ? '' : 'category=$category&';
    baseApi += 'apiKey=$apiKey';
    if (channel != null) {
      country = null;
      category = null;
      baseApi =
          'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&sources=$channel&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
    }
    if (searchKey != null) {
      country = null;
      category = null;
      baseApi =
          'https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apiKey=58b98b48d2c74d9c94dd5dc296ccf7b6';
    }
    print(baseApi);
    getDataFromApi(baseApi);
  }

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    getNews();
    super.initState();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() => isloading = true);
      getNews();
    }
  }
}

