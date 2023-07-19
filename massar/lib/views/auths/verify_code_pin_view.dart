import 'package:flutter/material.dart';
import 'package:project/utils/constants/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_ctrls/auth_ctrl.dart';
import 'reset_password_view.dart';

class CodePinView extends StatefulWidget {
  final String email;
  const CodePinView({super.key, required this.email});

  @override
  State<CodePinView> createState() => _CodePinViewState();
}

class _CodePinViewState extends State<CodePinView> {
  final TextEditingController _pinCtrl = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      context.read<AuthController>().setLoading(false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
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
          "Verify Code Pin",
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
                  "Input code request",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: TextField(
                  controller: _pinCtrl,
                  decoration: InputDecoration(
                      hintText: 'Code Pin',
                      hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              InkWell(
                onTap: (){
                  if(widget.email.isEmpty){
                    snackBar(context, "Can't sent pin code");
                  }else{
                    context.read<AuthController>().resentVerifyPinController(widget.email).then((value){
                      if(value){
                        snackBar(context, "Code Pin has been sent");
                      }else{
                        snackBar(context, "fails sent pin Code");
                      }
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 15, right: 15),
                  alignment: Alignment.centerRight,
                  child: const Text("Resent Pin code"),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              GestureDetector(
                onTap: () {
                  if(_pinCtrl.text.isEmpty){
                    snackBar(context, "Please input pin code");
                  }else{
                    context.read<AuthController>().setLoading(true);
                    context.read<AuthController>().verifyPinController(widget.email, _pinCtrl.text).then((value){
                      if(value){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return  ResetPasswordView(email: widget.email,);
                        }));
                      }else{
                        snackBar(context, "Verify again");
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
                            "Verify Email",
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
