

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:language_parse/json_file_export_page.dart';

import 'json_add_page.dart';
import 'json_edit_page.dart';
import 'model/json_entity.dart';
import 'model/language_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{

  List<LanguageInfo> languageList = [];
  @override
  void initState() {
    super.initState();
    FilePicker.platform = FilePickerMacOS();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: (){
              loadData();
            },
            child:  Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: const Text("选择文件夹"),
            ),
          ),
          if(isLoadFinish) GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return JsonAddPage(allLanguages: languageList,);
              }));
            },
            child:  Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8)
              ),
              height: 50,
              alignment: Alignment.center,
              child: const Text("新增"),
            ),
          ),
          const SizedBox(height: 15,),
          if(isLoadFinish) GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return JsonFileExportPage(languageList: languageList,);
              }));
            },
            child:  Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8)
              ),
              height: 50,
              alignment: Alignment.center,
              child: const Text("文件导入(每个需要翻译的内容单独占一行)"),
            ),
          ),
          ...languageList.map((item)=>GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return JsonEditPage(languageInfo: item);
              }));
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              color: Colors.green,
              height: 50,
              alignment: Alignment.center,
              child: Text(item.path.split("/").last,style: const TextStyle(fontSize: 20),),
            ),
          ))
        ],
      ),
    );
  }

  bool isLoadFinish = false;
  void loadData() async{
    String result = await FilePicker.platform.getDirectoryPath() ?? "";
    languageList.clear();
    if(result.isNotEmpty){
      Directory dir = Directory(result);
      var  jsonFileList =  dir.listSync().map((item)=>item.path).where((item)=>item.endsWith("arb")).toList();
      for (var item in jsonFileList) {
        var languageInfo = LanguageInfo();
        languageInfo.path = item;
        var (valueList,content,keys) = await parseJson(item);
        languageInfo.valueList = valueList;
        languageInfo.content = content.trim();
        languageInfo.showList = languageInfo.valueList;
        languageInfo.keyList = keys;
        var name = item.split("/").last;
        var language = name.substring(name.indexOf("_")+1,name.indexOf("."));
        languageInfo.language = language;
        languageList.add(languageInfo);
      }}
    setState(() {
      isLoadFinish = true;
    });
  }

  Future<(List<JsonEntity>,String,List<String>)> parseJson(String path) async{
    var jsonStr =   await File(path).readAsString();
    var jsonListMap = jsonDecode(jsonStr);
    List<JsonEntity> jsonEntityList = [];
    List<String> keys = [];
    if(jsonListMap is Map<String,dynamic>){
      keys = jsonListMap.keys.toList();
      for (var item in keys) {
        jsonEntityList.add(JsonEntity()
          ..key = item
          ..value = jsonListMap[item]);
      }
    }
    return (jsonEntityList,jsonStr,keys);
  }

}