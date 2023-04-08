import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(32, 34, 34, 1.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(47, 50, 49, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Image.asset(
                    'assets/images/user.png',
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(children: [
                          Card(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: InkWell(
                              onTap: () {
                                // Aqui você pode adicionar a navegação para outra tela, por exemplo
                              },
                              splashColor: Colors.grey,
                              child: const ListTile(
                                leading:
                                    Icon(Icons.person, color: Colors.black),
                                title: Text(
                                  'Informações usuário',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.only(bottom: 30),
                            child: InkWell(
                              onTap: () {
                                // Aqui você pode adicionar a navegação para outra tela, por exemplo
                              },
                              splashColor: Colors.grey,
                              child: const ListTile(
                                leading:
                                    Icon(Icons.security, color: Colors.black),
                                title: Text(
                                  'Termo de privacidade',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                          Card(
                            child: InkWell(
                              onTap: () {
                                // Aqui você pode adicionar a navegação para outra tela, por exemplo
                              },
                              splashColor: Colors.grey,
                              child: const ListTile(
                                leading:
                                    Icon(Icons.color_lens, color: Colors.black),
                                title: Text(
                                  'Mudar Tema',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
