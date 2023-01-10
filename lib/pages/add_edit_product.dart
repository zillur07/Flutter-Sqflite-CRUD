import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sqflite/models/products_model.dart';
import 'package:flutter_sqflite/service/db_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AddEditProductPage extends StatefulWidget {
  AddEditProductPage({
    Key? key,
    this.model,
    this.isEditMode = false,
  }) : super(key: key);
  ProductModel? model;
  bool isEditMode;

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late ProductModel model;
  List<dynamic> categories = [];
  late DBService dbService;
  @override
  void initState() {
    dbService = DBService();
    model = ProductModel(productName: '', categoryId: -1);
    if (widget.isEditMode) {
      model = widget.model!;
    }
    categories.add({'id': '1', 'name': 'T-Shirts'});
    categories.add({'id': '2', 'name': 'Shirts'});
    categories.add({'id': '3', 'name': 'Polo-Shirts'});
    categories.add({'id': '4', 'name': 'Jeans'});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? 'Edit Product ' : 'Add Product'),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormHelper.submitButton(
              'Sive',
              () {
                if (validateAndSive()) {
                  if (widget.isEditMode) {
                    dbService.updateProduct(model).then(
                          (value) => FormHelper.showSimpleAlertDialog(
                            context,
                            'SQFLITE',
                            "Data Modifed Successfully",
                            'OK',
                            () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                  } else {
                    dbService.addProduct(model).then(
                          (value) => FormHelper.showSimpleAlertDialog(
                        context,
                        'SQFLITE',
                        "Data Added Successfully",
                        'OK',
                            () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                }
              },
              borderRadius: 10,
              btnColor: Colors.green,
              borderColor: Colors.green,
            ),
            FormHelper.submitButton(
              'Cancel',
              () {},
              borderRadius: 10,
              btnColor: Colors.grey,
              borderColor: Colors.grey,
            ),
          ],
        ),
      ),
      body: Form(key: globalKey, child: _formUI()),
    );
  }

  _formUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FormHelper.inputFieldWidgetWithLabel(
            context,
            'productName',
            "Product Name",
            '',
            (onValidate) {
              if (onValidate.isEmpty) {
                return '* Required';
              }
              return null;
            },
            (onSaved) {
              model.productName = onSaved.toString().trim();
            },
            initialValue: model.productName,
            showPrefixIcon: true,
            prefixIcon: Icon(Icons.text_fields),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            labelFontSize: 14,
            paddingRight: 0,
            paddingLeft: 0,
            prefixIconPaddingLeft: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: FormHelper.inputFieldWidgetWithLabel(
                  context,
                  'productPrice',
                  "Product Price",
                  '',
                  (onValidate) {
                    if (onValidate.isEmpty) {
                      return '* Required';
                    }
                    return null;
                  },
                  (onSaved) {
                    model.price = double.parse(onSaved);
                  },
                  initialValue: model.productName,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.currency_exchange_outlined),
                  borderRadius: 10,
                  contentPadding: 15,
                  fontSize: 14,
                  labelFontSize: 14,
                  paddingRight: 0,
                  paddingLeft: 0,
                  prefixIconPaddingLeft: 10,
                  isNumeric: true,
                ),
              ),
              Flexible(
                flex: 1,
                child: FormHelper.dropDownWidgetWithLabel(
                  context,
                  'Product Category',
                  '--Select--',
                  model.categoryId,
                  categories,
                  (onChanged) {
                    model.categoryId = int.parse(onChanged);
                  },
                  (onValidate) {},
                  borderRadius: 10,
                  labelFontSize: 14,
                  paddingLeft: 0,
                  paddingRight: 0,
                  hintFontSize: 14,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.category),
                  prefixIconPaddingLeft: 10,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          FormHelper.inputFieldWidgetWithLabel(
            context,
            'productDesc',
            "Product Description",
            '',
            (onValidate) {
              if (onValidate.isEmpty) {
                return '* Required';
              }
              return null;
            },
            (onSaved) {
              model.productDese = onSaved.toString().trim();
            },
            initialValue: model.productDese ?? '',
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            labelFontSize: 14,
            paddingRight: 0,
            paddingLeft: 0,
            prefixIconPaddingLeft: 10,
            isMultiline: true,
            multilineRows: 5,
          ),
          SizedBox(
            height: 30,
          ),
          _picPicker(
            model.productPic ?? '',
            (file) => {
              setState(
                () {
                  model.productPic = file.path;
                },
              ),
            },
          ),
        ],
      ),
    );
  }

  _picPicker(
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();
    return Column(
      children: [
        fileName != ''
            ? Image.file(
                File(fileName),
                width: 250,
                height: 200,
                fit: BoxFit.scaleDown,
              )
            : SizedBox(
                child: Image.asset(
                  'img/damiImage.png',
                  height: 170,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.image,
                    size: 45,
                  ),
                ),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.gallery);
                  _imageFile.then(
                    (file) async {
                      onFilePicked(file);
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.camera,
                    size: 45,
                  ),
                ),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.camera);
                  _imageFile.then(
                    (file) async {
                      onFilePicked(file);
                    },
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  bool validateAndSive() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
