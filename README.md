# flutter_rive_login

Flutter Plugin for applying login animation with rive file of .riv format.
this used only when inputs of state machines are success,fail and hand_up values or any of them.
this plugin will updated based on different input types found for login animation via rive website.

## Preview of flutter_rive_login
https://github.com/jaymahaab/flutter_rive_login/blob/main/example/assets/demonstration.gif

## 🚀 Installation
This plugin is available on Pub: https://pub.dev/packages/flutter_rive_login
Add this to dependencies in your app's pubspec.yaml
flutter_rive_login : latest_version

## Used Packages in this plugin
rive: latest_version
get: latest_version

<br>
## Available Features
:check:   Eye movement change when textform value  changes </br>
:check:   When Input are valid then success status otherwise fail status shows</br>
:check:   Load different rive asset and its inputs from state machine</br>
:check:   Implemented oneshot rive animation,rive state machine animation & import asset rive content to artboard</br>
<br>
<br>

## :bookmark: Usage
Here boolinputList shows input values of state machines which user will use to retrive boolean output if rive asset file
triggered this boolean value as true or not.and doubleinputlist shows input values of state machines which user will use to
retrive double output.the double value can be changed by package and actual animation shows to the user.if inputs are empty
then animation will not trigger.initialsSetAnimations will load initial animations when page opens.

Sample code to integrate can be found in example/lib/main.dart.

For further information about rive components,resources and community visit https://rive.app/.

## Use of flutter_rive_login
       StateMachineTriggerAnimation(
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
                      Navigator.pop(context);
                    },
                  ),
                 ),

## ❤️ Found this project useful?
If you found this project useful, then please consider giving it a ⭐ on Github and sharing it with your friends via social media.
=======
**** ## :🪄: Contributing, :disappointed: Issues and :bug: Bug Reports >>>>>>> 8deb8d8fd1809d7a6a317c1ab8975edeb54d8d75 The project is open to public contribution. Please feel very free to contribute. Experienced an issue or want to report a bug? Please, [report it here](https://github.com/jaymahaab/flutter_rive_login/issues). Remember to be as descriptive as possible.

<br>

## :🪄: Contributing, :disappointed: Issues and :bug: Bug Reports

8deb8d8fd1809d7a6a317c1ab8975edeb54d8d75
The project is open to public contribution. Please feel very free to contribute.
Experienced an issue or want to report a bug? Please, report it here. Remember to be as descriptive as possible.