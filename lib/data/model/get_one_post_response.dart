class GetOnePostResponse {
  GetOnePostResponse({
      this.id, 
      this.title, 
      this.body, 
      this.photo,});

  GetOnePostResponse.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    photo = json['photo'];
  }
  num? id;

  @override
  String toString() {
    return 'GetOnePostResponse{id: $id, title: $title, body: $body, photo: $photo}';
  }

  String? title;
  String? body;
  String? photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['photo'] = photo;
    return map;
  }

}