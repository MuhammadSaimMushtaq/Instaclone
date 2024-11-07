import 'package:flutter/material.dart';
import 'package:instaclone/serices/firebaseserice.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseSerice? firebaseSerice;

  @override
  void initState() {
    super.initState();
    firebaseSerice = FirebaseSerice();
  }

  @override
  Widget build(BuildContext context) {
    Stream posts = firebaseSerice!.getposts();
    return StreamBuilder(
      stream: posts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List data = snapshot.data.docs.map(
            (e) {
              e.data.toList();
            },
          );
          return GridView.builder(
            itemCount: data.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Image.network(data[index]['image']);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
