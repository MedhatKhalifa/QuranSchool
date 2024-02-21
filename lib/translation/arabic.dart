String getKeyFromValue(String value) {
  for (var entry in ar.entries) {
    if (entry.value == value) {
      return entry.key;
    }
  }

  return ""; // Return null if the value is not found in the map
}

const Map<String, String> ar = {
  'Afghanistan': 'أفغانستان',

  'Albania': 'ألبانيا',

  'Algeria': 'الجزائر',

  'Andorra': 'أندورا',

  'Angola': 'أنغولا',

  'Antigua and Barbuda': 'أنتيغوا وبربودا',

  'Argentina': 'الأرجنتين',

  'Armenia': 'أرمينيا',

  'Aruba': 'أروبا',

  'Australia': 'أستراليا',

  'Austria': 'النمسا',

  'Azerbaijan': 'أذربيجان',

  'Bahamas': 'جزر البهاما',

  'Bahrain': 'البحرين',

  'Bangladesh': 'بنغلاديش',

  'Barbados': 'بربادوس',

  'Belarus': 'بيلاروسيا',

  'Belgium': 'بلجيكا',

  'Belize': 'بليز',

  'Bolivia': 'بوليفيا',

  'Bosnia and Herzegovina': 'البوسنة والهرسك',

  'Botswana': 'بوتسوانا',

  'Brazil': 'البرازيل',

  'Brunei': 'بروناي',

  'Bulgaria': 'بلغاريا',

  'Cambodia': 'كمبوديا',

  'Cameroon': 'الكاميرون',

  'Canada': 'كندا',

  'Cayman Islands': 'جزر كايمان',

  'Chile': 'تشيلي',

  'China': 'الصين',

  'Colombia': 'كولومبيا',

  'Congo': 'الكونغو',

  'Costa Rica': 'كوستا ريكا',

  'Croatia': 'كرواتيا',

  'Cuba': 'كوبا',

  'Cyprus': 'قبرص',

  'Czech Republic': 'الجمهورية التشيكية',

  'Denmark': 'الدنمارك',

  'Dominican Republic': 'جمهورية الدومنيكان',

  'Ecuador': 'الاكوادور',

  'Egypt': 'مصر',

  'El Salvador': 'السلفادور',

  'Estonia': 'إستونيا',

  'Faroe Islands': 'جزر فاروس',

  'Finland': 'فنلندا',

  'France': 'فرنسا',

  'French Polynesia': 'بولينيزيا الفرنسية',

  'Gabon': 'الجابون',

  'Georgia': 'جورجيا',

  'Germany': 'ألمانيا',

  'Ghana': 'غانا',

  'Greece': 'اليونان',

  'Greenland': 'الأرض الخضراء',

  'Guadeloupe': 'جوادلوب',

  'Guam': 'غوام',

  'Guatemala': 'غواتيمالا',

  'Guinea': 'غينيا',

  'Haiti': 'هايتي',

  'Hashemite Kingdom of Jordan': 'المملكة الأردنية الهاشمية',

  'Honduras': 'هندوراس',

  'Hong Kong': 'هونج كونج',

  'Hungary': 'هنغاريا',

  'Iceland': 'أيسلندا',

  'India': 'الهند',

  'Indonesia': 'إندونيسيا',

  'Iran': 'إيران',

  'Iraq': 'العراق',

  'Ireland': 'أيرلندا',

  'Isle of Man': 'جزيرة آيل أوف مان',

  'Israel': 'إسرائيل',

  'Italy': 'إيطاليا',

  'Jamaica': 'جامايكا',

  'Japan': 'اليابان',

  'Kazakhstan': 'كازاخستان',

  'Kenya': 'كينيا',

  'Kosovo': 'كوسوفو',

  'Kuwait': 'الكويت',

  'Latvia': 'لاتفيا',

  'Lebanon': 'لبنان',

  'Libya': 'ليبيا',

  'Liechtenstein': 'ليختنشتاين',

  'Luxembourg': 'لوكسمبورغ',

  'Macedonia': 'مقدونيا',

  'Madagascar': 'مدغشقر',

  'Malaysia': 'ماليزيا',

  'Malta': 'مالطا',

  'Martinique': 'مارتينيك',

  'Mauritius': 'موريشيوس',

  'Mayotte': 'مايوت',

  'Mexico': 'المكسيك',

  'Mongolia': 'منغوليا',

  'Montenegro': 'الجبل الأسود',

  'Morocco': 'المغرب',

  'Mozambique': 'موزمبيق',

  'Myanmar [Burma]': 'ميانمار [بورما]',

  'Namibia': 'ناميبيا',

  'Nepal': 'نيبال',

  'Netherlands': 'هولندا',

  'New Caledonia': 'كاليدونيا الجديدة',

  'New Zealand': 'نيوزيلندا',

  'Nicaragua': 'نيكاراغوا',

  'Nigeria': 'نيجيريا',

  'Norway': 'النرويج',

  'Oman': 'سلطنة عمان',

  'Pakistan': 'باكستان',

  'Palestine': 'فلسطين',

  'Panama': 'بنما',

  'Papua New Guinea': 'بابوا غينيا الجديدة',

  'Paraguay': 'باراغواي',

  'Peru': 'بيرو',

  'Philippines': 'فيلبيني',

  'Poland': 'بولندا',

  'Portugal': 'البرتغال',

  'Puerto Rico': 'بورتوريكو',

  'Republic of Korea': 'جمهورية كوريا',

  'Republic of Lithuania': 'جمهورية ليتوانيا',

  'Republic of Moldova': 'جمهورية مولدوفا',

  'Romania': 'رومانيا',

  'Russia': 'روسيا',

  'Saint Lucia': 'القديسة لوسيا',

  'San Marino': 'سان مارينو',

  'Saudi Arabia': 'المملكة العربية السعودية',

  'Senegal': 'السنغال',

  'Serbia': 'صربيا',

  'Singapore': 'سنغافورة',

  'Slovakia': 'سلوفاكيا',

  'Slovenia': 'سلوفينيا',

  'South Africa': 'جنوب أفريقيا',

  'Spain': 'إسبانيا',

  'Sri Lanka': 'سيريلانكا',

  'Sudan': 'السودان',

  'Suriname': 'سورينام',

  'Swaziland': 'سوازيلاند',

  'Sweden': 'السويد',

  'Switzerland': 'سويسرا',

  'Taiwan': 'تايوان',

  'Tanzania': 'تنزانيا',

  'Thailand': 'تايلاند',

  'Trinidad and Tobago': 'ترينداد وتوباغو',

  'Tunisia': 'تونس',

  'Turkey': 'ديك رومى',

  'U.S. Virgin Islands': 'جزر فيرجن الأمريكية',

  'Ukraine': 'أوكرانيا',

  'United Arab Emirates': 'الإمارات العربية المتحدة',

  'United Kingdom': 'المملكة المتحدة',

  'United States': 'الولايات المتحدة الأمريكية',

  'Uruguay': 'أوروغواي',

  'Venezuela': 'فنزويلا',

  'Vietnam': 'فيتنام',

  'Zambia': 'زامبيا',

  'Zimbabwe': 'زيمبابوي',

  'Afghan': 'أفغاني',

  'Albanian': 'ألباني',

  'Algerian': 'جزائري',

  'American': 'أمريكي',

  'Andorran': 'أندوري',

  'Angolan': 'أنغولي',

  'Antiguans': 'انتيغوا',

  'Argentinean': 'أرجنتيني',

  'Armenian': 'أرميني',

  'Australian': 'أسترالي',

  'Austrian': 'نمساوي',

  'Azerbaijani': 'أذربيجاني',

  'Bahamian': 'باهامى',

  'Bahraini': 'بحريني',

  'Bangladeshi': 'بنجلاديشي',

  'Barbadian': 'باربادوسي',

  'Barbudans': 'بربودا',

  'Batswana': 'بوتسواني',

  'Belarusian': 'بيلاروسي',

  'Belgian': 'بلجيكي',

  'Belizean': 'بليزي',

  'Beninese': 'بنيني',

  'Bhutanese': 'بوتاني',

  'Bolivian': 'بوليفي',

  'Bosnian': 'بوسني',

  'Brazilian': 'برازيلي',

  'British': 'بريطاني',

  'Bruneian': 'بروناى',

  'Bulgarian': 'بلغاري',

  'Burkinabe': 'بوركيني',

  'Burmese': 'بورمي',

  'Burundian': 'بوروندي',

  'Cambodian': 'كمبودي',

  'Cameroonian': 'كاميروني',

  'Canadian': 'كندي',

  'Cape Verdean': 'االرأس الأخضر',

  'Central African': 'وسط أفريقيا',

  'Chadian': 'تشادي',

  'Chilean': 'شيلي',

  'Chinese': 'صينى',

  'Colombian': 'كولومبي',

  'Comoran': 'جزر القمر',

  'Congolese': 'كونغولي',

  'Costa Rican': 'كوستاريكي',

  'Croatian': 'كرواتية',

  'Cuban': 'كوبي',

  'Cypriot': 'قبرصي',

  'Czech': 'تشيكي',

  'Danish': 'دانماركي',

  'Djibouti': 'جيبوتي',

  'Dominican': 'دومينيكاني',

  'Dutch': 'هولندي',

  'East Timorese': 'تيموري شرقي',

  'Ecuadorean': 'اكوادوري',

  'Egyptian': 'مصري',

  'Emirian': 'إماراتي',

  'Equatorial Guinean': 'غيني استوائي',

  'Eritrean': 'إريتري',

  'Estonian': 'إستوني',

  'Ethiopian': 'حبشي',

  'Fijian': 'فيجي',

  'Filipino': 'فلبيني',

  'Finnish': 'فنلندي',

  'French': 'فرنسي',

  'Gabonese': 'جابوني',

  'Gambian': 'غامبيي',

  'Georgian': 'جورجي',

  'German': 'ألماني',

  'Ghanaian': 'غاني',

  'Greek': 'إغريقي',

  'Grenadian': 'جرينادي',

  'Guatemalan': 'غواتيمالي',

  'Guinea-Bissauan': 'غيني بيساوي',

  'Guinean': 'غيني',

  'Guyanese': 'جوياني',

  'Haitian': 'هايتي',

  'Herzegovinian': 'هرسكي',

  'Honduran': 'هندوراسي',

  'Hungarian': 'هنغاري',

  'Icelander': 'إيسلندي',

  'Indian': 'هندي',

  'Indonesian': 'إندونيسي',

  'Iranian': 'إيراني',

  'Iraqi': 'عراقي',

  'Irish': 'إيرلندي',

  'Italian': 'إيطالي',

  'Ivorian': 'إفواري',

  'Jamaican': 'جامايكي',

  'Japanese': 'ياباني',

  'Jordanian': 'أردني',

  'Kazakhstani': 'كازاخستاني',

  'Kenyan': 'كيني',

  'Kittian and Nevisian': 'كيتياني ونيفيسياني',

  'Kuwaiti': 'كويتي',

  'Kyrgyz': 'قيرغيزستان',

  'Laotian': 'لاوسي',

  'Latvian': 'لاتفي',

  'Lebanese': 'لبناني',

  'Liberian': 'ليبيري',

  'Libyan': 'ليبي',

  'Liechtensteiner': 'ليختنشتايني',

  'Lithuanian': 'لتواني',

  'Luxembourger': 'لكسمبرغي',

  'Macedonian': 'مقدوني',

  'Malagasy': 'مدغشقري',

  'Malawian': 'مالاوى',

  'Malaysian': 'ماليزي',

  'Maldivan': 'مالديفي',

  'Malian': 'مالي',

  'Maltese': 'مالطي',

  'Marshallese': 'مارشالي',

  'Mauritanian': 'موريتاني',

  'Mauritian': 'موريشيوسي',

  'Mexican': 'مكسيكي',

  'Micronesian': 'ميكرونيزي',

  'Moldovan': 'مولدوفي',

  'Monacan': 'موناكو',

  'Mongolian': 'منغولي',

  'Moroccan': 'مغربي',

  'Mosotho': 'ليسوتو',

  'Motswana': 'لتسواني',

  'Mozambican': 'موزمبيقي',

  'Namibian': 'ناميبي',

  'Nauruan': 'ناورو',

  'Nepalese': 'نيبالي',

  'New Zealander': 'نيوزيلندي',

  'Ni-Vanuatu': 'ني فانواتي',

  'Nicaraguan': 'نيكاراغوا',

  'Nigerien': 'نيجري',

  'North Korean': 'كوري شمالي',

  'Northern Irish': 'إيرلندي شمالي',

  'Norwegian': 'نرويجي',

  'Omani': 'عماني',

  'Pakistani': 'باكستاني',

  'Palauan': 'بالاوي',

  'Palestinian': 'فلسطيني',

  'Panamanian': 'بنمي',

  'Papua New Guinean': 'بابوا غينيا الجديدة',

  'Paraguayan': 'باراغواياني',

  'Peruvian': 'بيروفي',

  'Polish': 'بولندي',

  'Portuguese': 'برتغالي',

  'Qatari': 'قطري',

  'Romanian': 'روماني',

  'Russian': 'روسي',

  'Rwandan': 'رواندي',

  'Saint Lucian': 'لوسياني',

  'Salvadoran': 'سلفادوري',

  'Samoan': 'ساموايان',

  'San Marinese': 'سان مارينيز',

  'Sao Tomean': 'ساو توميان',

  'Saudi': 'سعودي',

  'Scottish': 'سكتلندي',

  'Senegalese': 'سنغالي',

  'Serbian': 'صربي',

  'Seychellois': 'سيشلي',

  'Sierra Leonean': 'سيرا ليوني',

  'Singaporean': 'سنغافوري',

  'Slovakian': 'سلوفاكي',

  'Slovenian': 'سلوفيني',

  'Solomon Islander': 'جزر سليمان',

  'Somali': 'صومالي',

  'South African': 'جنوب افريقيي',

  'South Korean': 'كوري جنوبي',

  'Spanish': 'إسباني',

  'Sri Lankan': 'سري لانكي',

  'Sudanese': 'سوداني',

  'Surinamer': 'سورينامي',

  'Swazi': 'سوازي',

  'Swedish': 'سويدي',

  'Swiss': 'سويسري',

  'Syrian': 'سوري',

  'Taiwanese': 'تايواني',

  'Tajik': 'طاجيكي',

  'Tanzanian': 'تنزاني',

  'Thai': 'التايلاندي',

  'Togolese': 'توغواني',

  'Tongan': 'تونجاني',

  'Trinidadian or Tobagonian': 'ترينيدادي أو توباغوني',

  'Tunisian': 'تونسي',

  'Turkish': 'تركي',

  'Tuvaluan': 'توفالي',

  'Ugandan': 'أوغندي',

  'Ukrainian': 'أوكراني',

  'Uruguayan': 'أوروجواي',

  'Uzbekistani': 'أوزبكستاني',

  'Venezuelan': 'فنزويلي',

  'Vietnamese': 'فيتنامي',

  'Welsh': 'ويلزي',

  'Yemenite': 'يمني',

  'Zambian': 'زامبي',

  'Zimbabwean': 'زيمبابوي',

  'Algiers': 'الجزائر العاصمة',

  'Annaba': 'عنابة',

  'Azazga': 'عزازقة',

  'Batna City': 'مدينة باتنة',

  'Blida': 'البليدة',

  'Bordj': 'برج',

  'Bordj Bou Arreridj': 'برج بوعريريج',

  'Bougara': 'بوقرة',

  'Cheraga': 'الشراقة',

  'Chlef': 'الشلف',

  'Constantine': 'قسنطينة',

  'Djelfa': 'الجلفة',

  'Draria': 'دراريا',

  'El Tarf': 'الطارف',

  'Hussein Dey': 'حسين داي',

  'Illizi': 'إليزي',

  'Jijel': 'جيجل',

  'Kouba': 'القبة',

  'Laghouat': 'الأغواط',

  'Oran': 'وهران',

  'Ouargla': 'ورقلة',

  'Oued Smar': 'واد السمار',

  'Relizane': 'غليزان',

  'Rouiba': 'الرويبة',

  'Saida': 'صيدا',

  'Souk Ahras': 'سوق أهراس',

  'Tamanghasset': 'تمنغست',

  'Tiaret': 'تيارت',

  'Tissemsilt': 'تيسمسيلت',

  'Tizi': 'تيزي',

  'Tizi Ouzou': 'تيزي وزو',

  'Tlemcen': 'تلمسان',

  'Abraq Khaytan': 'ابرق خيطان',

  'Ad Dasmah': 'الدسمة',

  'Ad Dawhah': 'Ad Dawhah',

  'Al Ahmadi': 'الأحمدي',

  'Al Farwaniyah': 'الفروانية',

  'Al Shamiya': 'الشامية',

  'Ar Rawdah': 'الروضة',

  'As Salimiyah': 'السالمية',

  'Ash Shu`aybah': 'الشعيبة',

  'Ash Shuwaykh': 'الشويخ',

  'Bayan': 'بيان',

  'Hawalli': 'حولي',

  'Janub as Surrah': 'الجنوب مثل السرة',

  'Kayfan': 'كيفان',

  'Kuwait City': 'مدينة الكويت',

  'Salwa': 'سلوى',

  'Abha': 'أبها',

  'Abqaiq': 'ابقيق',

  'Al_Bahah': 'الباحة',

  'Al_Faruq': 'الفاروق',

  'Al_Hufuf': 'الهفوف',

  'Al_Qatif': 'القطيف',

  'Al_Yamamah': 'اليمامة',

  'At_Tuwal': 'أتول',

  'Buraidah': 'بريدة',

  'Dammam': 'الدمام',

  'Dhahran': 'الظهران',

  'Hayil': 'حائل',

  'Jazirah': 'الجزيرة',

  'Jeddah': 'جدة',

  'Jizan': 'جيزان',

  'Jubail': 'الجبيل',

  'Khamis_Mushait': 'خميس مشيط',

  'Khobar': 'مدينه الخبر',

  'Khulays': 'خليص',

  'Linah': 'لينا',

  'Madinat_Yanbu__as_Sina_iyah': 'مدينة_ ينبع_اس_سيناء',

  'Mecca': 'مكة المكرمة',

  'Medina': 'المدينة المنورة',

  'Mina': 'مينا',

  'Najran': 'نجران',

  'Rabigh': 'رابغ',

  'Rahimah': 'رحيمة',

  'Rahman': 'رحمن',

  'Ramdah': 'رمضة',

  'Ras_Tanura': 'رأس تنورة',

  'Riyadh': 'الرياض',

  'Sabya': 'صبيا',

  'Safwa': 'صفوى',

  'Sakaka': 'سكاكا',

  'Sambah': 'سامباح',

  'Sayhat': 'سيهات',

  'Tabuk': 'تبوك',

  'Yanbu__al_Bahr': 'ينبع_البحر',

  'Abu_Hammad': 'ابو حماد',

  'Al_Mahallah_al_Kubra': 'المحلة_ال_الكبرى',

  'Al_Mansurah': 'المنصورة',

  'Al_Marj': 'المرج',

  'Alexandria': 'الإسكندرية',

  'Almazah': 'الماظة',

  'Ar_Rawdah': 'الروضة',

  'Assiut': 'أسيوط',

  'Az_Zamalik': 'الزمالك',

  'Badr': 'بدر',

  'Banha': 'بنها',

  'Bani_Suwayf': 'بني سويف',

  'Cairo': 'القاهرة',

  'Damietta': 'دمياط',

  'Faraskur': 'فارسكور',

  'Flaminj': 'فلامينج',

  'Giza': 'الجيزة',

  'Heliopolis': 'مصر الجديدة',

  'Helwan': 'حلوان',

  'Hurghada': 'الغردقة',

  'Ismailia': 'الإسماعيلية',

  'Kafr_ash_Shaykh': 'كفرالشيخ',

  'Luxor': 'الأقصر',

  'October': 'أكتوبر',

  'Sina': 'سيناء',

  'Madinat_an_Nasr': 'Madinat_an_Nasr',

  'Madinat_as_Sadis_min_Uktubar': 'Madinat_as_Sadis_min_Uktubar',

  'Minya': 'المنيا',

  'Nasr': 'نصر',

  'New_Cairo': 'القاهرة الجديدة',

  'Port_Said': 'بورسعيد',

  'Rafah': 'رفح',

  'Ramsis': 'رمسيس',

  'Sadat': 'السادات',

  'Shirbin': 'شربين',

  'Shubra': 'شبرا',

  'Sohag': 'سوهاج',

  'Suez': 'السويس',

  'Tanta': 'طنطا',

  'Toukh': 'طوخ',

  'Zagazig': 'الزقازيق',

  'Abu_Dhabi': 'ابو ظبي',

  'Al_Ain': 'العين',

  'Al_Khan': 'الخان',

  'Ar_Ruways': 'الرويس',

  'As_Satwah': 'السطوح',

  'Dayrah': 'ديرة',

  'Dubai': 'دبي',

  'Fujairah': 'الفجيرة',

  'Ras_al_Khaimah': 'رأس الخيمة',

  'Sharjah': 'الشارقة',

  'Al Budayyi`': 'البديع',

  'Al Hadd': 'الحد',

  'Al Hamalah': 'الهملة',

  'Al Janabiyah': 'الجنبية',

  'Al Markh': 'المرخ',

  'Al Muharraq': 'المحرق',

  'Bani Jamrah': 'بني جمرة',

  'Barbar': 'باربار',

  'Jurdab': 'جرداب',

  'Madinat `Isa': 'مدينة عيسى',

  'Madinat Hamad': 'مدينة حمد',

  'Manama': 'المنامة',

  'Oil City': 'مدينة النفط',

  'Sanabis': 'السنابس',

  'Sanad': 'سند',

  'Sitrah': 'سترة',

  'Tubli': 'توبلي',

  'select_gender': 'أختار الجنس',

  'Male': 'ذكر',

  'Female': 'أنثى',

  'All': 'الجميع',

  'advanced_search': 'البحث المتقدم',

  'favorite': 'قأئمى المفضله',

  ///////////////

  ///

  ///

  ///

  ///

  ///

  'login': 'تسجيل الدخول',
  'Phone_Number': 'رقم الهاتف',
  'Password': 'كلمة المرور',
  'No_account_register': 'لا يوجد حساب، يرجى التسجيل',
  'forget_password': 'نسيت كلمة المرور',
  'Agree': 'موافق',
  'terms': 'الشروط والأحكام',
  'Congratulation': 'تهانينا',
  'Failed': 'فشل',
  'Login_fail': 'فشل تسجيل الدخول',
  'Thanks': 'شكرًا',
  'Login_success': 'تم تسجيل الدخول بنجاح',
  'Please_Enter_The_Name': 'الرجاء إدخال اسمك',
  'Enter_yourName': 'الرجاء إدخال اسمك',
  'Account_Type': 'الحساب',
  'Password_too_short': 'كلمة المرور قصيرة جدًا',
  'password': '',
  'password_are_not_matching': 'كلمات المرور غير متطابقة',
  'reenter_password': 'الرجاء إعادة إدخال كلمة المرور',
  'Already_have_an_account_sign_in': 'لدي بالفعل حساب',
  'Sign_up': 'التسجيل',
  'new_password': 'كلمة المرور الجديدة',
  're_enter_new_password': 'تأكيد كلمة المرور',
  'change_password': 'تغيير كلمة المرور',
  'Go_To_sign_in_Page': 'الانتقال إلى صفحة تسجيل الدخول',
  'enter_otp': 'الرجاء إدخال رمز الرسالة النصية (رقم التعريف) (6 أرقام)',
  'resend_otp': 'إعادة إرسال الرمز',
  'Invalid': 'خطأ',
  'user_error': 'بيانات المستخدم غير صالحة',
  'Less_size_100': 'حجم المنطقة أقل من 100 متر',
  'enter_size': 'أدخل حجم المنطقة',
  'Request': 'طلب',
  'Profile': 'الملف الشخصي',
  'Home': 'الصفحة الرئيسية',
  'invalid_num_or_already_exist': 'رقم غير صالح أو موجود بالفعل',
  'cannot_update_user_data': 'لا يمكن تحديث البيانات، الرجاء المحاولة لاحقًا',
  'can_not_updated_password': 'لا يمكن تحديث كلمة المرور',
  'Go_To_home_page': 'الانتقال إلى الصفحة الرئيسية',
  'old_password': 'كلمة المرور القديمة',
  'CHANGE_PASSWORD': 'تغيير كلمة المرور',
  'edit': 'تعديل',
  'myarea_size': 'حجم المنطقة',
  'update_size': 'تحديث الحجم',
  'order_histroy': 'سجل الطلبات',
  'aboutus': 'من نحن',
  'contactus': 'اتصل بنا',
  'change_language': 'تغيير اللغة',
  'logout': 'تسجيل الخروج',
  'error_data': 'خطأ في جلب البيانات، الرجاء المحاولة لاحقًا',
  'less_size_100': 'الحد الأدنى للحجم هو 100 متر',
  'ensure_internet_is_working': 'تأكد من أن الشبكة جيدة',
  'OK': 'موافق',
  'not_show_again': 'لا تظهر مرة أخرى',
  'or_login_with': 'أو تسجيل الدخول باستخدام',
  'no_account': 'ليس لديك حساب؟',
  'register_now': 'سجل الآن',
  'sing_agree': 'بالتسجيل، أنت توافق على',
  'wait_sms': 'يرجى الانتظار. جاري إرسال رسالة رسالة SMS..',
  'appointments': 'مواعيدي',
  'available': 'توافري',
  'Chat': 'الدردشة',
  'my_next_session': 'المحاضرة القادمة',
  'my_students': 'طلابي',
  'country_hint': 'البلد',
  'Search_hint': 'البحث…',
  'city_hint': 'المدينة',
  'nationality_hint': 'الجنسية',
  'list': 'قائمة الدردشة',
  'search_name': 'البحث حسب الاسم',
  'type_message': 'اكتب رسالتك...',
  'Hi': 'مرحبًا',
  'Gender': 'الجنس',
  'error_user': 'اسم المستخدم مستخدم بالفعل أو يحتوي على خطأ',
  'error_num': 'رقم غير صالح أو موجود بالفعل',
  'pass_change_succ': 'تم تغيير كلمة المرور بنجاح',
  'pass_change_fail': 'تعذر تحديث كلمة المرور',
  'phone_not': 'رقم الهاتف غير صالح',
  'otp_sent': 'لم يتم إرسال رمز رقم التعريف',
  'otp_sms': 'رمز رقم التعريف',
  'otp_valid': 'رقم التعريف صالح',
  'Success': 'نجاح',
  'Correct_OTP': 'رمز رقم التعريف صحيح',
  'Invalid_OTP': 'رمز رقم التعريف غير صالح',
  'user_Name': 'اسم المستخدم',
  'confirm_password': 'تأكيد كلمة المرور',
  'Next': 'التالي',
  'sent_code': 'لقد أرسلنا لك رمز الوصول',
  'via_sms': 'عبر رسالة رسالة SMS للتحقق من رقم الجوال',
  'sent_sms_to_num': 'تم إرساله عبر رسالة رسالة SMS على هذا الرقم',
  'I_confirm_data': 'لقد قرأت وأقبل الشروط والأحكام',
  'update': 'تحديث',
  'Birth_date': 'سنة الميلاد',
  'sure_exit': 'هل أنت متأكد أنك تريد الخروج؟',
  'No': 'لا',
  'Yes': 'نعم',
  'Login_Register': 'تسجيل الدخول/التسجيل',
  'fetch_failed': 'فشل الاتصال',
  'Intro_11': 'قبل أن تبدأ',
  'Intro_12': 'يجب عليك اختيار الطريق الصحيح...',
  'Intro_21': 'الآن هنا!',
  'Intro_22': 'لمساعدتك على بدء النجاح والوصول إلى الطريق الصحيح',
  'Quran': 'القرآن',
  'next_': 'المحاضرة القادمة لك',
  'feedback': 'تعليقك...',
  'Comment': 'تعليق',
  'change_session': 'تغيير وقت المحاضرة',
  'sure_change_session': 'هل أنت متأكد أنك تريد تغيير وقت المحاضرة؟',
  'Next_sessions': 'المحاضرات القادمة',
  'Old_session': 'المحاضرات القديمة',
  'Warning': 'تحذير',
  'cannot_change_withinhour': 'لا يمكنك تغيير مؤقت المحاضرة في غضون ساعة واحدة',
  'Joinachannel': 'الانضمام إلى القناة',
  'thanks_registeration': 'شكرًا لتسجيلك معنا',
  'Selected_teacher': 'المحاضر المختار',
  'Selected_package': 'الحزمة المختارة تتكون من',
  'session_cost': 'محاضرات بتكلفة',
  'EGP': 'جنيه مصري',
  'admin_will_call': 'يتصل بك المسؤول قريبًا',
  'Select': 'اختر',
  'select_pack_first': 'يرجى اختيار الباقة أولاً',
  'Select_Package': 'يرجى اختيار الباقة',
  'Note': 'ملحوظة',
  'select_session_first': 'يرجى اختيار المحاضرات أولاً',
  'Submit': 'إرسال',
  'out_of': 'خارج',
  'sesions': 'محاضرات',
  'Saturday': 'السبت',
  'Sunday': 'الأحد',
  'Monday': 'الاثنين',
  'Tuesday': 'الثلاثاء',
  'Wednesday': 'الأربعاء',
  'Thursday': 'الخميس',
  'Friday': 'الجمعة',
  'from_time': 'من:',
  'to_time': 'إلى:',
  'Cancel': 'إلغاء',
  'invalid_time_after_before':
      'تحديد وقت غير صالح. يجب أن يكون وقت النهاية بعد وقت البداية.',
  'Save': 'حفظ',
  'sure_del_avail': 'هل أنت متأكد أنك تريد حذف هذه الفترة من التوفر؟',
  'Delete': 'حذف',
  'Availability': 'التوفر',
  'add_new': 'إضافة جديدة',
  'No_free_slots': 'لا توجد فتحات مجانية',
  'MyStudents': 'طلابي',
  'MyTeachers': 'معلموي',
  'open_use_ayaat': 'الوصول من خلال الآيات',
  'open_use_file': 'البدء باستخدام الملف المحلي',
  'open_use_flash': 'الوصول من خلال الفلاش',
  'reEnter_New_password': 'إعادة إدخال كلمة المرور الجديدة',
  'Session_Review': 'مراجعة الجلسة',
  'subscription_package': 'حزمة الاشتراك',
  'package_price': 'أسعار الحزمة',
  'qna': 'الأسئلة والأجوبة',
  'Loading': 'تحميل',
  'next_s': 'الجلسة القادمة',
  'Paid': 'مدفوع',
  'notification_required': 'مطلوب إذن الإشعار',
  'notification_perm_req': 'مطلوب إذن الإشعارات لتلقي الإشعارات الفورية',
  'open_setting': 'افتح الإعدادات',
  'notification': 'الإشعارات',
  'you_have_not': 'ليس لديك',
  'Notification_Currently': 'إشعار حاليًا',
  'open_use_falsh': 'الوصول من خلال الفلاش',
  'sel_quran': 'اختر من مصادر القرآن المتنوعة المتوفرة هنا',
  'Not_show_again': 'لا تظهر مرة أخرى',
  'show_more': 'عرض المزيد',
  'show_less': 'عرض أقل',
  'aval_appoint': 'مواعيد التوافر',
  'Reviews': 'المراجعات',
  'search_teacher': 'البحث عن معلم',
  'date': 'التاريخ',
  'Time': 'الوقت',
  'search': 'البحث',
  'filter': 'التصفية',
  'man': 'رجل',
  'woman': 'امرأة',
  'children': 'أطفال',
  'Camera': 'كاميرا',
  'memorization': 'حفظ القرآن',
  'tagweed': 'تجويد',
  'search_result': 'نتائج البحث',
  'no_data': 'لا توجد بيانات',
  'check_teacher_avail': 'تحقق من توافر المعلم',
  'next_choose_teacher': 'ثم، اختر المعلم الذي ترغب في الاشتراك فيه',
  'skip_dont_show': 'تخطي وعدم إظهار مرة أخرى',
  'No_free_slots_teacher':
      'لا تتوفر فتحات مجانية. لن يكون المعلم متاحًا للشهور الثلاثة القادمة.',
  'pls_sub_first': 'يرجى الاشتراك أولاً',
  'pls_renew_sub': 'يرجى تجديد اشتراكك أولاً',
  'session_start_at': 'ستبدأ جلستك في',
  'session_not_start': 'لم تبدأ الجلسة بعد.',
  'join_session': 'انضم للجلسة',
  'No_of_sessions': 'عدد الجلسات',
  'remainingSessions': 'الجلسات المتبقية',
  'Popular_Questions': 'الأسئلة الشائعة',
  'Selected': 'محدد',
  'sessions': 'جلسات',
};
