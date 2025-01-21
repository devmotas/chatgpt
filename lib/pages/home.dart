import 'dart:async';
import 'dart:convert';

import 'package:new_chatgpt/components/answersQuestions.dart';
import 'package:new_chatgpt/components/clearChat.dart';
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../components/homeIntroduction.dart';
import '../components/inputChatgpt.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _inputController = TextEditingController();
  String _answer = "";
  List<Map<String, String>> allData = [];
  final apiKey = dotenv.env['API_KEY'];
  String apiUrl = "https://api.openai.com/v1/completions";
  final ScrollController _scrollController = ScrollController();
  AppinioSocialShare appinioSocialShare = AppinioSocialShare();

  int pauseDuration = 0;

  Future<void> scrollDown() async {
    while (pauseDuration > 0) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      pauseDuration -= 200;
    }
  }

  void _uploadData() {
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
                onTap: () => {Navigator.pushNamed(context, '/profile')},
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
                        ? AnswersQuestions(allData: allData)
                        : const HomeIntroduction(),
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
                          ? ClearChat(clear: _clearAllData)
                          : Container(),
                      InputChatgpt(
                        inputController: _inputController,
                        onPressed: _uploadData,
                      )
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
