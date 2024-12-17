import 'package:flutter/material.dart';
import 'package:flutter_user/pages/login/login.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../loadingPage/loading.dart';
import '../login/loginScreen.dart';
import '../noInternet/noInternet.dart';
import '../onTripPage/map_page.dart';


class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  bool _faqCompleted = false;
  bool _isLoading = true;
  dynamic _selectedQuestion;

  @override
  void initState() {
    faqDatas();
    super.initState();
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginscreen()),
        (route) => false);
  }

//get faq data
  faqDatas() async {
    if (currentLocation != null) {
      await getFaqData(currentLocation.latitude, currentLocation.longitude);
      setState(() {
        _faqCompleted = true;
        _isLoading = false;
      });
    } else {
      var loc = await Location.instance.getLocation();
      await getFaqData(loc.latitude, loc.longitude);
      setState(() {
        _faqCompleted = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("FAQ'S"),
        leading: BackButton(),
      ),
      body: Material(
        
        child: ValueListenableBuilder(
            valueListenable: valueNotifierBook.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Stack(
                  children: [

                    Column(
                      children: [
                        Container(
                          width: media.width,
                          color: Colors.white,
                          child: Column(
                            children: [
                    
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: media.width*0.04,vertical:media.width*0.05 ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Search',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                    
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: media.height * 1,
                            width: media.width ,
                            color: Colors.grey.shade200,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                              
                                SizedBox(height: 16),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: media.width*0.04,vertical:media.width*0.02 ),
                                  child: Text(
                                    'How can we help you?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                (faqData.isNotEmpty)
                                    ? SingleChildScrollView(
                                      child: Column(
                                          children: [
                                            Column(
                                              children: faqData
                                                  .asMap()
                                                  .map((i, value) {
                                                    return MapEntry(
                                                        i,
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedQuestion = i;
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => FAQDetailScreen(ans: faqData[i]['answer'],question:faqData[i]['question'] ,),
                                                                ),
                                                              );
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(07),
                                                            ),
                                                            padding: EdgeInsets.symmetric(horizontal: media.width*0.04,vertical: media.width*0.04),
                                                            margin: EdgeInsets.symmetric(horizontal: media.width*0.04,vertical: media.width*0.02),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                            
                                                                Expanded(child: Text(faqData[i]['question'])),
                                                                // MyText(
                                                                //   text: faqData[i]['question'],
                                                                //   size: media.width * fourteen,
                                                                //   fontweight: FontWeight.w600,
                                                                // ),
                                                                Icon(Icons.arrow_forward_ios,color: Colors.grey,),
                                                            
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                                  })
                                                  .values
                                                  .toList(),
                                            ),
                                            (myFaqPage['pagination'] != null)
                                                ? (myFaqPage['pagination']
                                                            ['current_page'] <
                                                        myFaqPage['pagination']
                                                            ['total_pages'])
                                                    ? InkWell(
                                                        onTap: () async {
                                                          dynamic val;
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          val = await getFaqPages(
                                                              '${center.latitude}/${center.longitude}?page=${myFaqPage['pagination']['current_page'] + 1}');
                                                          if (val == 'logout') {
                                                            navigateLogout();
                                                          }
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(
                                                              media.width * 0.025),
                                                          margin: EdgeInsets.only(
                                                              bottom:
                                                                  media.width * 0.05),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10),
                                                              color: page,
                                                              border: Border.all(
                                                                  color: borderLines,
                                                                  width: 1.2)),
                                                          child: Text(
                                                            languages[choosenLanguage]
                                                                ['text_loadmore'],
                                                            style:
                                                                GoogleFonts.notoSans(
                                                                    fontSize:
                                                                        media.width *
                                                                            sixteen,
                                                                    color: textColor),
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                                : Container()
                                          ],
                                        ),
                                    )
                                    : (_faqCompleted == true)
                                        ? MyText(
                                            text: languages[choosenLanguage]
                                                ['text_noDataFound'],
                                            size: media.width * eighteen,
                                            fontweight: FontWeight.w600,
                                          )
                                        : Container()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
      
                    //no internet
                    (internet == false)
                        ? Positioned(
                            top: 0,
                            child: NoInternet(
                              onTap: () {
                                setState(() {
                                  internetTrue();
                                  _isLoading = true;
                                  _faqCompleted = false;
                                  faqDatas();
                                });
                              },
                            ))
                        : Container(),
      
                    //loader
                    (_isLoading == true)
                        ? const Positioned(top: 0, child: Loading())
                        : Container()
                  ],
                ),
              );
            }),
      ),
    );
  }
}


class FAQDetailScreen extends StatelessWidget {
  final String question;
  final String ans;

  FAQDetailScreen({required this.question,required this.ans});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('FAQ Detail'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){

              },
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              ans,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}