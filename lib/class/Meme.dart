// ignore_for_file: non_constant_identifier_names

import 'dart:html';

class Meme {
  int id;
  String image;
  String up_text;
  String down_text;
  int users_id;
  int like; 
  int visible;

  List? comments;

  Meme(
      {required this.id, 
      required this.image,
      required this.up_text,
      required this.down_text,
      required this.users_id,
      required this.like,
      required this.comments,
      required this.visible
      });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json['id'] as int,
      image: json['image'] as String,
      up_text: json['up_text'] as String,
      down_text: json['down_text'] as String,
      users_id: json['users_id'] as int,
      like: json['like'] as int,
      comments: json['comments'],
      visible: json['visible']
    );
  }
}