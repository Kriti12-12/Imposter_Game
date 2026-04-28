import 'package:flutter/material.dart';
import '../ui/buttiondesign.dart';

Future<int?> openTimeSelector(BuildContext context) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (context) {
      return Container(
        height: 300,
        color: Colors.black,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            /// TITLE
            Text(
              "Select Time",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            SizedBox(height: 20),

            /// 🔥 VERTICAL BUTTONS
            Expanded(
              child: ListView(
                children: [60, 120, 180, 240, 300].map((sec) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: gradientButton("${sec ~/ 60} Minutes", () {
                      Navigator.pop(context, sec);
                    }),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    },
  );
}


Future<bool> confirmDeletePlayer(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text("Remove Player",
                style: TextStyle(color: Colors.white)),
            content: const Text(
              "Are you sure you want to remove this player?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Remove"),
              ),
            ],
          );
        },
      ) ??
      false;
}

Future<String?> openEditPlayerDialog(
    BuildContext context, String currentName) {
  TextEditingController controller =
      TextEditingController(text: currentName);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Edit Name",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter name",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, controller.text),
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}


Future<String?> openAddPlayerSheet(BuildContext context) {
  TextEditingController controller = TextEditingController();

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SizedBox(
          height: 250,
          child: Column(
            children: [
              const Text(
                "Add Player",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter player name",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),

              const SizedBox(height: 20),

              gradientButton("ADD", () {
                Navigator.pop(context, controller.text);
              }),
            ],
          ),
        ), 
      ); 
    },
  );
}