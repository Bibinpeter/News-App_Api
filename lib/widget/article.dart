import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class ArticleNews extends StatefulWidget {
  const ArticleNews({super.key, required this.newsUrl});
final String newsUrl;
  @override
  State<ArticleNews> createState() => _ArticleNewsState();
}

class _ArticleNewsState extends State<ArticleNews> {
  late bool _isLoadingPage;

   @override
  void initState() {
    super.initState();
    _isLoadingPage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("News"),
      ),
      body: Stack(
        children: [
           InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(widget.newsUrl))
            ),
            onWebViewCreated: (controller) {
              controller.addJavaScriptHandler(handlerName: 'onPageFinished', callback: (_) {
                setState(() {
                  _isLoadingPage = false;
                });
              });
            },
          ),
          if(!_isLoadingPage)
          Container(
            alignment: FractionalOffset.center,
            child: const CircularProgressIndicator(
              backgroundColor: Colors.yellow,
            ),
          )else
         const SizedBox.shrink()
        ],
      ),
    );
  }
}