import 'package:blog_rest_api_provider/data/model/get_all_post_response.dart';
import 'package:blog_rest_api_provider/data/model/get_one_post_response.dart';
import 'package:dio/dio.dart';
import '../model/blog_upload_response.dart';

class BlogApiService {
  static const String baseUrl = 'http://rubylearner.com:5000/';
  late Dio dio;

  BlogApiService() {
    dio = Dio();
  }

  Future<List<GetAllPostResponse>> getAllPosts() async {
    final postResponse = await dio.get('${baseUrl}posts');
    final postList = (postResponse.data as List).map((e) {
      return GetAllPostResponse.fromJson(e);
    }).toList();
    return postList;
  }

  Future<GetOnePostResponse> getOnePost(int id) async {
    final postResponse = await dio.get('${baseUrl}post?id=$id');
    final postList = (postResponse.data as List);
    final post = GetOnePostResponse.fromJson(postList[0]);
    return post;
  }

  Future<BlogUploadResponse> uploadPost(
      {required String title,
      required String body,
      required FormData data}) async {
    final uploadResponse =
        await dio.post('${baseUrl}post?title=$title&body=$body', data: data);
    return BlogUploadResponse.fromJson(uploadResponse.data);
  }
}
