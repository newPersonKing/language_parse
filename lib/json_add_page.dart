import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:language_parse/model/json_entity.dart';
import 'package:translator/translator.dart';
import 'model/language_info.dart';

class JsonAddPage extends StatefulWidget {

  final List<LanguageInfo> allLanguages;

  const JsonAddPage({super.key,required this.allLanguages});

  @override
  State<StatefulWidget> createState() => _JsonEditPageState();
}


class _JsonEditPageState extends State<JsonAddPage>{

  var translatorTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Stack(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Text("翻译内容:(汉语)",style: TextStyle(
                            fontSize: 14,
                            color: Colors.black
                        ),),
                      ),
                      Expanded(child: TextField(
                        controller: translatorTxtController,
                      )),
                      GestureDetector(
                        onTap: (){
                          if(isTranslator || isSave)return;
                          translatorMethod();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isTranslator || isSave ? Colors.grey:Colors.green,
                          ),
                          alignment: Alignment.center,
                          width: 100,
                          child: const Text("翻译",style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(isTranslator || isSave)return;
                          addToData();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isTranslator || isSave ? Colors.grey:Colors.green,
                          ),
                          alignment: Alignment.center,
                          width: 100,
                          child: const Text("保存",style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  const Text("翻译结果：",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      )
                  ),
                  ...translatorTemp.keys.map((item)=>Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item,style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey
                      )),
                      Text(translatorTemp[item] ?? "",style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),)
                    ],
                  )),
                ],
              )
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios_sharp,size: 40,),
            ),
          ),
        ],
      ),
    );
  }

  final translator = GoogleTranslator();
  var translatorTemp = <String,String>{};
  var isTranslator = false;
  void translatorMethod() async{
    var text = translatorTxtController.text;
    if(text.isEmpty)return;
    setState(() {
      isTranslator = true;
    });
    try{
      var enTans = await translator.translate(text, from: 'zh-cn', to: "en");
      translatorTemp['en'] = enTans.text;
      Future transEach(LanguageInfo item) async{
        var result = await translator.translate(enTans.text, from: 'en', to: item.language);
        translatorTemp[item.language] = result.text;
      }
      await Future.wait(widget.allLanguages.where((item)=>item.language != 'en').map((item)=> transEach(item)));
    }catch(e){

    }
    setState(() {
      isTranslator = false;
    });
  }

  var isSave = false;
  void addToData() async{
    var key = translatorTemp["en"] ?? "";
    if(key.isEmpty)return;
    var writeKey = key.replaceAll(" ", "_");
    writeKey = writeKey.replaceAll("'", "");
    writeKey = writeKey.replaceAll(",", "_");
    writeKey = writeKey.replaceAll("，", "_");
    for (var item in widget.allLanguages) {
      if(item.keyList.contains(writeKey)){
        showToast('${item.language}已经包含相同的key:$key',context: context);
        return;
      }
    }
    setState(() {
      isSave = true;
    });
    try{
      for (var item in widget.allLanguages) {
        var entity = JsonEntity()
          ..key = writeKey
          ..value = translatorTemp[item.language] ?? "";
        item.valueList.add(entity);
        var nContent = "${(item.content.substring(0,item.content.length - 1)).trim()},\n\"$writeKey\":\"${entity.value}\"}";
        await File(item.path).writeAsString(nContent);
        item.content = nContent;
        item.keyList.add(writeKey);
      }
    }catch(e){

    }
    showToast("保存成功",context: context);
    setState(() {
      isSave = false;
    });
  }
}