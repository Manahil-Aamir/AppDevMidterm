import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/launch_model.dart';
import 'package:readmore/readmore.dart';

//import 'package:productdisplay/models/product_model.dart';

class SpaceDisplay extends StatefulWidget {
  const SpaceDisplay({super.key});


  @override
  State<SpaceDisplay> createState() => _SpaceDisplayState();
}

class _SpaceDisplayState extends State<SpaceDisplay> {

  
   late Future<List<Launch>> futureSpaceList;
   bool readmore = false;
  

  Future<List<Launch>> fetchSpace() async{
    Uri uriobject = Uri.parse('https://api.spacexdata.com/v3/missions');
    
    final response = await http.get(uriobject);
    print(response.body);
    if(response.statusCode == 200){
      List<dynamic> parsedListJson = jsonDecode(response.body);
      print(parsedListJson);
      //print('hi');

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

int r = -1;
  Text showText(String s, int i){
   if(i==r){
    return Text(s);
   }
   else{
    return Text(
     '${s}',
     maxLines: 2,
     overflow: TextOverflow.ellipsis,
 );
   }
  }

void setmore(int i){
  if(r==i) setState(() {
    r=-1;
  });
  else setState(() {
    r=i;
  });
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
                var mission = snapshot.data![index];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(mission.missionName.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,
                    ),
                    textAlign: TextAlign.left,),
                    
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          r == index ?  mission.description.toString() : mission.description.toString()+'.......',
                          maxLines: r == index ? 20:1,
                          overflow: TextOverflow.ellipsis,
)
                      )
                    ],
                  ),
                  Row(children: [
                    const Spacer(),
                    ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                              ),
                              backgroundColor: Colors.grey[350],
                              foregroundColor: Colors.blue,
              
              ),
              child: Row(
                children: [
                  Text(r != index ? 'More': 'Less',
                  
                  style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(r!=index ? Icons.arrow_downward : Icons.arrow_upward),
                ],
                
              ),
              onPressed: () {
                setmore(index);
              },
            ),

                  ],),
                  Center(
                    child : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2,
                      child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of columns
                                crossAxisSpacing: 2.0, // Spacing between columns
                               
                              ),
                    
                                  itemCount:  mission.payloadIds?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return Chip(
                                     label: Text(mission.payloadIds![index].toString()),
                                     backgroundColor: Color(Random().nextInt(0xffffffff)),
                                    );
                    
                                  },
                                      ),
                    ),
                  ),
                ],
                
              ),
              );
},
            );
        
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }),)
          
        ),
      );
  }
}