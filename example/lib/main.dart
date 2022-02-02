import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_rive_login/flutter_rive_login.dart';
import 'package:flutter_rive_login_example/list_const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var getValue = '';
  int? getIndex;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Rive Login Plugin Demonstration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: getValue.isNotEmpty ? getValue : null,
              items: assetList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  getValue = value!;
                  getIndex = assetList.indexOf(getValue);
                });
              },
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => StateMachineTriggerAnimation(
                    isAsset:
                        true,
                    imageName: "assets/${getValue}.riv",
                    stateMachines: stateMachinesList[
                        getIndex!],
                    boolInputList: boolInputList[
                        getIndex!],
                    doubleInputList: doubleInputList.length > 1
                        ? doubleInputList[getIndex!]
                        : doubleInputList[
                            0],
                    applyPasswordChanges: (value){
                      checkPassword(value);
                    },
                    buttonColor:Colors.green,
                    buttonTitle: "Submit",
                    emailHint: "Enter Email Address",
                    colors: Colors.black,
                    passwordHint: "Enter Password",
                    applyEmailChanges: (value){
                     checkEmail(value);
                    },
                    initialsSetAnimations: [
                      'idle',
                      'look_idle'
                    ],
                    title: Text("Simple State Machine"),
                    validate: (){
                      print(email);
                      print(password);
                      Navigator.pop(context);
                    },
                  ),
                ));
              },
              child: Text("Simple State Machine"),
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OneShotAnimationPage(
                    newSetAnimations: boolInputList[
                        getIndex!],
                    initialsSetAnimations: [
                      'idle',
                      'look_idle'
                    ],
                    title: Text("One shot animation"),
                    imageName: "assets/${getValue}.riv",
                    validate: (){
                      print(email);
                      print(password);
                      Navigator.pop(context);
                    },
                    applyPasswordChanges: (value){
                     checkPassword(value);
                    },
                    buttonColor:Colors.green,
                    emailHint: "Enter Email Address",
                    colors: Colors.black,
                    passwordHint: "Enter Password",
                    applyEmailChanges: (value){
                      checkEmail(value);
                    },
                    buttonTitle: "Submit",
                    isAsset:
                        true,
                  ),
                ));
              },
              child: Text("One shot animation"),
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CustomAnimationPage(
                    isAsset:
                        true,
                    imageName: "assets/${getValue}.riv", ///rive file loading
                    stateMachines: stateMachinesList[
                        getIndex!], // state machine from which input values are retriving
                    boolInputList: boolInputList[
                        getIndex!], ///add those bool values which will you use for triggering event on widget actions like button press or textfield change value
                    doubleInputList: doubleInputList.length > 1
                        ? doubleInputList[getIndex!]
                        : doubleInputList[
                            0], //this value used for increment value like eye movement from left to right
                    initialsSetAnimations: [
                      'idle',
                      'look_idle'
                    ], ///initial animations added for showing initials animations when app_page opens
                    buttonColor:Colors.green,
                    applyPasswordChanges: (value){
                      checkPassword(value);
                    },
                    validate: (){
                      print(email);
                      print(password);
                      Navigator.pop(context);
                    },
                    emailHint: "Enter Email Address",
                    colors: Colors.black,
                    passwordHint: "Enter Password",
                    applyEmailChanges: (value){
                      checkEmail(value);
                    },
                    buttonTitle:"Submit",
                    title: Text("Custom Animation"), //title for appbar
                  ),
                ));
              },
              child: Text("Custom Animation"),
            ),
          ],
        ),
      ),
    );
  }

  checkEmail(String? value){
    if(value!.isEmpty){
      return "Email is required";
    }
    else{
      setState(() {
        email=value;
      });
    }
  }

  checkPassword(String? value) {
    if(value!.isEmpty){
      return "Password is required";
    }
    else{
      setState(() {
        password=value;
      });
    }
  }
}
