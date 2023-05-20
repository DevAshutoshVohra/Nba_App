import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba/model/team.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<Team> teams = [];
  String url = 'https://www.balldontlie.io/api/v1/teams';

  Future getData() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));

    var jsonData = jsonDecode(response.body);
    for (var eachTeam in jsonData['data']) {
      final team =
          Team(abbreviation: eachTeam['abbreviation'], city: eachTeam['city']);
      teams.add(team);
    }
    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    getData();

    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Container(decoration:  const BoxDecoration( color: Color.fromARGB(255, 153, 151, 151)),
                    child: ListTile(
                      title: Text(teams[index].abbreviation),
                      subtitle: Text(teams[index].city),
                    ),
                  );
                },
              );
            }
            // if still loading show circular progress indicator  !!!
            else{
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
