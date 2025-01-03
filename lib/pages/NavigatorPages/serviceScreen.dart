import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../widgets/appbar.dart';

class Servicescreen extends StatefulWidget {
  String serviceData;
  Servicescreen({required this.serviceData});

  @override
  State<Servicescreen> createState() => _ServicescreenState();
}

class _ServicescreenState extends State<Servicescreen> {

  @override
  void initState() {
    // TODO: implement initState
    getCommonCMS();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColors,

      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(left: media.width*0.03,right: media.width*0.03,top: media.width*0.12,bottom:media.width*0.02 ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBarWithoutHeightWidget(context: context,
                  onTaps: (){
                    Navigator.pop(context);
                  },
                  backgroundIcon: Color(0xffECECEC), title: "",iconColors: iconGrayColors),
              SizedBox(height: media.width*0.02,),
              SizedBox(
                  height: media.height,
                  child: WebViewExample(termsData: widget.serviceData=="terms"?terms:widget.serviceData=="aboutAs"?aboutAs:privacyPolicy,)),
            ],
          ),
        ),
      )
    );
  }
}




class WebViewExample extends StatefulWidget {
  String termsData;
  WebViewExample({required this.termsData});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;
  bool isLoading =false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    // Simulate async operation
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    setState(() {
      isLoading =true;
    });

    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      // Load the HTML content into the WebView
      _controller.loadHtmlString(widget.termsData);
    }

    setState(() {
      isLoading =false;
    });
  }

  @override
  void dispose() {
    isLoading = false;
    _controller.runJavaScript("window.close();"); // Safely close the WebView
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColors,

      body:isLoading?Center(child: Container(child: CircularProgressIndicator(color: buttonColors,),)): WebViewWidget(
          controller: _controller,

      ),
    );
  }
}


