import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/views/dashboards/home_views/chats/chat_view.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants/logger.dart';
import '/controllers/auth_ctrls/auth_firebase_ctrl.dart';
import '../../../../controllers/chat_ctrl/home_chat_ctrl.dart';
import '/models/chat_model/chat_user_model.dart';
import '/views/auths/login_view.dart';

import '../../../../utils/constants/firstore_constan.dart';

class ListChatingView extends StatefulWidget {
  const ListChatingView({super.key});

  @override
  State<ListChatingView> createState() => _ListChatingViewState();
}

class _ListChatingViewState extends State<ListChatingView> {
  final TextEditingController _searchCtrl = TextEditingController();
  StreamController<bool> buttonClearController = StreamController<bool>();
  late HomeChatController homeChatController;
  late AuthFirebaseController authFirebaseController;
  late String currentUserId;

  final int _limit = 20;
  String _textSearch = '';
  @override
  void initState() {
    homeChatController = context.read<HomeChatController>();
    authFirebaseController = context.read<AuthFirebaseController>();

    if (authFirebaseController.getFirebaseUserId().isNotEmpty == true) {
      currentUserId = authFirebaseController.getFirebaseUserId();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (Route<dynamic> route) => false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: const Color(0XFF06AB8D),
        title: const Text("Chatting...Zzz"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            padding: const EdgeInsets.only(left: 15, top: 5),
            width: width,
            height: height * 0.07,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (value){
                if(value.isNotEmpty){
                  buttonClearController.add(true);
                  setState(() {
                    _textSearch = value;
                  });
                }else{
                  buttonClearController.add(false);
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search User',
                suffixIcon: IconButton(
                    onPressed: () {
                      debugPrint("Search started...");
                    },
                    icon: const Icon(
                      Icons.search_outlined,
                      color: Colors.grey,
                    )),
              ),
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: StreamBuilder<QuerySnapshot>(
        stream: homeChatController.getFirestoreData(
            FirestoreConstants.pathUserCollection, _limit, _textSearch),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data?.docs.length ?? 0) > 0) {
              return Column(
                children: List.generate(snapshot.data!.docs.length, (index) {
                  return _buildItem(context, snapshot.data?.docs[index]);
                }),
              );
            } else {
              return const Center(
                child: Text("NO user found..."),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
     final firebaseAuth = FirebaseAuth.instance;
    if (documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
      if (userChat.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        debugPrint("User: ${userChat.displayName}");
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatView(
                          peerId: userChat.id,
                          peerAvatar: userChat.photoUrl ?? "",
                          peerNickname: userChat.displayName,
                          userAvatar: firebaseAuth.currentUser?.photoURL ?? "",
                        )));
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: userChat.photoUrl == null? Image.asset("assets/imgs/user.png") : Image.network(userChat.photoUrl ?? ""),
            ),
            title: Text(userChat.displayName),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

