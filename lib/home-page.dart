import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:presensi/models/home-response.dart';
import 'package:presensi/simpan-page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _name, _token;
  HomeResponseModel? homeResponseModel;
  Datum? hariIni;
  List<Datum> riwayat = [];

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });

    _name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
  }

  Future<void> getData() async {
    final String token = await _token;
    final Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
    };
    var response = await http.get(Uri.parse("https://77a9-36-74-73-69.ngrok-free.app/api/get-presensi"), headers: headers);
    homeResponseModel = HomeResponseModel.fromJson(json.decode(response.body));
    riwayat.clear();
    setState(() {
      homeResponseModel!.data.forEach((element) {
        if (element.isHariIni) {
          hariIni = element;
        } else {
          riwayat.add(element);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: _name,
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(fontSize: 20),
                                );
                              } else {
                                return Text("-", style: TextStyle(fontSize: 20));
                              }
                            }
                          }),
                      SizedBox(height: 50),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                hariIni?.tanggal ?? '-',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        hariIni?.masuk ?? '-',
                                        style: TextStyle(color: Colors.white, fontSize: 25),
                                      ),
                                      Text(
                                        "Masuk",
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        hariIni?.pulang ?? '-',
                                        style: TextStyle(color: Colors.white, fontSize: 25),
                                      ),
                                      Text(
                                        "Pulang",
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text("Riwayat Presensi"),
                      Container(
                        height: 300, // Set a fixed height for ListView
                        child: ListView.builder(
                          itemCount: riwayat.length,
                          itemBuilder: (context, index) => Card(
                            child: ListTile(
                              leading: Text(
                                riwayat[index].tanggal,
                                style: TextStyle(fontSize: 18),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        riwayat[index].masuk,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "Masuk",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        riwayat[index].pulang,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "Pulang",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ],
                              ),
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SimpanPage()))
              .then((value) {
                setState(() {});
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   late Future<String> _name, _token;
//   HomeResponseModel? homeResponseModel;
//   Datum? hariIni;
//   List<Datum> riwayat = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _token = _prefs.then((SharedPreferences prefs) {
//       return prefs.getString("token") ?? "";
//     });

//     _name = _prefs.then((SharedPreferences prefs) {
//       return prefs.getString("name") ?? "";
//     });
//   }

//   Future getData() async {
//     final Map<String, String> headers = {
//       'Authorization': 'Bearer '+ await _token
//     };
//     var response = await http.get(Uri.parse
//     ('http://10.0.2.2:8000/api/get-presensi'),
//      headers: headers);
//     homeResponseModel = HomeResponseModel.fromJson(json.decode(response.body));
//     homeResponseModel!.data.forEach((element) {
//       if (element.isHariIni) {
//         hariIni = element;
//       } else {
//         riwayat.add(element);
//       }
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//   return Scaffold(
//     body: FutureBuilder(
//       future: getData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else {
//                   return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   FutureBuilder(
//                     future: _name,
//                     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator();
//                       } else {
//                         if (snapshot.hasData) {
//                           return Text(
//                         snapshot.data!,
//                         style: TextStyle(fontSize: 20),);
//                         } else {
//                           return Text("-", style: TextStyle(fontSize: 20),);
//                         }
                         
//                       }
//                       }),
        
//                   SizedBox(height: 50),
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             hariIni?.tanggal ?? '-',
//                             style: TextStyle(color: Colors.white, fontSize: 20),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Column(
//                                 children: [
//                                   Text(
//                                     hariIni?.masuk ?? '-',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 25),
//                                   ),
//                                   Text(
//                                     "Masuk",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18),
//                                   )
//                                 ],
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     hariIni?.pulang ?? '-',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 25),
//                                   ),
//                                   Text(
//                                     "Pulang",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Text(
//                     "Riwayat Presensi"
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: riwayat.length,
//                       itemBuilder: (context, index) => 
//                       Card(
//                         child: ListTile(
//                           leading: Text(
//                             "21 Mei 2024",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           title: Row(
//                             children: [
//                               Column(
//                                 children: [
//                                   Text(
//                                     "07.00",
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                   Text(
//                                     "Masuk",
//                                     style: TextStyle(fontSize: 16),
//                                   )
//                                 ],
//                               ),
//                               SizedBox(width: 20),
//                               Column(
//                                 children: [
//                                   Text(
//                                     "17.00",
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                   Text(
//                                     "Pulang",
//                                     style: TextStyle(fontSize: 16),
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Repeat the Card widgets if needed
//                 ],
//               ),
//             ),
//           ),
//         );
//         }

//       }
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => SimpanPage()))
//             .then((value) => (value));
//       },
//       child: Icon(Icons.add),
//     ),
//   );
//   }
// }