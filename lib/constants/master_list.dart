import 'package:flutter/material.dart';

class SortOption {
  final String label;
  final String value;

  SortOption({required this.label, required this.value});
}

final List<SortOption> sortOptions = [
  SortOption(label: "Titre", value: "title"),
  SortOption(label: "Matière", value: "subject"),
  SortOption(label: "Niveau", value: "grade"),
  SortOption(label: "Éditeur", value: "publisher"),
  SortOption(label: "Date de création", value: "createdAt"),

];

class SortOrderOption {
  final String label;
  final String value;
  final IconData icon;

  SortOrderOption({
    required this.label,
    required this.value,
    required this.icon,
  });
}

final List<SortOrderOption> sortOrderOptions = [
  SortOrderOption(label: "Croissant", value: "asc", icon: Icons.arrow_upward),
  SortOrderOption(
    label: "Décroissant",
    value: "desc",
    icon: Icons.arrow_downward,
  ),
];


class SubjectOption {
  final String label;
  final String value;

  SubjectOption({required this.label, required this.value});
}

final List<SubjectOption> subjectOptions = [
  SubjectOption(label: "Sciences", value: "science"),
  SubjectOption(label: "Mathématiques", value: "Math"),
  SubjectOption(label: "Physique", value: "physics"),


];













final List<CustomerType> customerTypeList = [
  CustomerType(
    name: "National",
    value: 1,
    desc: "Client national",
    icon: "assets/icons/png_domestic.png",
    subscription_price: 500.00,
    subscription_period: 365,
    maximum_service: 30,
  ),
  CustomerType(
    name: "Entreprise",
    value: 2,
    desc: "Client entreprise",
    icon: "assets/icons/png_corporate.png",
    subscription_price: 1000.00,
    subscription_period: 365,
    maximum_service: 100,
  ),
];

CustomerType getCustomerTypeById(int? id) {
  return customerTypeList.firstWhere(
    (customertype) => customertype.value == id,
    orElse:
        () => CustomerType(
          name: "Inconnu",
          value: 0,
          desc: "Client inconnu",
          icon: "assets/icons/png_domestic.png",
          subscription_price: 500.00,
          subscription_period: 365,
          maximum_service: 30,
        ),
  );
}

class CustomerType {
  final int value;
  final String name;
  final String desc;
  final String icon;
  final double subscription_price;
  final int subscription_period; // incdays
  final int maximum_service;

  CustomerType({
    required this.value,
    required this.name,
    required this.desc,
    required this.icon,
    required this.subscription_price,
    required this.subscription_period,
    required this.maximum_service,
  });
}
