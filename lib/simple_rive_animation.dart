part of 'animation_wrap_lib.dart';

class CustomAnimationPage extends StatefulWidget {
  final Widget? title;
  final String? imageName;
  final bool? isAsset;
  ///initial inputs loaded from state machine
  final List<String>? initialsSetAnimations;
  ///inputs from state machine used to trigger event on different tap event
  final List<String>? stateMachines;
  ///method used for email validation
  final String? Function(String?)? applyEmailChanges;
  ///method used for password validation
  final String? Function(String?)? applyPasswordChanges;
  ///this will shows list of double input values of selected state machines
  final List<String>? doubleInputList;
  ///this will shows list of boolean input values of selected state machines
  final List<String>? boolInputList;
  final String? passwordHint;
  ///color of border of textfield
  final Color? colors;
  ///this method will called when inputs provided are proper or not
  final Function()? validate;
  final String? emailHint;
  ///color of button
  final Color? buttonColor;
  final String? buttonTitle;

  CustomAnimationPage({
    Key? key,
    this.title,
    this.buttonTitle,
    this.applyEmailChanges,
    this.validate,
    this.buttonColor,
    this.emailHint,
    this.passwordHint,
    this.colors,
    this.stateMachines,
    this.applyPasswordChanges,
    this.doubleInputList,
    this.boolInputList,
    this.imageName,
    this.initialsSetAnimations,
    this.isAsset,
  }) : super(key: key);

  @override
  _CustomAnimationPageState createState() => _CustomAnimationPageState();
}

class _CustomAnimationPageState extends State<CustomAnimationPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  bool autoPlay = false;
  ///artboard is used for load state machines and their inputs
  Artboard? _riveArtboard;
  ///these map varibles can retrive value from rive controller and change its value whenever event triggered
  Map<String, SMIBool>? boolInputValues = {};
  Map<String, SMITrigger>? boolInputValues1 = {};
  Map<String, SMINumber>? doubleInputValues = {};
  List<String>? inputList=[];
  ///textcontrollers for adding text into it
  List<TextEditingController> controller = [
    TextEditingController(text: ""),
    TextEditingController(text: "")
  ];
  ///this controller is used for showing inputs which retrived from rive asset state machine
  ///state machine shows different inputs and layers via tree formation.it starts from entry point and end with exit point
  ///user can add states to the state machine tree and connect to state machine tree
  ///inputs are of boolean,number and trigger.boolean and trigger are return same output but trigger is neccessary input whereas bool is not required in state machine
  ///user can manage multiple layers on single state machine for managing multi tree form animation to the single image
  ///rive controller managed by getx pattern get.put used to register controller if not available
  final RiveController riveController = Get.put(RiveController());

  @override
  void dispose() {
    super.dispose();
    ///textcontrolller will clear its value when page closed
    for (var value in controller) {
      value.clear();
    }
  }

  @override
  void initState() {
   /// TODO: implement initState
    super.initState();

   ///this will load rive image from asset and import its data here
    rootBundle.load(widget.imageName!).then(
      (data) {
       /// Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

       /// The artboard is the root of the animation and gets drawn in the
       /// Rive widget.
        setState(() {
          _riveArtboard = file.mainArtboard;
        });

       ///loop used for initialize double and bool values from state machines to the map which used for change value on widget event trigger
        riveController.initialise(widget.doubleInputList, widget.boolInputList);
       ///here rive init method called insted of calling to build method like other screen
       ///so that to give fast output for fast loading
        riveController.onRiveInit(_riveArtboard!, widget.stateMachines);
        boolInputValues = riveController.boolInputValues;
        boolInputValues1 = riveController.boolInputValues1;
        doubleInputValues = riveController.doubleInputValues;
      },
    );
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
            builder: (refController) {
              return Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Visibility(
                            visible: widget.isAsset!,
                            child: _riveArtboard != null
                                ? Container(
                                    height:
                                        MediaQuery.of(context).size.width / 1.3,
                                   ///this will used for getting output from state machine without using controller via artboard
                                    child: Rive(
                                      artboard: _riveArtboard!,
                                    ))
                                : Container(),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.width / 1.25),
                              child: Column(
                                children: [
                                  TextFormFieldWidget(
                                    radius: 10,
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
                                  const SizedBox(height: 10),
                                  TextFormFieldWidget(
                                    radius: 10,
                                    hintText: widget.passwordHint,
                                    obscureText: true,
                                    controller: controller[1],
                                    borderColor: widget.colors,
                                    onChanged: (value) {
                                     ///this is used if value is not empty then value of input set to true otherwise set to false
                                      if (!value.isEmpty) {
                                        manageHandsUpState(true);
                                        widget.applyPasswordChanges!(value);
                                      } else {
                                        manageHandsUpState(false);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                     ///this is used to reset value to false whenever complete text input and when come 2nd time then
                                     /// it starts from initial position
                                      manageHandsUpState(false);
                                    },
                                    validator: widget.applyPasswordChanges,
                                  ),
                                  const SizedBox(height: 10),
                                  MaterialButton(
                                    color: widget.buttonColor,
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        managingInputStates(true);
                                        ///if input provided are correct then validate method used for future actions
                                        widget.validate!();
                                      } else {
                                        managingInputStates(false);
                                      }
                                    },
                                    child: Text(widget.buttonTitle!),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ));
            }));
  }

  managingInputStates(bool val1) {
   ///managing inputs of success or fail status to true or false based on text input validation
    setState(() {
      boolInputValues1![widget.boolInputList![0]]!.value = val1;
      boolInputValues1![widget.boolInputList![1]]!.value = !val1;
    });
  }

  manageHandsUpState(bool value) {
   ///managing input values true or false based on email and password values triggering
    setState(() {
      if (boolInputValues!.containsKey(widget.boolInputList![2])) {
        boolInputValues![widget.boolInputList![2]]!.value = value;
      } else if (boolInputValues1!.containsKey(widget.boolInputList![2])) {
        boolInputValues1![widget.boolInputList![2]]!.value = value;
      }
    });
  }
}
