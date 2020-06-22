class User {
  int id;
  String name;
  String lastname;
  String firstname;
  int status;
  String birthday;
  String inscriptionDate;
  String gender;
  String link;
  String picture;
  String pictureSmall;
  String pictureMedium;
  String pictureBig;
  String pictureXl;
  String country;
  String lang;
  bool isKid;

  User(
      {this.id,
        this.name,
        this.lastname,
        this.firstname,
        this.status,
        this.birthday,
        this.inscriptionDate,
        this.gender,
        this.link,
        this.picture,
        this.pictureSmall,
        this.pictureMedium,
        this.pictureBig,
        this.pictureXl,
        this.country,
        this.lang,
        this.isKid});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String ? int.parse(json['id']) : json['id'];
    name = json['name'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    status = json['status'];
    birthday = json['birthday'];
    inscriptionDate = json['inscription_date'];
    gender = json['gender'];
    link = json['link'];
    picture = json['picture'];
    pictureSmall = json['picture_small'];
    pictureMedium = json['picture_medium'];
    pictureBig = json['picture_big'];
    pictureXl = json['picture_xl'];
    country = json['country'];
    lang = json['lang'];
    isKid = json['is_kid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['status'] = this.status;
    data['birthday'] = this.birthday;
    data['inscription_date'] = this.inscriptionDate;
    data['gender'] = this.gender;
    data['link'] = this.link;
    data['picture'] = this.picture;
    data['picture_small'] = this.pictureSmall;
    data['picture_medium'] = this.pictureMedium;
    data['picture_big'] = this.pictureBig;
    data['picture_xl'] = this.pictureXl;
    data['country'] = this.country;
    data['lang'] = this.lang;
    data['is_kid'] = this.isKid;
    return data;
  }
}
