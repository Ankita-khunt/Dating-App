import 'package:dating_app/imports.dart';

class FAQResponse extends Serializable {
  String? name;
  String? username;
  String? contactNumber;
  String? contactEmail;
  List<FaqList>? faqList;

  FAQResponse(
      {this.name,
      this.username,
      this.contactNumber,
      this.contactEmail,
      this.faqList});

  FAQResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    contactNumber = json['contact_number'];
    contactEmail = json['contact_email'];
    if (json['faq_list'] != null) {
      faqList = <FaqList>[];
      json['faq_list'].forEach((v) {
        faqList!.add(FaqList.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['contact_number'] = contactNumber;
    data['contact_email'] = contactEmail;
    if (faqList != null) {
      data['faq_list'] = faqList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FaqList {
  String? id;
  String? question;
  String? answer;

  FaqList({this.id, this.question, this.answer});

  FaqList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}
