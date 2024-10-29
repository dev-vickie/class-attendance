import 'package:flutter/material.dart';

class NameRow extends StatefulWidget {
  final String name;
  final Map<int, DateTime> nameOccurrences;
  final Function(int) onCheckboxTapped;

  const NameRow({
    required this.name,
    required this.nameOccurrences,
    required this.onCheckboxTapped,
    required Null Function(dynamic percentage) onCheckboxTap,
    Map<int, DateTime>? currentOccurrences,
  });

  @override
  State<NameRow> createState() => _NameRowState();
}

class _NameRowState extends State<NameRow> {
  @override
  Widget build(BuildContext context) {
    if (widget.name.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget if name is blank
    }

    List<Widget> columnsWithTitles = [];

    columnsWithTitles.add(
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.name),
            ],
          ),
        ),
      ),
    );

    for (int i = 0; i < 12; i++) {
      final percentage = (i + 1) * 8;
      final isChecked = widget.nameOccurrences.containsKey(percentage);
      columnsWithTitles.add(
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$percentage',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Checkbox(
                value: isChecked,
                onChanged: isChecked
                    ? null
                    : (_) => widget.onCheckboxTapped(percentage),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.0),
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: columnsWithTitles,
        ),
      ),
    );
  }
}
