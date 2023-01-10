import 'package:flutter_sqflite/models/model.dart';

class ProductModel extends Model {
  static String table = 'Products';

  int? id;
  String productName;
  int categoryId;
  String? productDese;
  double? price;
  String? productPic;

  ProductModel({
    this.id,
    required this.categoryId,
    this.price,
    this.productDese,
    required this.productName,
    this.productPic,
  });

  static ProductModel fromMap(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        categoryId: json['categoryId'],
        productName: json['productName'].toString(),
        price: json['price'],
        productDese: json['productDese'].toString(),
        productPic: json['productPic']);
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'id': id,
      'categoryId': categoryId,
      'productName': productName,
      'price': price,
      'productDese': productDese,
      'productPic': productPic,
    };
    if(id != null ){
      map['id'] = id;
    }
    return map;
  }
}
