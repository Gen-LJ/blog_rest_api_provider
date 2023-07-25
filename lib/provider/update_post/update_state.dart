import 'package:blog_rest_api_provider/data/model/update_response.dart';

abstract class UpdateState{}

class UpdateFormState extends UpdateState{}

class UpdateLoadingState extends UpdateState{}

class UpdateSuccess extends UpdateState{
final UpdateResponse updateResponse;
  UpdateSuccess(this.updateResponse);
}

class UpdateFailed extends UpdateState{
final String errorMessage;
  UpdateFailed(this.errorMessage);
}