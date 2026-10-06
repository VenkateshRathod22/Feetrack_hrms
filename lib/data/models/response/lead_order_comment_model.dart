class LeadOrderCommentModel {
  String? id;
  String? leadOrderId;
  String? pipelineStageId;
  String? userId;
  String? comment;
  String? createdAt;
  String? updatedAt;
  CommentUser? user;
  CommentStage? stage;

  LeadOrderCommentModel({
    this.id,
    this.leadOrderId,
    this.pipelineStageId,
    this.userId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.stage,
  });

  factory LeadOrderCommentModel.fromJson(Map<String, dynamic> json) {
    return LeadOrderCommentModel(
      id: json['id']?.toString(),
      leadOrderId: json['lead_order_id']?.toString(),
      pipelineStageId: json['pipeline_stage_id']?.toString(),
      userId: json['user_id']?.toString(),
      comment: json['comment']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      user: json['user'] != null ? CommentUser.fromJson(json['user']) : null,
      stage: json['stage'] != null ? CommentStage.fromJson(json['stage']) : null,
    );
  }
}

class CommentUser {
  String? id;
  String? name;
  String? profileImageUrl;

  CommentUser({this.id, this.name, this.profileImageUrl});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
    );
  }
}

class CommentStage {
  String? id;
  String? name;

  CommentStage({this.id, this.name});

  factory CommentStage.fromJson(Map<String, dynamic> json) {
    return CommentStage(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
    );
  }
}
