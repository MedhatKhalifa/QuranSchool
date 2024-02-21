class HomePageModel {
  int? id;
  String titleEn;
  String image;
  String contentEn;
  String contentAr;
  String pagename;
  String titleAr;

  HomePageModel({
    this.id,
    this.titleEn = "Madraset Al Quran",
    this.titleAr = "مدرسة القرآن",
    this.image = "",
    this.contentEn =
        "Discover Quran School, the premier mobile app for learning Quran and Islamic studies from top-tier teachers. Benefit from personalized learning plans tailored to your needs and schedule, with flexible timing options available. Engage in interactive lessons and comprehensive curriculum covering Tajweed, Tafsir, Hadith, and more. Track your progress effortlessly and enjoy a safe, supportive learning environment. Join Quran School today to embark on a transformative journey of Quranic knowledge and spiritual growth",
    this.contentAr =
        "اكتشف مدرسة القرآن، التطبيق المتميز لتعلم القرآن والدراسات الإسلامية من خلال معلمين متميزين. استفد من خطط تعليمية مُخصصة تتناسب مع احتياجاتك وجدولك الزمني، مع خيارات توقيت مرنة متاحة. شارك في دروس تفاعلية ومناهج شاملة تشمل التجويد والتفسير وعلوم الحديث والمزيد. تتبع تقدمك بسهولة واستمتع ببيئة تعليمية آمنة وداعمة. انضم إلى مدرسة القرآن اليوم للانطلاق في رحلة تحويلية نحو المعرفة القرآنية والنمو الروحي.",
    this.pagename = "",
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
        id: json["id"] ?? -1,
        titleEn: json["titleEn"] ?? "",
        titleAr: json['titleAr'] ?? "titleAr",
        image: json["image"] ?? "",
        contentEn: json["ContentEn"] ?? "",
        contentAr: json["ContentAr"] ?? "",
        pagename: json["pagename"] ?? "",
      );
}
