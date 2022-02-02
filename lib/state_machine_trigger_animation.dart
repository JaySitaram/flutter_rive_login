part of 'animation_wrap_lib.dart';

class StateMachineTriggerAnimation extends StatefulWidget {
  Widget? title;
  String? imageName;
  bool? isAsset;
  //initial inputs loaded from state machine
  List<String>? initialsSetAnimations;
 ///inputs from state machine used to trigger event on different tap event
  List<String>? stateMachines;
  //method used for email validation
  String? Function(String?)? applyEmailChanges;
 ///method used for password validation
  String? Function(String?)? applyPasswordChanges;
  //this will shows list of double input values of selected state machines
  List<String>? doubleInputList;
 ///this will shows list of boolean input values of selected state machines
  List<String>? boolInputList;
  String? passwordHint;
  //color of border of textfield,color of button
  Color? colors,buttonColor;
  String? buttonTitle;
 ///this method will called when inputs provided are proper or not
  Function()? validate;
  String? emailHint;

  StateMachineTriggerAnimation({
    Key? key,
    this.title,
    this.applyEmailChanges,
    this.validate,
    this.emailHint,
    this.passwordHint,
    this.colors,
    this.buttonColor,
    this.stateMachines,
    this.buttonTitle,
    this.applyPasswordChanges,
    this.doubleInputList,
    this.boolInputList,
    this.imageName,
    this.initialsSetAnimations,
    this.isAsset,
  }) : super(key: key);

  @override
  _StateMachineTriggerAnimationState createState() =>
      _StateMachineTriggerAnimationState();
}

class _StateMachineTriggerAnimationState
    extends State<StateMachineTriggerAnimation> {
  bool autoPlay = false;

  GlobalKey<FormState> formKey = GlobalKey();
  ///these map varibles can retrive value from rive controller and change its value whenever event triggered
  Map<String, SMIBool>? boolInputValues = {};
  Map<String, SMITrigger>? boolInputValues1 = {};
  Map<String, SMINumber>? doubleInputValues = {};
  ///textcontrollers for adding text into it
  List<TextEditingController> controller = [
    TextEditingController(text: ""),
    TextEditingController(text: "")
  ];
  List<String>? inputList=[];
  int counter=0;

  RiveController riveController=Get.put(RiveController());

  @override
  void initState() {
    super.initState();
    riveController.initialise(widget.doubleInputList, widget.boolInputList);
    boolInputValues = riveController.boolInputValues;
    boolInputValues1 = riveController.boolInputValues1;
    doubleInputValues = riveController.doubleInputValues;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
      ),
      ///get builder will trigger getxcontroller method and its values which updated
     ///init will show controller instance here we used rive controller
      body: GetBuilder<RiveController>(
        init: riveController,
        builder: (refController){
          return Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width/1.3,
                        child: widget.isAsset!
                            ? RiveAnimation.asset(
                          widget.imageName!,
                          animations: widget.initialsSetAnimations!,
                          stateMachines: widget.stateMachines!,
                          onInit: (p1)=>riveController.onRiveInit(p1,widget.stateMachines),
                        ) : RiveAnimation.network(
                          widget.imageName!,
                          animations: widget.initialsSetAnimations!,
                          stateMachines: widget.stateMachines!,
                          onInit: (p1)=>riveController.onRiveInit(p1,widget.stateMachines),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/1.25),
                        child: Column(
                          children: [
                            TextFormFieldWidget(
                              radius: 10.0,
                              hintText: widget.emailHint,
                              obscureText: false,
                              controller: controller[0],
                              borderColor: widget.colors,
                              onChanged: (input) {
                                inputList!.add(input);
                                for (var currentValue in widget.doubleInputList!) {
                                  if (doubleInputValues!.containsKey(
                                      currentValue) && inputList!.last.length >
                                      inputList![inputList!.length - 2]
                                          .length) {
                                    doubleInputValues![currentValue]!.value +=
                                        input.length / 8;
                                  }
                                  else {
                                    doubleInputValues![currentValue]!.value -=
                                        input.length / 18;
                                  }
                                }

                              },
                              validator: widget.applyEmailChanges,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormFieldWidget(
                              radius: 10.0,
                              hintText: widget.passwordHint,
                             ///this property used for hiding password
                              obscureText: true,
                              controller: controller[1],
                              borderColor: widget.colors,
                              validator: widget.applyPasswordChanges,
                              onChanged: (value) {
                               ///this is used if value is not empty then value of input set to true otherwise set to false
                                if (!value.isEmpty) {
                                  manageHandsUp(true);
                                } else {
                                  manageHandsUp(false);
                                }
                              },
                              onFieldSubmitted: (value) {
                               ///this is used to reset value to false whenever complete text input and when come 2nd time then it starts from initial position
                                manageHandsUp(false);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              color: widget.buttonColor,
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                 ///if input provided are correct then validate method used for future actions
                                  widget.validate!();
                                  manageInput(true);
                                } else {
                                  manageInput(false);
                                }
                              },
                              child: Text(widget.buttonTitle!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
              ),
          );
        },
      ),
    );
  }

  manageInput(bool val1) {
   ///managing inputs of success or fail status to true or false based on text input validation
   setState(() {
        boolInputValues1![widget.boolInputList![0]]!.value = val1;
        boolInputValues1![widget.boolInputList![1]]!.value = !val1;
      });
  }

  manageHandsUp(bool value) {
   /// managing input values true or false based on email and password values triggering
   ///if value of boolInputList contains in boolInputValues of smibool type then its value set to true or false
   /// otherwise smitrigger value will set to true or false
    setState(() {
      if (widget.boolInputList!.length > 2) {
        for(int i=2;i<widget.boolInputList!.length;i++){
          if (boolInputValues!.containsKey(widget.boolInputList![i])) {
            boolInputValues![widget.boolInputList![i]]!.value = value;
          } else if (boolInputValues1!.containsKey(widget.boolInputList![i])) {
            boolInputValues1![widget.boolInputList![i]]!.value = value;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    ///all controller values are set to empty when screen closes
    for (var value in controller) {
      value.clear();
    }
  }
}
