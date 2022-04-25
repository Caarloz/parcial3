import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:parcial3/bebidas.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(parcial3());
}

class parcial3 extends StatefulWidget {
  parcial3({Key? key}) : super(key: key);

  @override
  State<parcial3> createState() => _parcial3State();
}

class _parcial3State extends State<parcial3> {
  late Future<List<bebidas>> _listadoBebida;
  //final myController = TextEditingController();
  //String texto_buscar = "";

  @override
  void dispose() {
    //myController.dispose();
    super.dispose();
  }

  Future<List<bebidas>> _getBebida() async {
    final response = await http.get(
        Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/search.php?s="));
    String cuerpo;
    List<bebidas> lista = [];

    if (response.statusCode == 200) {
      print(response.body);
      cuerpo = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(cuerpo);
      for (var item in jsonData["drinks"]) {
        lista.add(bebidas(item["strCategory"], item["strDrinkThumb"]));
      }
    } else {
      throw Exception("Falla en conexion  estado 500");
    }
    return lista;
  }

  @override
  void initState() {
    super.initState();
    //myController.addListener(_printLatestValue);
    _listadoBebida = _getBebida();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listadoBebida,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listadoBebidas(snapshot.data),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consumo Webservice',
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            flexibleSpace: encabezado(),
            toolbarHeight: 180,
          ),
          body: futureBuilder),
    );
  }

  List<Widget> _listadoBebidas(data) {
    List<Widget> bebida = [];
    for (var itempk in data) {
      bebida.add(Card(
        elevation: 2.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(2.0),
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(itempk.img),
                    fit: BoxFit.fitHeight,
                  ),
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              itempk.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ));
    }
    return bebida;
  }

  //void _printLatestValue() {
  //  print('Second text field: ${myController.text}');
  //  texto_buscar = myController.text;
  //}

  Widget encabezado() {
    List categorias = ["Cocteles", "Bebidas comunes", "Café", "Té", "Ponche"];
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.list,
                  size: 40,
                  color: Colors.white,
                ),
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 40,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: TextField(
              //controller: myController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Buscar',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(categorias.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categorias[index],
                                style: TextStyle(
                                    //color: Colors.grey,
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                width: 20,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(5)),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
