import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _inputController = TextEditingController();
  String _answer = "";
  List<Map<String, String>> allData = [];
  final apiKey = dotenv.env['API_KEY'];
  String apiUrl = "https://api.openai.com/v1/completions";
  late FocusNode _focusNode;
  ScrollController _scrollController = ScrollController();
  AppinioSocialShare appinioSocialShare = AppinioSocialShare();

  int pauseDuration = 0;

  Future<void> scrollDown() async {
    while (pauseDuration > 0) {
      await Future.delayed(Duration(milliseconds: 200));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      pauseDuration -= 200;
      print(pauseDuration);
    }
  }

  void _uploadData() {
    _focusNode.unfocus();
    String prompt = _inputController.text;
    setState(() {
      allData
          .add({'question': prompt, 'answer': 'Buscando....', 'type': 'text'});
      _inputController.text = '';
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _sendInput(prompt);
  }

  Future<void> downloadImage(String image) async {
    String images = image;
    String imagen =
        'https://oaidalleapiprodscus.blob.core.windows.net/private/org-QHfd9TDY3TYW1pz812lrAAUk/user-JHYwjh8ZiTA8jLNeiHKaQQpQ/img-Drx0DGIxTuF9If2ntZeEjAML.png?st=2023-05-24T19%3A31%3A40Z&se=2023-05-24T21%3A31%3A40Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-05-24T19%3A56%3A42Z&ske=2023-05-25T19%3A56%3A42Z&sks=b&skv=2021-08-06&sig=XU5BkdrxCbiVb0QqGJUcDPckWZvLTDYfF/ylmQ5QnJ8%3D';
  }

  Future<void> shareImage(image) async {
    final ByteData imageData = await rootBundle.load('assets/images/user.png');
    final List<int> bytes = imageData.buffer.asUint8List();

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File imageFile = File('$tempPath/image.jpg');
    await imageFile.writeAsBytes(bytes);
    final String filePath = imageFile.path;

    await appinioSocialShare.shareToWhatsapp('message', filePath: filePath);
  }

  Future _sendInput(String prompt) async {
    final apiUrl = dotenv.env['API_URL'];

    final response = await http.post(
      Uri.parse('$apiUrl/chat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'apiKey': "$apiKey",
        'prompt': prompt,
      }),
    );

    if (response.statusCode == 200) {
      String trimmedText = '';
      String responseBody = response.body;
      Map<String, dynamic> decodedResponse = json.decode(responseBody);

      if (decodedResponse['type'] == 'text') {
        print('text');
        trimmedText = (decodedResponse['data'] as String)
            .trim()
            .replaceAll(RegExp(r'^\s+|\s+$'), '')
            .replaceAll(RegExp(r'^[^\w]+'), '');

        setState(() {
          allData.last['answer'] = trimmedText;
          allData.last['type'] = decodedResponse['type'];
          _answer = trimmedText;
        });

        pauseDuration = 30 * trimmedText.length;
        scrollDown();
      } else {
        print('image');
        setState(() {
          allData.last['answer'] = decodedResponse['data'];
          allData.last['type'] = decodedResponse['type'];
          _answer = trimmedText;
        });
        pauseDuration = 20000;
        scrollDown();
        const timeout = Duration(seconds: 10);
        Timer(timeout, () {
          pauseDuration = 0;
        });
      }
    } else {
      setState(() {
        allData.last['answer'] = 'Erro ao procurar resposta!';
        allData.last['type'] = 'text';
        _answer = 'Erro ao procurar resposta';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // shareImage('teste');
  }

  void _clearAllData() {
    setState(() {
      allData = [];
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: const Icon(Icons.account_circle_rounded,
                    color: Colors.white),
                onTap: () => {
                  _focusNode.unfocus(),
                  Navigator.pushNamed(context, '/profile')
                },
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(32, 34, 34, 1.0),
          ),
          child: Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      if (_scrollController.position.userScrollDirection ==
                          ScrollDirection.reverse) {
                        pauseDuration = 0;
                      }
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: allData.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              allData.length,
                              (index) => Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      allData[index]['question']!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      color:
                                          const Color.fromRGBO(47, 50, 49, 1.0),
                                      child: allData[index]['answer']! ==
                                              'Buscando....'
                                          ? Text(
                                              allData[index]['answer']!,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )
                                          : allData[index]['type'] == 'text'
                                              ? AnimatedTextKit(
                                                  animatedTexts: [
                                                    TypewriterAnimatedText(
                                                      allData[index]['answer']!,
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      speed: const Duration(
                                                          milliseconds: 30),
                                                    ),
                                                  ],
                                                  totalRepeatCount: 1,
                                                  pause: Duration(
                                                      milliseconds: 500 *
                                                          allData[index]
                                                                  ['answer']!
                                                              .length),
                                                )
                                              : Stack(
                                                  children: [
                                                    Image.network(
                                                      allData[index]['answer']!,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    Positioned(
                                                        top: 16,
                                                        right: 16,
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.more_vert),
                                                          onPressed: () {
                                                            showMenu(
                                                              context: context,
                                                              position: RelativeRect.fromLTRB(
                                                                  2,
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      2,
                                                                  1,
                                                                  0),
                                                              items: [
                                                                const PopupMenuItem(
                                                                  value:
                                                                      'download',
                                                                  child: Text(
                                                                      'Baixar'),
                                                                ),
                                                                const PopupMenuItem(
                                                                  value:
                                                                      'share',
                                                                  child: Text(
                                                                      'Compartilhar'),
                                                                ),
                                                              ],
                                                              elevation: 8.0,
                                                            ).then((value) {
                                                              if (value ==
                                                                  'download') {
                                                                downloadImage(
                                                                    allData[index]
                                                                        [
                                                                        'answer']!);
                                                              } else if (value ==
                                                                  'share') {
                                                                shareImage(allData[
                                                                        index]
                                                                    ['answer']);
                                                              }
                                                            });
                                                          },
                                                        )),
                                                  ],
                                                )),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/logo/chatgpt_logo.svg',
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                const Text(
                                  'Bem vindo ao ChatGPT',
                                  style: TextStyle(
                                      fontSize: 26, color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      allData.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: FloatingActionButton(
                                    onPressed: _clearAllData,
                                    backgroundColor: Colors.red,
                                    child: const Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      TextField(
                        focusNode: _focusNode,
                        controller: _inputController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(47, 50, 49, 1.0),
                          hintText: 'Digite aqui...',
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(153, 153, 153, 1.0),
                              width: 2.0, // Define a espessura da borda
                            ),
                            borderRadius: BorderRadius.circular(
                                8.0), // Define o raio da borda
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(204, 204, 204, 1.0),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.white,
                            onPressed: _uploadData,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
