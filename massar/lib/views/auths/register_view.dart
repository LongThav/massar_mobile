import 'package:flutter/material.dart';
import 'package:project/controllers/auth_ctrls/auth_ctrl.dart';
import 'package:project/controllers/auth_ctrls/auth_firebase_ctrl.dart';
import 'package:project/views/auths/login_view.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/snack_bar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  bool _passwordObscure = true;
  bool _retryPassword = true;

  bool isLoading = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Register",
          style: TextStyle(fontSize: 25, color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool isLoading = context.watch<AuthController>().isLoadingRegister;
    return ListView(
      children: [
        SizedBox(
          height: height * 0.05,
        ),
        _buildForm('Full Name', 'your name', _nameCtrl, TextInputType.name),
        SizedBox(
          height: height * 0.05,
        ),
        _buildForm('Email Address', 'your email', _emailCtrl,
            TextInputType.emailAddress),
        SizedBox(
          height: height * 0.05,
        ),
        _buildForm('Phone Number', 'your phone number', _phoneCtrl,
            TextInputType.number),
        SizedBox(
          height: height * 0.05,
        ),
        _buildFormPassword(
          'Password',
          'your phone Password',
          _passCtrl,
          TextInputType.visiblePassword,
          icon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordObscure = !_passwordObscure;
                });
              },
              icon: Icon(
                _passwordObscure ? Icons.face : Icons.face_unlock_outlined,
                color: _passwordObscure
                    ? const Color(0XFFCACACA)
                    : const Color(0XFF343434),
              )),
        ),
        SizedBox(
          height: height * 0.05,
        ),
        _buildFormRetryPassword(
          'Confirm Password',
          'retype your password',
          _confirmPassCtrl,
          TextInputType.visiblePassword,
          icon: IconButton(
              onPressed: () {
                setState(() {
                  _retryPassword = !_retryPassword;
                });
              },
              icon: Icon(
                _retryPassword ? Icons.face : Icons.face_unlock_outlined,
                color: _retryPassword
                    ? const Color(0XFFCACACA)
                    : const Color(0XFF343434),
              )),
        ),
        SizedBox(
          height: height * 0.05,
        ),
        GestureDetector(
          onTap: () {
            if (_nameCtrl.text.isEmpty) {
              snackBar(context, 'Please input fullname');
            } else if (_emailCtrl.text.isEmpty) {
              snackBar(context, 'Please input email address');
            } else if (_phoneCtrl.text.isEmpty) {
              snackBar(context, 'Please input phone number');
            } else if (_passCtrl.text.isEmpty) {
              snackBar(context, 'Please input password');
            } else if (_passCtrl.text.length < 6) {
              snackBar(context, "Please input password again");
            } else if (_confirmPassCtrl.text.isEmpty) {
              snackBar(context, "Please input confirm password");
            }
            if (_confirmPassCtrl.text != _passCtrl.text) {
              snackBar(context, 'Please retype your password');
            } else {
              debugPrint("Create account...");
              context.read<AuthController>().setRegisterLoading(true);
              Future.delayed(const Duration(milliseconds: 600), () {});
              context
                  .read<AuthController>()
                  .registerCtrl(_nameCtrl.text, _phoneCtrl.text, _passCtrl.text,
                      _emailCtrl.text, context)
                  .then((value) {
                if (value) {
                  context.read<AuthFirebaseController>().signUpController(
                      _emailCtrl.text, _passCtrl.text, _nameCtrl.text, context);
                  Future.delayed(const Duration(milliseconds: 600), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginView();
                    }));
                  });
                } else {
                  _nameCtrl.text = " ";
                  _emailCtrl.text = " ";
                  _phoneCtrl.text = " ";
                  _passCtrl.text = " ";
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
                      "Register",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
            ),
          ),
        ),
        _bottomnavbar()
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
                return const LoginView();
              }));
            },
            child: Text(
              "Login",
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

  Widget _buildForm(
    String title,
    String hint,
    TextEditingController controller,
    TextInputType type, {
    IconButton? icon,
  }) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * 0.04),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: TextField(
            keyboardType: type,
            controller: controller,
            decoration: InputDecoration(
                suffixIcon: icon,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _buildFormRetryPassword(String title, String hint,
      TextEditingController controller, TextInputType type,
      {IconButton? icon}) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * 0.04),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: TextField(
            obscureText: _retryPassword,
            obscuringCharacter: '*',
            keyboardType: type,
            controller: controller,
            decoration: InputDecoration(
                suffixIcon: icon,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _buildFormPassword(String title, String hint,
      TextEditingController controller, TextInputType type,
      {IconButton? icon}) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * 0.04),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: TextField(
            obscureText: _passwordObscure,
            obscuringCharacter: '*',
            keyboardType: type,
            controller: controller,
            decoration: InputDecoration(
                suffixIcon: icon,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15)),
          ),
        ),
      ],
    );
  }
}
