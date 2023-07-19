import 'package:flutter/material.dart';
import 'package:project/utils/constants/snack_bar.dart';
import 'package:project/views/auths/login_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_ctrls/auth_ctrl.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isLoading = context.watch<AuthController>().isLoading;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -13,
        title: Text(
          "Forgot Password",
          style: TextStyle(fontSize: 20, color: Colors.grey[500]),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AuthController>().setLoading(false);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
      ),
      body: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          width: width,
          height: height * 0.6,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Input new password",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: TextField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 15)),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Input confirm password",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: TextField(
                  controller: _confirmPasswordCtrl,
                  decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 15)),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.email.isEmpty) {
                    snackBar(context, "Reset password falis");
                  } else if (_passwordCtrl.text.isEmpty) {
                    snackBar(context, "Please input password");
                  } else if (_confirmPasswordCtrl.text != _passwordCtrl.text) {
                    snackBar(context, "Password confirm incorrect");
                  } else {
                    context.read<AuthController>().setLoading(true);
                    context
                        .read<AuthController>()
                        .setNewPassword(widget.email, _passwordCtrl.text,
                            _confirmPasswordCtrl.text)
                        .then((value) {
                      if (value) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                          return const LoginView();
                        }), (route) => false);
                      }
                      snackBar(context, "Reset Password falis");
                    });
                  }
                },
                child: Container(
                  width: width,
                  height: height * 0.08,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
