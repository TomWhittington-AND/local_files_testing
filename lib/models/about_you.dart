class AboutYou {
  String profilePictureUrl;
  String name;
  String roleTitle;
  DateTime currentRoleStartDate;
  AboutYou(this.profilePictureUrl, this.name, this.roleTitle,
      this.currentRoleStartDate);

  AboutYou.fromJson(Map<String, dynamic> json)
      : profilePictureUrl = json['profilePictureUrl'],
        name = json['name'],
        roleTitle = json['roleTitle'],
        currentRoleStartDate = DateTime.parse(json['currentRoleStartDate']);

  Map toJson() => {
        'profilePictureUrl': profilePictureUrl,
        'name': name,
        'roleTitle': roleTitle,
        'currentRoleStartDate': currentRoleStartDate.toString(),
      };

  @override
  String toString() {
    return '''
      AboutYou:
        \t- profilePictureUrl : "$profilePictureUrl"
        \t- name : "$name"
        \t- roleTitle : "$roleTitle"
        \t- currentRoleStartDate : "$currentRoleStartDate"
    ''';
  }
}
