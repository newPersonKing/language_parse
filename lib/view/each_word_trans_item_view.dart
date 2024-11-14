
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_parse/string_ext.dart';
import 'package:translator/translator.dart';

import '../json_file_export_page.dart';

class EachWorTransItemView extends StatefulWidget{

  final WordTransEntity wordTransEntity;

  const EachWorTransItemView({super.key,required this.wordTransEntity});

  @override
  State<StatefulWidget> createState() => _EachWorTransItemViewState();

}

class _EachWorTransItemViewState extends State<EachWorTransItemView>{

  var wordChangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    wordChangeController.addListener((){
      if(wordChangeController.text != widget.wordTransEntity.word){
        setState(() {
          widget.wordTransEntity.isEdit = true;
        });
      }else {
        setState(() {
          widget.wordTransEntity.isEdit = false;
        });
      }
    });
    wordChangeController.text = widget.wordTransEntity.word;
  }
  @override
  Widget build(BuildContext context) {

    return Material(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.blue,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("翻译内容:",style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      )),
                      Expanded(child: TextField(
                        controller: wordChangeController,
                      ))
                    ],
                  ),
                  ...widget.wordTransEntity.translatorMap.keys.map((item)=>Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("语言:$item",style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black
                        ),),
                        Text("结果:${widget.wordTransEntity.translatorMap[item] ?? ""}",style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black
                        ),),
                      ]
                  ))
                ],
              )),
              if( widget.wordTransEntity.isEdit) GestureDetector(
                onTap: (){
                  if(wordChangeController.text.isEmpty)return;
                  transEachWord(wordChangeController.text);
                },
                child:  Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: const EdgeInsets.all(15),
                  child: const Text("修改",style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),),
                ),
              ),
              if(widget.wordTransEntity.isEdit) GestureDetector(
                onTap: (){
                  wordChangeController.text = widget.wordTransEntity.word;
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: const EdgeInsets.all(15),
                  child: const Text("重置",style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final translator = GoogleTranslator();
  Future transEachWord(String text) async{
    if(text.isEmpty)return;
    try{

      var translatorTemp = <String,String>{};
      var enTans = await translator.translate(text, from: 'zh-cn', to: "en");
      translatorTemp['en'] = enTans.text;
      Future transEach(String language) async{
        var result = await translator.translate(enTans.text, from: 'en', to: language);
        translatorTemp[language] = result.text;
      }
      await Future.wait(widget.wordTransEntity.translatorMap.keys.where((item)=>item != 'en').map((item)=> transEach(item)));
      widget.wordTransEntity.key = enTans.text.toKey();
      widget.wordTransEntity.translatorMap = translatorTemp;
      widget.wordTransEntity.word = text;
      widget.wordTransEntity.isEdit = false;
      setState(() {

      });
    }catch(e){

    }
  }

}