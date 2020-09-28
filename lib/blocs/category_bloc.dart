import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase{

  final _titleController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream.transform(
    StreamTransformer<String, String>.fromHandlers(
      handleData: (title, sink){
        if(title.isEmpty)
          sink.addError("Insira um título");
        else
          sink.add(title);
      }
    )
  );
  Stream get outImage => _imageController.stream;
  Stream<bool> get outDelete => _deleteController.stream;

  Stream<bool> get submitValid => Rx.combineLatest2(
    outTitle, outImage, (a, b) => true
  );

  DocumentSnapshot category;

  String title;
  File image;

  CategoryBloc(this.category){
    if (category != null){

      title = category.data["title"];

      _titleController.add(category.data["title"]);
      _imageController.add(category.data["icon"]);
      _deleteController.add(true);
    }else{
      _deleteController.add(false);
    }
  }

  void setImage(File file){
    image = file;
    _imageController.add(file);
  }

  void setTitle(String title){
    this.title = title;
    _titleController.add(title);
  }

  void delete(){
    category.reference.delete();
  }

  Future saveData() async {
    if (image == null && category != null && title == category.data["title"]){
      return;
    }

    Map<String, dynamic> dataToUpdate = {};

    if (image != null){
      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child("icons")
          .child(title).putFile(image);

      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      dataToUpdate["icon"] = await taskSnapshot.ref.getDownloadURL();

      if (category == null || title != category.data["title"]){
        dataToUpdate["title"] = title;
      }

      if (category == null){
        await Firestore.instance.collection("products").document((title.toLowerCase()))
            .setData(dataToUpdate);
      }else{
        await category.reference.updateData(dataToUpdate);
      }

    }
  }

  @override
  void dispose() {
    _titleController.close();
    _imageController.close();
    _deleteController.close();
    super.dispose();
  }
}