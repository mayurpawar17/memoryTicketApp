// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_event.dart';
// import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_state.dart';
// import 'package:memory_ticket_app/features/auth/presentation/widgets/auth_button.dart';
// import 'package:memory_ticket_app/features/auth/presentation/widgets/auth_text_field.dart';
//
// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});
//
//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }
//
// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final _emailController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reset Password'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is ForgotPasswordSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message), backgroundColor: Colors.green),
//             );
//             Navigator.pop(context);
//           } else if (state is AuthFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//             );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Forgot your password?',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Enter your email address and we will send you a link to reset your password.',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 32),
//                 AuthTextField(
//                   controller: _emailController,
//                   hintText: 'Email Address',
//                   prefixIcon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Email is required';
//                     if (!value.contains('@')) return 'Invalid email address';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 32),
//                 BlocBuilder<AuthBloc, AuthState>(
//                   builder: (context, state) {
//                     return AuthButton(
//                       text: 'Send Reset Link',
//                       isLoading: state is AuthLoading && state.loadingType == AuthLoadingType.forgotPassword,
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           context.read<AuthBloc>().add(
//                                 ForgotPasswordRequested(
//                                   email: _emailController.text.trim(),
//                                 ),
//                               );
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
