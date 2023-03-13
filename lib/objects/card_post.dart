import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CardPost extends StatefulWidget {
  String title;
  String content;
  String userID;
  String timeStart;

  CardPost(this.title, this.content, this.userID, this.timeStart);

  @override
  State<CardPost> createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
  final _random2 = Random().nextInt(6),

  emojis = [
    "cry.png", "cry-laugh.png", "dove.png", "face-with-peeking-eye.png", "fish.png", "shark.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(21, 23, 28, 0)),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Color.fromRGBO(21, 23, 28, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  right: 0,
                  child: Transform(
                    transform: Matrix4.identity()..rotateZ(15 * 3.1415927 / 180),
                    alignment: FractionalOffset.center,
                    child: Image.asset(
                      'lib/assets/images/emoji/${emojis[_random2]}',
                      width: 120,
                      height: 120,
                      opacity: const AlwaysStoppedAnimation(.4),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                    Text(
                                      widget.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 28,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Text(
                                    widget.content,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: Colors.white,
                                      height: 1.15,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month,
                                        color: Color.fromRGBO(245, 245, 245, 0.8)),
                                    const SizedBox(width: 5),
                                    Text(
                                      widget.timeStart,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color.fromRGBO(245, 245, 245, 0.8),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 108,
                            child: FutureBuilder(
                              future: _getUsername(),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
                                return Text(
                                  "by ${text.data ?? 'Unknown User'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color.fromRGBO(245, 245, 245, 0.8),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: IconButton(
                              color: Colors.white,
                              onPressed: (){},
                              iconSize: 20,
                              icon: const Icon(Icons.more_horiz)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getUsername() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${widget.userID}/username");
    DataSnapshot snapshot = await ref.get();
    return snapshot.value.toString();
  }
}