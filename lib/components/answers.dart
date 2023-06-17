import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Answers extends StatelessWidget {
  List<Map<String, String>> allData = [];
  var index = 0;

  Answers({required this.allData, required this.index, super.key});

  Future<void> downloadImage(String image) async {}

  Future<void> shareImage(image) async {
    final ByteData imageData = await rootBundle.load('assets/images/user.png');
    final List<int> bytes = imageData.buffer.asUint8List();

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File imageFile = File('$tempPath/image.jpg');
    await imageFile.writeAsBytes(bytes);
    final String filePath = imageFile.path;

    // await AppinioSocialShare.shareToWhatsapp('message', filePath: filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: const Color.fromRGBO(47, 50, 49, 1.0),
        child: allData[index]['answer']! == 'Buscando....'
            ? Text(
                allData[index]['answer']!,
                style: const TextStyle(color: Colors.white),
              )
            : allData[index]['type'] == 'text'
                ? AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        allData[index]['answer']!,
                        textStyle: const TextStyle(color: Colors.white),
                        speed: const Duration(milliseconds: 30),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: Duration(
                        milliseconds: 500 * allData[index]['answer']!.length),
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
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                    2,
                                    MediaQuery.of(context).size.height / 2,
                                    1,
                                    0),
                                items: [
                                  const PopupMenuItem(
                                    value: 'download',
                                    child: Text('Baixar'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'share',
                                    child: Text('Compartilhar'),
                                  ),
                                ],
                                elevation: 8.0,
                              ).then((value) {
                                if (value == 'download') {
                                  downloadImage(allData[index]['answer']!);
                                } else if (value == 'share') {
                                  shareImage(allData[index]['answer']);
                                }
                              });
                            },
                          )),
                    ],
                  ));
  }
}
