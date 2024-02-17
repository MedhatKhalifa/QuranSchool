class ShowTutorial {
  ShowTutorial({
    this.search = true,
    this.quran = true,
    this.searchteacher = true,
  });

  bool search;

  bool quran;

  bool searchteacher;

  factory ShowTutorial.fromJson(Map<String, dynamic> json) => ShowTutorial(
        search: json["search"] ?? true,
        quran: json["quran"] ?? true,
        searchteacher: json["searchteacher"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "search": search,
        "quran": quran,
        "searchteacher": searchteacher,
      };
}
