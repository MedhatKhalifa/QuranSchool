class ShowTutorial {
  ShowTutorial({
    this.search = true,
    this.quran = true,
    this.searchteacher = true,
    this.teacherTimeAdd = true,
  });

  bool search;

  bool quran;

  bool searchteacher;
  bool teacherTimeAdd;

  factory ShowTutorial.fromJson(Map<String, dynamic> json) => ShowTutorial(
        search: json["search"] ?? true,
        quran: json["quran"] ?? true,
        searchteacher: json["searchteacher"] ?? true,
        teacherTimeAdd: json['teacherTimeAdd'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "search": search,
        "quran": quran,
        "searchteacher": searchteacher,
        "teacherTimeAdd": teacherTimeAdd,
      };
}
