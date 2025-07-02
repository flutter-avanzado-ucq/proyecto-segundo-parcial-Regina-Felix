import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 66, 203, 221), Color.fromARGB(255, 156, 151, 157)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=47',
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                // Cambio de icono
                'Hola, Regina',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'Estas son tus tareas para hoy',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }
}