

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:language_parse/model/language_info.dart';
import 'package:language_parse/string_ext.dart';
import 'package:translator/translator.dart';

import 'model/json_entity.dart';
import 'view/each_word_trans_item_view.dart';

class JsonFileExportPage extends StatefulWidget {

  final List<LanguageInfo> languageList;

  const JsonFileExportPage({super.key,required this.languageList});

  @override
  State<StatefulWidget> createState() => _JsonFileExportPageState();

}

class _JsonFileExportPageState extends State<JsonFileExportPage>{

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener((){
      refreshShowList();
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
                  if(isLoadFile)return;
                  loadWordLit();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: isLoadFile ? Colors.grey : Colors.green
                  ),
                  child: const Text("导入文件",style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),),
                ),
              ),
              const SizedBox(width: 15,),
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
              itemCount: showWordTransList.length,
              itemBuilder: (context,index){
                return EachWorTransItemView(wordTransEntity: showWordTransList[index],);
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
    if(wordTransList.isEmpty)return;
    for (var languageInfo in widget.languageList) {
      var keys = languageInfo.keyList;
      var language = languageInfo.language;
      for (var item in wordTransList) {
        var nKey = item.key;
        if(keys.contains(nKey)){
          continue;
        }
        var nValue = item.translatorMap[language] ?? "";
        languageInfo.valueList.add(JsonEntity()
          ..key = nKey
          ..value = nValue);
      }
    }

    Future.wait(widget.languageList.map((item)=>saveEachLanguage(item)));
    showToast("保存成功",context: context);
    setState(() {
      isSave = false;
    });
  }

  Future saveEachLanguage(LanguageInfo language) async{
    try{
      var valueList = language.valueList;
      var map =  <String,String>{};
      for (var item in valueList) {
        map[item.key] = item.value;
      }
      // 创建一个 JsonEncoder 实例，并设置 prettyPrint 为 true
      JsonEncoder encoder = const JsonEncoder.withIndent('  '); // 使用两个空格进行缩进
      // 序列化 Dart 对象为 JSON 字符串，并指定 prettyPrint
      var saveJson = encoder.convert(map);
      // var saveJson = jsonEncode(map);
      var file = File(language.path);
      await file.writeAsString(saveJson);
    }catch(e){

    }
  }

  List<String> wordList = [];
  var isLoadFile = false;
  void loadWordLit() async{
    setState(() {
      isLoadFile = true;
    });
    try{
      var result = await FilePicker.platform.pickFiles();
      if(result != null){
        var wordFile = File(result.files.single.path!);
        wordList = await wordFile.readAsLines();
      }
      wordTransList.clear();
      await Future.wait(wordList.map((item)=>transEachWord(item)));
    }catch(e){

    }
    setState(() {
      isLoadFile = false;
    });
  }
  final translator = GoogleTranslator();
  List<WordTransEntity> wordTransList = [];
  List<WordTransEntity> showWordTransList = [];
  Future transEachWord(String text) async{
    if(text.isEmpty)return;
    try{
      var translatorTemp = <String,String>{};
      var enTans = await translator.translate(text, from: 'zh-cn', to: "en");
      translatorTemp['en'] = enTans.text;
      Future transEach(LanguageInfo item) async{
        var result = await translator.translate(enTans.text, from: 'en', to: item.language);
        translatorTemp[item.language] = result.text;
      }
      await Future.wait(widget.languageList.where((item)=>item.language != 'en').map((item)=> transEach(item)));
      wordTransList.add(WordTransEntity()
        ..word = text
        ..key = enTans.text.toKey()
        ..translatorMap = translatorTemp);
      refreshShowList();
    }catch(e){

    }
  }

  void refreshShowList(){
    if(searchController.text.isEmpty){
      showWordTransList = wordTransList;
    }else {
      showWordTransList = wordTransList.where((item)=>item.word.contains(searchController.text)).toList();
    }
    setState(() {

    });
  }


}

class WordTransEntity {
  var word = "";
  var key = "";
  var translatorMap = <String,String>{};
}