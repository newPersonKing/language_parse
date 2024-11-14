

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/json_entity.dart';

class EachKeyEditView extends StatefulWidget {

  final JsonEntity item;

  const EachKeyEditView({super.key,required this.item});

  @override
  State<StatefulWidget> createState() {
    return _EachKeyEditViewState();
  }
}

class _EachKeyEditViewState extends State<EachKeyEditView>{

  final  keyController = TextEditingController();
  final  valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    keyController.addListener((){
      widget.item.key = keyController.text;
    });
    valueController.addListener((){
      widget.item.value = valueController.text;
    });
    keyController.text = widget.item.key;
    valueController.text = widget.item.value;
  }

  @override
  void didUpdateWidget(covariant EachKeyEditView oldWidget) {
    super.didUpdateWidget(oldWidget);
    keyController.text = widget.item.key;
    valueController.text = widget.item.value;
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.green,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 50,
                child: Text("key:",style: TextStyle(
                    fontSize: 14,
                    color: Colors.black
                ),),
              ),
              Expanded(child: TextField(
                controller: keyController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder()
                ),
              ))
            ],
          ),
           Row(
            children: [
              const SizedBox(
                width: 50,
                child: Text("value:",style: TextStyle(
                    fontSize: 14,
                    color: Colors.black
                ),),
              ),
              Expanded(child: TextField(
                controller: valueController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder()
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

}