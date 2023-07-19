import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:project/utils/constants/loading_status.dart';
import 'package:project/utils/constants/logger.dart';
import 'package:project/utils/constants/url_base.dart';
import 'package:project/models/feed_model/comment_model.dart';
import 'package:project/models/feed_model/post_model.dart';

import '../../db_helper_local/auth_db_helper/auth_db_local.dart';

class FeedController extends ChangeNotifier {
  PostModel _postModel = PostModel();
  PostModel get postModel => _postModel;

  CommentModel _commentModel = CommentModel(user: UserComment());
  CommentModel get commentModel => _commentModel;

  LoadingStatus _loadingStatus = LoadingStatus.none;
  LoadingStatus get loadingStatus => _loadingStatus;

  void setLoading() {
    _loadingStatus = LoadingStatus.loading;
    notifyListeners();
  }

  final AuthHelper _authHelper = AuthHelper();
  Future<bool> postCtrl(String image, String description) async {
    try {
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      final Map<String, dynamic> map = {
        'image': image,
        'description': description,
      };
      var body = jsonEncode(map);
      String url = mainUrl + addPost;
      http.Response response =
          await http.post(Uri.parse(url), headers: header, body: body);
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

  String _fileName = '';
  String get fileName => _fileName;

  List<int> _fileBytes = [];
  List<int> get fileBytes => _fileBytes;

  String _fileBase64 = '';
  String get fileBase64 => _fileBase64;

  File? _localFile;
  File? get localFile => _localFile;

  final _serviceName = 'Location Service';

  void readFilebase64(String value) {
    _fileBase64 = value;
    notifyListeners();
  }

  Future<void> getFileBase64String(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'png', 'jpg', 'pdf'],
      );
      if (result == null) return;

      _fileName = result.files.first.name;

      final filePath = result.files.first.path.toString();
      final int fileSize = result.files.first.size;
      final String fileName = result.files.first.name;
      final String fileExtension =
          fileName.substring(fileName.lastIndexOf('.') + 1);
      'fileExtension: $fileExtension'.log();

      var typeFile = File(filePath);
      _localFile = typeFile;

      //handle the image file upload
      if (fileExtension != 'pdf') {
        final double totalSize = fileSize / 1000;
        if (totalSize / 1000 > 1) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('The file is large, please choose other image...'),
              ),
            );
          }
          return;
        } else {
          final List<int> imageBytes = typeFile.readAsBytesSync();
          _fileBytes = imageBytes;
          _fileBase64 =
              "data:image/$fileExtension;base64,${base64Encode(imageBytes)}";
          // "Base 64: $_fileBase64".log();
          debugPrint("Base 64: $_fileBase64");
          Future.delayed(const Duration(milliseconds: 600), () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File has been added...'),
              ),
            );
          });
        }
      } else {
        var totalSize = fileSize / 1000;
        if (totalSize / 1000 > 1) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('The file is large, please choose other image...'),
              ),
            );
          }
          return;
        }
        final List<int> pdfBytes = typeFile.readAsBytesSync();
        _fileBytes = pdfBytes;
        _fileBase64 = "data:@file/pdf;base64,${base64Encode(pdfBytes)}";
      }
    } catch (err) {
      '$_serviceName getPatenBase64String exception: $err'.log();
    } finally {
      '$_serviceName getPatenBase64String finally'.log();
      notifyListeners();
    }
  }

  String _imgPath = '';
  String get imgPath => _imgPath;

  String _imgBase64 = '';
  String get imgbase64 => _imgBase64;

  File? _localImg;
  File? get localImg => _localImg;

  final ImagePicker imagePicker = ImagePicker();

  Future<void> openImage() async {
    try {
      var pickFiles = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickFiles != null) {
        _imgPath = pickFiles.path;
        debugPrint("img path: $_imgPath");
        var imgFile = File(pickFiles.path);
        _localImg = imgFile;
        final String fileName = pickFiles.name;

        final String fileExtension =
            fileName.substring(fileName.lastIndexOf('.') + 1);
        debugPrint("File extension: $fileExtension");

        final List<int> imgBytes = imgFile.readAsBytesSync();
        _imgBase64 =
            "data:image/$fileExtension;base64,${base64Encode(imgBytes)}";
        debugPrint("ImgBase64: $_imgBase64");
      } else {
        debugPrint("No image is selected");
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> readPost() async {
    try {
      String url = "$mainUrl/get-post";
      debugPrint("Url: $url");
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        _postModel = await compute(_parJsonPostModel, response.body);
        _loadingStatus = LoadingStatus.done;
      }
    } catch (e) {
      _loadingStatus = LoadingStatus.error;
      throw Exception("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> readComment(int id) async {
    try {
      String url = '$mainUrl$getComment/$id';
      debugPrint("Url: $url");
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      http.Response response = await http.get(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        _commentModel = await compute(_parJsonComment, response.body);
        _loadingStatus = LoadingStatus.done;
      }
    } catch (e) {
      _loadingStatus = LoadingStatus.error;
      throw Exception("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<bool> commentCtrl(int postId, String body) async {
    try {
      final Map<String, dynamic> map = {
        'post_id': postId,
        'body': body,
      };
      debugPrint("Map: $map");
      final data = jsonEncode(map);
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      String url = mainUrl + addComment;
      http.Response response =
          await http.post(Uri.parse(url), headers: header, body: data);
      debugPrint("Response body: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      debugPrint("Error $err");
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> likeCtrl(int postId) async {
    try {
      final Map<String, dynamic> map = {
        'post_id': postId,
      };
      debugPrint("Map: $map");
      final data = jsonEncode(map);
      var token = await _authHelper.readToken();
      final header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      String url = mainUrl + addLike;
      http.Response response =
          await http.post(Uri.parse(url), headers: header, body: data);
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      debugPrint("Error: $err");
      return false;
    } finally {
      notifyListeners();
    }
  }
}

PostModel _parJsonPostModel(String str) => PostModel.fromJson(json.decode(str));
CommentModel _parJsonComment(String str) =>
    CommentModel.fromJson(json.decode(str));
