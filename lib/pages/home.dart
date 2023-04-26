import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _inputController = TextEditingController();
  String _answer = "";
  List<Map<String, String>> allData = [];

  Future<void> _sendInput() async {
    String prompt = _inputController.text;
    String apiUrl = "https://api.openai.com/v1/engines/davinci/completions";
    String apiKey = "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";

    allData.add({'question': prompt, 'answer': ''});

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
      "Accept-Charset": "utf-8"
    };

    String body =
        '{"prompt": "$prompt", "max_tokens": 200, "temperature": 0.9}';
    http.Response response =
        await http.post(Uri.parse(apiUrl), headers: headers, body: body);
    dynamic jsonResponse = jsonDecode(response.body);
    print(body);
    String answer = jsonResponse != null && jsonResponse.containsKey("choices")
        ? utf8.decode(jsonResponse["choices"][0]["text"].toString().codeUnits)
        : "No answer provided";

    allData.last['answer'] = answer;

    setState(() {
      _answer = answer;
      _inputController.text = '';
      print(_answer);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
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
                onTap: () => Navigator.pushNamed(context, '/profile'),
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
                child: SingleChildScrollView(
                  child: allData.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            allData.length,
                            (index) => Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    allData[index]['question']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  color: const Color.fromRGBO(47, 50, 49, 1.0),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        allData[index]['answer']!,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        speed: const Duration(milliseconds: 30),
                                      ),
                                    ],
                                    totalRepeatCount: 1,
                                    pause: Duration(
                                        milliseconds: 500 *
                                            allData[index]['answer']!.length),
                                  ),
                                ),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
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
                        onPressed: _sendInput,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
