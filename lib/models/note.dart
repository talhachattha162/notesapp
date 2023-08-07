import 'package:flutter/material.dart';

class Note {

  final String id;
  final String title;
  final String content;
  final int color;
  final String? uploadedby;

  Note({required this.id,required this.title, required this.content, required this.color,required this.uploadedby});

}