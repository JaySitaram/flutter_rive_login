import 'package:get/get.dart';
import 'package:rive/rive.dart';

class RiveController extends GetxController{
  List<String>? doubleInputList;
  List<String>? boolInputList;
  //smibool will used to trigger bool value from input of state machine user have to modify it if needed
  //sminumber will used to trigger int or double value from input of state machine user have to modify it if needed
  //smitrigger and smibool are shows bool output but smibool is of checkbox form and smitrigger is of radiobutton format
  Map<String, SMIBool>? boolInputValues = {};
  Map<String, SMITrigger>? boolInputValues1 = {};
  Map<String, SMINumber>? doubleInputValues = {};

  //rive controller initialize values of input list here for using in rive artboard value manipulation
  //update will change value and notify to its parent
  initialise(var doubleInput,var boolInput){
    doubleInputList=doubleInput;
    boolInputList=boolInput;
    update();
  }

  void onRiveInit(Artboard p1, List<String>? stateMachines) {
    //loop used for initialize double and bool values from state machines to the map which used for change value on widget event trigger
    /// Instance a [StateMachineController] from an [artboard] with the given
    /// [stateMachineName]. Returns the [StateMachineController] or null if no
    /// [StateMachine] with [stateMachineName] is found.
    /// Artboards are the foundation of your composition across both design and animate mode.
    /// They act as the root of every hierarchy and allow you to define the dimensions and background color of a scene.
    /// You can create an infinite amount of artboards on the Stage, but each Rive file has at least one artboard.
    for (var value in stateMachines!) {
      final stateController = StateMachineController.fromArtboard(p1, value);
      p1.addController(stateController!);
      initialiseDoubleInputs(stateController);
      initialiseBoolInputs(stateController);
    }
  }

  initialiseDoubleInputs(var controller) {
      for (var getValue in doubleInputList!) {
        //here controller will check if input value is found on state machine or not if found then it will added values to the list
        if (controller.findInput<double>(getValue) != null) {
          var values = controller.findInput<double>(getValue) as SMINumber;
          doubleInputValues![getValue] = values;
        }
      }
  }

  initialiseBoolInputs(var controller) {
      for (var getValue in boolInputList!) {
        var values;
        //if input value is smibool type then this value will add to smibool list otherwise value added to smitrigger list
        if (controller.findInput<bool>(getValue) is SMIBool) {
          values = controller.findInput<bool>(getValue) as SMIBool;
          boolInputValues![getValue] = values;
        } else {
          values = controller.findInput<bool>(getValue) as SMITrigger;
          boolInputValues1![getValue] = values;
        }
      }
  }
}