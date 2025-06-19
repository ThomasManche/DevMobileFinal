import 'package:flutter/material.dart';
import 'page_echecs.dart';

// ______________________________________________________________________________________________________________________________________________________
// Widget Champ pour les noms des joueurs
// ______________________________________________________________________________________________________________________________________________________
Widget ChampJoueur(
    {required TextEditingController controller,
    required String label,
    required double width,
    required double height}) {
  return Container(
    width: width,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

// ______________________________________________________________________________________________________________________________________________________
// Widget Timer
// ______________________________________________________________________________________________________________________________________________________
class TimerWidget extends StatefulWidget {
  final Function(int) onMinutesChanged; // Callback pour notifier le parent

  TimerWidget({required this.onMinutesChanged});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int minutes = 10;

  void _updateMinutes(int value) {
    setState(() {
      minutes = value;
    });
    widget.onMinutesChanged(minutes); // Notifie le parent
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (minutes > 1) _updateMinutes(minutes - 1);
          },
        ),
        Text(
          '$minutes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            if (minutes < 60) _updateMinutes(minutes + 1);
          },
        ),
      ],
    );
  }
}

// ______________________________________________________________________________________________________________________________________________________
// Widget pour le bouton Valider
// ______________________________________________________________________________________________________________________________________________________
// Bouton Valider avec passage du context
Widget ButtonValider(BuildContext context, TextEditingController namePlayer1,
    TextEditingController namePlayer2, int minutes) {
  return ElevatedButton(
    onPressed: () {
      // Ici, context est passé depuis la page parente
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PageEchecs(
                  minutes: minutes,
                  namePlayer1: namePlayer1,
                  namePlayer2: namePlayer2,
                )), // Navigation vers PageEchecs()
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 255, 17),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      textStyle: const TextStyle(fontSize: 18),
    ),
    child: const Text('Valider'),
  );
}
