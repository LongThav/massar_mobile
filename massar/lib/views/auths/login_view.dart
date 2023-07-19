import 'package:flutter/material.dart';
import 'package:project/controllers/auth_ctrls/auth_firebase_ctrl.dart';
import 'package:project/views/auths/register_view.dart';
import 'package:provider/provider.dart';

import '../dashboards/mains_views.dart/index_views.dart';
import '../../utils/constants/snack_bar.dart';
import '../../controllers/auth_ctrls/auth_ctrl.dart';
import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _passwordObscure = true;

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Welcome",
          style: TextStyle(fontSize: 25, color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: _buildBody(),
      bottomNavigationBar: _bottomnavbar(),
    );
  }

  Widget _buildBody() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool isLoading = context.watch<AuthController>().isLoading;
    return Column(
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
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15)),
          ),
        ),
        SizedBox(
          height: height * 0.05,
        ),
        Padding(
          padding: EdgeInsets.only(right: width * 0.61),
          child: Text(
            "Your Password",
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: TextField(
            obscureText: _passwordObscure,
            obscuringCharacter: '*',
            controller: _passCtrl,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordObscure = !_passwordObscure;
                      });
                    },
                    icon: Icon(
                      _passwordObscure
                          ? Icons.face
                          : Icons.face_unlock_outlined,
                      color: _passwordObscure
                          ? const Color(0XFFCACACA)
                          : const Color(0XFF343434),
                    )),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15)),
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return const ForgotPasswordView();
            }));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            alignment: Alignment.centerRight,
            child: const Text("Forgot Password?"),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        GestureDetector(
          onTap: () {
            if (_emailCtrl.text.isEmpty) {
              snackBar(context, 'Please input email');
            } else if (_passCtrl.text.isEmpty) {
              snackBar(context, 'Please input password');
            } else {
              context.read<AuthController>().setLoading(true);
              Future.delayed(const Duration(milliseconds: 600), () {});
              context
                  .read<AuthController>()
                  .loginCtrl(_emailCtrl.text, _passCtrl.text, context)
                  .then((value) {
                if (value == true) {
                  context
                      .read<AuthFirebaseController>()
                      .handleLogin(_emailCtrl.text, _passCtrl.text)
                      .then((value) {
                    if (value == true) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return const IndexView();
                      }), (route) => false);
                    }else{
                      snackBar(context, "Login fails");
                    }
                  });
                } else {
                  context.read<AuthController>().setLoading(false);
                }
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
                      "Login",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomnavbar() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't an have account? ",
          ),
          SizedBox(
            width: width * 0.03,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const RegisterView();
              }));
            },
            child: Text(
              "Sing Up",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.yellow[700],
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
