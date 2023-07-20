import 'package:flutter/material.dart';
import 'package:project/utils/constants/color.dart';
import 'package:project/utils/constants/loading_status.dart';
import 'package:project/utils/constants/url_base.dart';
import 'package:project/controllers/feeds/feeds_ctrl.dart';
import 'package:project/models/feed_model/post_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'comment_view.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late FeedController _feedController;
  bool _isSelect = false;
  @override
  void initState() {
    _feedController = context.read<FeedController>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _feedController.setLoading();
      _feedController.readPost();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: _buildBody(),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    PostModel post = _feedController.postModel;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: RefreshIndicator(
        onRefresh: () async {
          _feedController.setLoading();
          _feedController.readPost();
        },
        child: SizedBox(
          height: height * 0.74,
          child: ListView.builder(
              itemCount: post.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(children: [
                    Container(
                        width: width,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: mainColor,
                                  child: Image.network(
                                      hostImg + post.data[index].image),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.data[index].user.fullname,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(post.data[index].user.createdAt
                                          .toString())
                                    ],
                                  ),
                                ),
                                Text(
                                  "...",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]),
                                )
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              width: width,
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          hostImg + post.data[index].image))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "12mns",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500],
                                      fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          debugPrint("Start comment");
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return CommentView(
                                              id: post.data[index].id,
                                            );
                                          }));
                                        },
                                        icon: Icon(
                                          Icons.comment_outlined,
                                          color: Colors.grey[400],
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          // bool selected =
                                          //     _isSelect = !_isSelect;
                                          bool selected = post.data[index].selectlike =! post.data[index].selectlike;
                                          debugPrint("Select: $selected");
                                          if (selected == true) {
                                            context
                                                .read<FeedController>()
                                                .likeCtrl(post.data[index].id);
                                          }else{
                                            context
                                                .read<FeedController>()
                                                .likeCtrl(post.data[index].id);
                                          }
                                        });
                                      },
                                      icon: post.data[index].selectlike
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red[700],
                                            )
                                          : Icon(
                                              Icons.favorite_outline,
                                              color: Colors.grey[500],
                                            ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.share_outlined,
                                          color: Colors.grey[400],
                                        ))
                                  ],
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 15),
                              alignment: Alignment.centerLeft,
                              child: Text(post.data[index].description),
                            ),
                          ],
                        ))
                  ]),
                );
              }),
        ),
      ),
    );
  }
}
