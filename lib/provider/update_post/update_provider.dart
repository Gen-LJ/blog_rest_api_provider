import 'package:blog_rest_api_provider/data/model/update_response.dart';
import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/update_post/update_state.dart';
import 'package:flutter/widgets.dart';

class UpdateNotifier extends ChangeNotifier {
  UpdateState updateState = UpdateFormState();
  final BlogApiService _apiService = BlogApiService();

  void update(
      {required int id, required String title, required String body}) async {
    try {
      updateState = UpdateLoadingState();
      notifyListeners();
      UpdateResponse updateResponse =
          await _apiService.updatePost(id: id, title: title, body: body);
      updateState = UpdateSuccess(updateResponse);
      notifyListeners();
    } catch (e) {
      updateState = UpdateFailed('Somethings wrong,Update failed');
      notifyListeners();
    }
  }
  void tryAgain(){
    updateState = UpdateFormState();
    notifyListeners();
  }
}
