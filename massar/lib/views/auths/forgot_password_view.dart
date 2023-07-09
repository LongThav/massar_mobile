import 'package:flutter/material.dart';
import 'package:project/views/auths/verify_code_pin_view.dart';
import 'package:provider/provider.dart';

import '../../constants/snack_bar.dart';
import '../../controllers/auth_ctrls/auth_ctrl.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
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
              Padding(
                padding: EdgeInsets.only(right: width * 0.5),
                child: Text(
                  "Your Email Address",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: TextField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 15)),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              GestureDetector(
                onTap: () {
                  if (_emailCtrl.text.isEmpty) {
                    snackBar(context, "Please input your email");
                  } else {
                    context.read<AuthController>().setLoading(true);
                    context
                        .read<AuthController>()
                        .forgotPasswordController(_emailCtrl.text)
                        .then((value) {
                      if (value) {
                        snackBar(
                            context, "Check your email Inbox for code pin");
                        Future.delayed(const Duration(milliseconds: 600), () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CodePinView(
                              email: _emailCtrl.text,
                            );
                          }));
                        });
                      }
                      snackBar(context, "Input your email is not exits");
                     // _emailCtrl.text = "";
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
                            "Sent Pin",
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
