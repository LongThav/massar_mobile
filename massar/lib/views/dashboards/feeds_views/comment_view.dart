import 'package:flutter/material.dart';
import 'package:project/constants/loading_status.dart';
import 'package:project/constants/snack_bar.dart';
import 'package:project/controllers/feeds/feeds_ctrl.dart';
import 'package:project/models/feed_model/comment_model.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';

class CommentView extends StatefulWidget {
  final int id;
  const CommentView({super.key, required this.id});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final TextEditingController _commentCtrl = TextEditingController();
  late FeedController _feedController;
  @override
  void initState() {
    _feedController = context.read<FeedController>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _feedController.setLoading();
      _feedController.readComment(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Comments"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
                  _feedController.setLoading();
      _feedController.readPost();
          },
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Widget _buildBody() {
    LoadingStatus loadingStatus = context.watch<FeedController>().loadingStatus;
    switch (loadingStatus) {
      case LoadingStatus.none:
      case LoadingStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.error:
        return const Center(
          child: Text("Error"),
        );
      case LoadingStatus.done:
        return _buildView();
    }
  }

  Widget _buildView() {
    CommentModel commentModel = context.watch<FeedController>().commentModel;
    var totalComment = commentModel.user.getAllComments;
    if(totalComment.isEmpty){
      print("NO comment");
      return const Center(child: Text("No Comments"),);
    }else{
      print("comment");
      totalComment;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            List.generate(totalComment.length, (index) {
          var data = commentModel.user.getAllComments[index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "${index + 1}. ${data.body}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottom() {
    // final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: height * 0.1,
      color: Colors.white,
      child: Center(
        child: TextField(
          controller: _commentCtrl,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Typing something...',
            suffixIcon: IconButton(
                onPressed: () {
                  if (_commentCtrl.text.isEmpty) {
                    snackBar(context, "please typing something...");
                  } else {
                    var comment = _commentCtrl.text;
                    context
                        .read<FeedController>()
                        .commentCtrl(widget.id, comment)
                        .then((value) {
                      if (value == true) {
                        _feedController.setLoading();
                        _feedController.readComment(widget.id);
                      } else {
                        _commentCtrl.text = " ";
                        snackBar(context, "fails comment");
                      }
                    });
                    _commentCtrl.text = " ";
                  }
                },
                icon: const Icon(Icons.comment_outlined)),
          ),
        ),
      ),
    );
  }
}
