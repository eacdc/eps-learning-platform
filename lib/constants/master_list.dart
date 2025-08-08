import 'package:flutter/material.dart';

class SortOption {
  final String label;
  final String value;

  SortOption({required this.label, required this.value});
}

final List<SortOption> sortOptions = [
  SortOption(label: "Title", value: "title"),
  SortOption(label: "Subject", value: "subject"),
  SortOption(label: "Grade", value: "grade"),
  SortOption(label: "Publisher", value: "publisher"),
  SortOption(label: "Date Created", value: "createdAt"),

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
  SortOrderOption(label: "Ascending", value: "asc", icon: Icons.arrow_upward),
  SortOrderOption(
    label: "Descending",
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
  SubjectOption(label: "Science", value: "science"),
  SubjectOption(label: "Math", value: "Math"),
  SubjectOption(label: "Physics", value: "physics"),


];













final List<CustomerType> customerTypeList = [
  CustomerType(
    name: "Domestic",
    value: 1,
    desc: "Domestic Customer",
    icon: "assets/icons/png_domestic.png",
    subscription_price: 500.00,
    subscription_period: 365,
    maximum_service: 30,
  ),
  CustomerType(
    name: "Corporate",
    value: 2,
    desc: "Corporate Customer",
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
          name: "Unknown",
          value: 0,
          desc: "Unknown Customer",
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
