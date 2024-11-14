
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/json_entity.dart';

class EachKeyAddView extends StatefulWidget {

  final ValueChanged<JsonEntity> onAdd;

  const EachKeyAddView({super.key,required this.onAdd});

  @override
  State<StatefulWidget> createState() {
    return _EachKeyEditViewState();
  }
}

class _EachKeyEditViewState extends State<EachKeyAddView>{

  final  keyController = TextEditingController();
  final  valueController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.green,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(30),
      child: Row(
        children: [
          Expanded(child: Column(
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
          )),
          GestureDetector(
            onTap: (){
              var key = keyController.text;
              var value = valueController.text;
              if(key.isEmpty || value.isEmpty)return;
              widget.onAdd.call(
                JsonEntity()
                    ..key = key
                    ..value = value
              );
            },
            child:  Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(left: 15,right: 15),
              child: const Text("ADD",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

}