import 'package:flutter_sqflite/models/products_model.dart';
import 'package:flutter_sqflite/utils/db_helper.dart';

class DBService {
  Future<List<ProductModel>> getProducts() async {
    await DBHelper.int();
    List<Map<String, dynamic>> products =
        await DBHelper.query(ProductModel.table);
    return products.map((item) => ProductModel.fromMap(item)).toList();
  }

  Future<bool> addProduct(ProductModel model) async {
    await DBHelper.int();
    int ret = await DBHelper.insert(ProductModel.table, model);
    return ret > 0 ? true : false;
  }

  Future<bool> updateProduct(ProductModel model) async {
    await DBHelper.int();
    int ret = await DBHelper.update(ProductModel.table, model);
    return ret > 0 ? true : false;
  }

  Future<bool> deleteProduct(ProductModel model) async {
    await DBHelper.int();
    int ret = await DBHelper.delete(ProductModel.table, model);
    return ret > 0 ? true : false;
  }
}
