// import 'package:flutter/material.dart';
// import '../auth/services.dart';
// import '../profile/profile_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   bool isLoading = false;
//
//   final AuthService authService = AuthService();
//
//   Future login() async {
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//
//       final data = await authService.login(
//         usernameController.text,
//         passwordController.text,
//       );
//
//       print(data);
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const ProfileScreen(),
//         ),
//       );
//
//     } catch (e) {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Login Failed'),
//         ),
//       );
//
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//
//         child: Column(
//           children: [
//
//             TextField(
//               controller: usernameController,
//               decoration: const InputDecoration(
//                 labelText: "Username",
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Password",
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             ElevatedButton(
//               onPressed: login,
//               child: isLoading
//                   ? const CircularProgressIndicator()
//                   : const Text("Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }