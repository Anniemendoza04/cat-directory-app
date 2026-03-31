import '../../domain/entities/cat_fact.dart ';

class CatFactModel extends CatFact {
  const CatFactModel({required super.fact});
  factory CatFactModel.fromJson(Map<String, dynamic> json) {
    return CatFactModel(fact: json['fact'] ?? 'No fact available');
  }
}
