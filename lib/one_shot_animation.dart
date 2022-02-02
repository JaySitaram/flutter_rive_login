part of 'animation_wrap_lib.dart';

class OneShotAnimationPage extends StatefulWidget {
  ///title of screeen user specify in appbar
  Widget? title;
  String? imageName;
  ///image is asset or not this will specify by user in example file
  bool? isAsset;
  //initial inputs loaded from state machine
  List<String>? initialsSetAnimations;
  ///inputs from state machine used to trigger event on different event like button press or keyboard focus change
  List<String>? newSetAnimations;
  String? emailHint;
  String? passwordHint;
  ///this method used for validation of password if password is valid or not
  String? Function(String?)? applyPasswordChanges;
  ///this method used for validation of email if email is valid or not
  String? Function(String?)? applyEmailChanges;
  ///this method will trigger if inputs are valid or not
  Function()? validate;

  ///text field border color and button color
  Color? colors, buttonColor;

  ///title of button user have to specify
  String? buttonTitle;

  OneShotAnimationPage(
      {Key? key,
      this.title,
      this.colors,
      this.validate,
      this.applyPasswordChanges,
      this.applyEmailChanges,
      this.buttonTitle,
      this.imageName,
      this.emailHint,
      this.passwordHint,
      this.buttonColor,
      this.initialsSetAnimations,
      this.newSetAnimations,
      this.isAsset})
      : super(key: key);

  @override
  _OneShotAnimationPageState createState() => _OneShotAnimationPageState();
}

class _OneShotAnimationPageState extends State<OneShotAnimationPage> {
  bool autoPlay = false;
  GlobalKey<FormState> formKey = GlobalKey();
  ///rive animation controller list used for manage different type of animations of input of state machine
  List<RiveAnimationController>? animController = [];
  //this is controller list where email and password values store
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
  RiveController riveController = Get.put(RiveController());

  @override
  void initState() {
    super.initState();
    /// newSetAnimation list is set of animations which user apply on different widget trigger event like button press or text focus change
    /// animcontroller is list of rive animation controller which used in rive image for manage animation for multiple rive input state
    /// this will used in rive asset or network as controller to load animations to rive
    /// onstart and onstop will used for restarting or not animation
    for (int i = 0; i < widget.newSetAnimations!.length; i++) {
      animController!.add(OneShotAnimation(
        widget.newSetAnimations![i],
        autoplay: false,
        onStart: () => setState(() => autoPlay = true),
        onStop: () => setState(() => autoPlay = false),
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    ///all controllers are set to empty whenever screen closes
    for (var value in controller) {
      value.clear();
    }
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:  SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 1.3,
                      ///if image is asset then rive animation asset will load otherwise rive animation network will load
                      child: widget.isAsset!
                          ? RiveAnimation.asset(
                              widget.imageName!,
                        controllers: animController!,
                              animations: widget.initialsSetAnimations!,
                            )
                          : RiveAnimation.network(
                              widget.imageName!,
                        controllers: animController!,
                              animations: widget.initialsSetAnimations!,
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/1.25),
                      child: Column(
                        children: [
                          TextFormFieldWidget(
                            radius: 10,
                            hintText: widget.emailHint,
                            obscureText: false,
                            controller: controller[0],
                            borderColor: widget.colors,
                            onChanged: (value) {},
                            validator: widget.applyEmailChanges,
                          ),
                          const SizedBox(height: 10),
                          TextFormFieldWidget(
                            radius: 10,
                            hintText: widget.passwordHint,
                            obscureText: true,
                            controller: controller[1],
                            borderColor: widget.colors,
                            onChanged: (value) {},
                            validator: widget.applyPasswordChanges,
                          ),
                          const SizedBox(height: 10),
                          MaterialButton(
                            color: widget.buttonColor,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              setState(() {
                                ///if form will valid then validate method will perform action
                                ///getreference method will trigger animation of success in case of validate otherwise failing
                                /// animation state will trigger
                                ///checking if newsetanimation list values can match success or fail value
                                ///if match then rive controller will activate and start animation of specified input
                                if (formKey.currentState!.validate()) {
                                  widget.validate!();
                                  animController![0].isActive = true;
                                } else {
                                  animController![1].isActive = true;
                                }
                              });
                            },
                            child: Text(widget.buttonTitle!),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            );
          }),
    );
  }
}