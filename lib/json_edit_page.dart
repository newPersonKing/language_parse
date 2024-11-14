

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_parse/model/language_info.dart';
import 'package:language_parse/view/each_key_edit_view.dart';

import 'model/json_entity.dart';

class JsonEditPage extends StatefulWidget {

  final LanguageInfo languageInfo;

  const JsonEditPage({super.key,required this.languageInfo});

  @override
  State<StatefulWidget> createState() => _JsonEditPageState();

}

class _JsonEditPageState extends State<JsonEditPage>{

  final searchController = TextEditingController();

  List<JsonEntity> showList = [];

  @override
  void initState() {
    super.initState();
    showList = widget.languageInfo.valueList;
    searchController.addListener((){
      if(searchController.text.isEmpty){
        showList = widget.languageInfo.valueList;
      }else {
        showList = widget.languageInfo.valueList.where((item)=>item.key.contains(searchController.text)).toList();
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close,size: 30),
              ),
              const Spacer(),
              GestureDetector(
                onTap: (){
                  if(isSave)return;
                  save();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: isSave ? Colors.grey : Colors.green
                  ),
                  child: const Text("保存",style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30,),
          Row(
            children: [
              const Text("搜索:",style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
              ),),
              Expanded(child: TextField(
                controller: searchController,
              ))
            ],
          ),
          Expanded(child: ListView.builder(
              itemCount: showList.length,
              itemBuilder: (context,index){
                return EachKeyEditView(item: showList[index]);
              })
          )
        ],
      ),
    );
  }

  var isSave = false;
  void save(){
    setState(() {
      isSave = true;
    });
    try{
      var valueList = widget.languageInfo.valueList;
      var map =  <String,String>{};
      for (var item in valueList) {
        map[item.key] = item.value;
      }
      // var saveJson = "{\n";
      // for(var i = 0 ; i < valueList.length; i++){
      //   var item = valueList[i];
      //   if( i < valueList.length - 1){
      //     saveJson += "\"${item.key}\":\"r${item.value}\",\n";
      //   }else {
      //     saveJson += "\"${item.key}\":\"${item.value}\"\n";
      //   }
      //
      // }
      // 创建一个 JsonEncoder 实例，并设置 prettyPrint 为 true
      JsonEncoder encoder = const JsonEncoder.withIndent('  '); // 使用两个空格进行缩进

      // 序列化 Dart 对象为 JSON 字符串，并指定 prettyPrint
      var saveJson = encoder.convert(map);
      // var saveJson = jsonEncode(map);
      var file = File(widget.languageInfo.path);
      file.writeAsString(saveJson);
    }catch(e){

    }
    setState(() {
      isSave = false;
    });
  }
}