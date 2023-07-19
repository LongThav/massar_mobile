import 'package:flutter/material.dart';
import 'package:project/utils/constants/logger.dart';
import 'package:project/utils/constants/snack_bar.dart';
import 'package:project/controllers/profile_ctrl/profile_ctrl.dart';
import 'package:project/views/dashboards/profile_views/profile_veiw.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/url_base.dart';
import '/models/auth_model/login_model.dart';
import '../../../utils/constants/color.dart';

class UpdateProfileView extends StatefulWidget {
  final LoginModel loginModel;
  const UpdateProfileView({super.key, required this.loginModel});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _addressCtrl = TextEditingController();

  var img = '';

  @override
  void initState() {
    _nameCtrl =
        TextEditingController(text: widget.loginModel.data.user.fullname);
    _phoneCtrl = TextEditingController(text: widget.loginModel.data.user.phone);
    _emailCtrl = TextEditingController(text: widget.loginModel.data.user.email);
    _addressCtrl = TextEditingController(
        text: widget.loginModel.data.user.address ?? "");
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileController>().setUpdateLoading(false);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30,
            )),
        backgroundColor: mainColor,
        elevation: 0.0,
        titleSpacing: -13,
        title: const Text("Update profile"),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBody() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        SizedBox(
          height: height * 0.05,
        ),
        GestureDetector(
          onTap: () {
            context.read<ProfileController>().getFileBase64String(context);
            if(widget.loginModel.data.user.click == true){
              context.read<ProfileController>().fileBase64;
            }else{

            }
          },
          child: Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            width: width * 0.2,
            height: height * 0.2,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(
                        widget.loginModel.data.user.image == null
                            ? staticImg
                            : hostImg +
                                widget.loginModel.data.user.image.toString()))),
          ),
        ),
        _buildForm('FullName', _nameCtrl, TextInputType.name),
        SizedBox(
          height: height * 0.02,
        ),
        _buildForm('Email', _emailCtrl, TextInputType.emailAddress),
        SizedBox(
          height: height * 0.02,
        ),
        _buildForm('Phone', _phoneCtrl, TextInputType.phone),
        SizedBox(
          height: height * 0.02,
        ),
        _buildForm('Address', _addressCtrl, TextInputType.name, hind: "No Address"),
      ],
    );
  }

  Widget _buildForm(
    String title,
    TextEditingController controller,
    TextInputType type, {
    IconButton? icon,
    String? hind
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
              hintText: hind,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15)
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottom() {
    bool isLoading = context.watch<ProfileController>().isLoading;
    var imgBase64 = context.read<ProfileController>().fileBase64;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        'start update'.log();
         debugPrint( 'Image Base64: $imgBase64');
        'Id: ${widget.loginModel.data.user.id}'.log();
        if (_nameCtrl.text.isEmpty) {
          snackBar(context, "Please input full name");
        } else if (_emailCtrl.text.isEmpty) {
          snackBar(context, "Please input email address");
        } else if (_phoneCtrl.text.isEmpty) {
          snackBar(context, "Please input phone number");
        } else {
          context.read<ProfileController>().setUpdateLoading(true);
          Future.delayed(const Duration(milliseconds: 300), () {});
          if(widget.loginModel.data.user.image!.isNotEmpty){
            widget.loginModel.data.user.image;
          }
          context
              .read<ProfileController>()
              .updateProfileCtrl(widget.loginModel.data.user.id,
              imgBase64
              // if(widget.loginModel.data.user.image == true)
              , _nameCtrl.text, _emailCtrl.text,
                  _phoneCtrl.text, _addressCtrl.text)
              .then((value) {
            if (value) {
              Navigator.pop(context);
              context.read<ProfileController>().setLoading(context);
              context.read<ProfileController>().readLocalProfile();
            } 
          });
        }
      },
      child: Container(
        width: width,
        height: height * 0.08,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        margin: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 15),
        decoration: const BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
        ),
        child: Center(
          child: isLoading == true
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text(
                  "Update info",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}
