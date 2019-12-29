class VideoEntity {
  final String videoUrl;
  final String thumbnail;
  VideoEntity(this.videoUrl, this.thumbnail);

  ///重写运算符==，需要重写get hashCode
  @override
  bool operator ==(other) {
    if(other is! VideoEntity) return false;
    final VideoEntity entity = other;
    return entity.videoUrl == videoUrl && entity.thumbnail == thumbnail;
  }

  @override
  int get hashCode => videoUrl.hashCode ^ thumbnail.hashCode;
}