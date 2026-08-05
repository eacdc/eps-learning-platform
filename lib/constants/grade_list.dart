import 'package:flutter/material.dart';

class Grade {
  final int value;
  final String name;

  Grade({
    required this.value,
    required this.name,
  });
}

final List<Grade> gradeList = [
  Grade(value: 1, name: "CP1"),
  Grade(value: 2, name: "CE1"),
  Grade(value: 3, name: "CM1"),
  Grade(value: 4, name: "6e"),
  Grade(value: 5, name: "5e"),
  Grade(value: 6, name: "4e"),
  Grade(value: 7, name: "3e"),
  Grade(value: 8, name: "2e"),
  Grade(value: 9, name: "1re"),
  Grade(value: 10, name: "Tle"),
];
