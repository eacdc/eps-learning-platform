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
  Grade(value: 1, name: "Niveau 1"),
  Grade(value: 2, name: "Niveau 2"),
  Grade(value: 3, name: "Niveau 3"),
  Grade(value: 4, name: "Niveau 4"),
  Grade(value: 5, name: "Niveau 5"),
  Grade(value: 6, name: "Niveau 6"),
  Grade(value: 7, name: "Niveau 7"),
  Grade(value: 8, name: "Niveau 8"),
  Grade(value: 9, name: "Niveau 9"),
  Grade(value: 10, name: "Niveau 10"),
  Grade(value: 11, name: "Niveau 11"),
  Grade(value: 12, name: "Niveau 12"),
];
