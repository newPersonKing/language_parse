
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../json_file_export_page.dart';

class EachWorTransItemView extends StatelessWidget{

  final WordTransEntity wordTransEntity;

  const EachWorTransItemView({super.key,required this.wordTransEntity});

  @override
  Widget build(BuildContext context) {

    return Material(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.blue,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("翻译内容:${wordTransEntity.word}",style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black
              )),
              ...wordTransEntity.translatorMap.keys.map((item)=>Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("语言:$item",style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),),
                  Text("结果:${wordTransEntity.translatorMap[item] ?? ""}",style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),),
                ],))
            ],
          ),
        ),
      ),
    );
  }

}