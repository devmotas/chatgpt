import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class Answers extends StatelessWidget {
  List<Map<String, String>> allData = [];
  var index = 0;

  Answers({required this.allData, required this.index, super.key});

  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    try {
      await FlDownloader.initialize();

      FlDownloader.progressStream.listen((DownloadProgress progress) {
        debugPrint('Progresso: ${progress.progress}%');
      });

      final fileName = 'downloaded_image.jpg'; // Nome do arquivo salvo
      await FlDownloader.download(
        imageUrl,
        fileName: fileName,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download iniciado!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer o download: ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> shareImage(String? imageUrl) async {
    try {
      if (imageUrl == null || imageUrl.isEmpty) return;
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempPath = tempDir.path;

        final file = File('$tempPath/shared_image.png');
        await file.writeAsBytes(response.bodyBytes);

        await Share.shareXFiles([XFile(file.path)], text: 'Veja esta imagem!');
      } else {
        throw Exception('Erro ao baixar a imagem');
      }
    } catch (e) {
      print('Erro ao compartilhar a imagem');
    }
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
                                  downloadImage(
                                      context, allData[index]['answer']!);
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
