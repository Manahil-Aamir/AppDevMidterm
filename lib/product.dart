import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/launch_model.dart';

//import 'package:productdisplay/models/product_model.dart';

class SpaceDisplay extends StatefulWidget {
  const SpaceDisplay({super.key});


  @override
  State<SpaceDisplay> createState() => _SpaceDisplayState();
}

class _SpaceDisplayState extends State<SpaceDisplay> {

  
   late Future<List<Launch>> futureSpaceList;

  Future<List<Launch>> fetchSpace() async{
    Uri uriobject = Uri.parse('https://api.spacexdata.com/v3/missions');
    
    final response = await http.get(uriobject);
    print(response.body);
    if(response.statusCode == 200){
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      print('hi');

      List<Launch> itemsList = List<Launch>.from(
        parsedListJson.map<Launch>(
          (dynamic prod) => Launch.fromJson(prod),
        ).toList(),
      );
      print(itemsList);
      return itemsList;
      }

      else{
          throw Exception('Failed to find json');
    }

  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureSpaceList = fetchSpace();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Space Missions',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 25.0,
      ),),
      backgroundColor: Colors.cyan[900],),
body: SafeArea(
        child: FutureBuilder(
          future: futureSpaceList, 
          builder: ((context, snapshot) {
            print(snapshot);
          if (snapshot.hasData) {
           return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var space = snapshot.data![index];
return Card(
  child: Text('hello')
  );
},
            );
        
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Text('text loading');
        }),)
          
        ),
      );
  }
}