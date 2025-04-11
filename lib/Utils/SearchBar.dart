import 'dart:async';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final List<String> searchHints;

  const SearchWidget({
    Key? key,
    required this.searchController,
    required this.searchHints,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  int hintIndex = 0;
  Timer? hintTimer;
  String currentHint = "";

  @override
  void initState() {
    super.initState();
    _startHintRotation();
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    super.dispose();
  }

  void _startHintRotation() {
    hintTimer = Timer.periodic(const Duration(seconds:3), (timer) {
      setState(() {
        hintIndex = (hintIndex + 1) % widget.searchHints.length;
        _updateHintText();
      });
    });
  }

  void _updateHintText() {
    setState(() {
      currentHint = "";
    });

    String hint = widget.searchHints[hintIndex];
    int length = hint.length;

    for (int i = 0; i < length; i++) {
      Timer(Duration(milliseconds: (i + 1) * 150), () {
        setState(() {
          currentHint = hint.substring(0, i + 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.search, color: Colors.black54, size: 19),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: widget.searchController,
                decoration: InputDecoration(
                  hintText: currentHint.isNotEmpty ? 'Search for $currentHint' : '',
                  border: InputBorder.none,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.arrow_circle_right_outlined,
                  size: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
