class Quetions {
  int? id;
  String? question;
  String? answer;
  String? questionAr;
  String? answerAr;

  Quetions(
      {this.id, this.question, this.answer, this.questionAr, this.answerAr});

  Quetions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    questionAr = json['questionAr'];
    answerAr = json['answerAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['questionAr'] = this.questionAr;
    data['answerAr'] = this.answerAr;
    return data;
  }
}
