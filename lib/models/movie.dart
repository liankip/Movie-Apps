class Movie {
  int id;
  String name;
  String description;
  String image;
  int like;
  bool isAdded = false;
  int itemCount = 0;

  Movie({this.id, this.name, this.description, this.image, this.like});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return new Movie(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      like: json['like'] as int,
    );
  }
}
