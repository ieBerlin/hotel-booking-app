import 'package:fatiel/services/auth/bloc/auth_bloc.dart';
import 'package:fatiel/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelHomeView extends StatelessWidget {
  const HotelHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEventLogOut());
          },
        ),
        title: const Text("Hotel Dashboard"),
        backgroundColor: const Color(0xFFC84648), // Theme primary color
      ),
      body: const Center(
        child: Text(
          "Welcome to the Hotel Dashboard!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
