import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shutt_app/providers/authProvider.dart';
import 'package:shutt_app/screens/signUp3.dart';
import 'package:shutt_app/styles/colors.dart';
import 'package:shutt_app/widgets/customTextField.dart';
import 'package:shutt_app/widgets/greenButton.dart';
import 'package:shutt_app/widgets/headingText.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app/services/authService.dart';
import 'package:firebase_admin/firebase_admin.dart';

import '../widgets/headingText.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key}) : super(key: key);

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  TextEditingController x = TextEditingController();
  String otpPin = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authHandler = Provider.of<auth.AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back,
              color: appColors.green,
            ),
            onTap: () {
              authHandler.signUpState = 1;
            },
          )),
      body: Consumer<auth.AuthProvider>(
        builder: (context, auth, child) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(
                  //   height: 32,
                  // ),
                  const HeadingText(
                    text: "Enter Code",
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "A verification code was sent to",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: appColors.textGrey),
                  ),
                  Text(
                    "+233 ${auth.phoneNumController.text.substring(0, 2)} ${auth.phoneNumController.text.substring(2, 5)} ${auth.phoneNumController.text.trim().substring(5)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: appColors.darkGreen),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Pinput(
                    length: 6,
                    onCompleted: (pin) => {
                      setState(() {
                        otpPin = pin;
                      })
                    },
                    defaultPinTheme: PinTheme(
                      width: (MediaQuery.of(context).size.width / 6) - 10,
                      height: 48,
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: appColors.green,
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        color: appColors.offWhite,
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Resend code",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: appColors.green),
                  ),
                ],
              )),
              greenButton(
                label: "Next",
                onPressed:() async {
                  if(otpPin!=""){
                    print(auth.phoneNumController.text.trim());
                    User userObj = await context
                        .read<AuthService>()
                        .signInWithPhone(auth.verificationId, otpPin);
                    Provider.of<auth.AuthProvider>(context, listen: false)
                        .setUser(userObj);
                    auth.signUpState = 3;

                    //..........................................................
                    //var admin = FirebaseAdmin.instance.initializeApp();
                    //var number=admin.auth().getUserByPhoneNumber(auth.phoneNumController.text.trim());
                    //if (number!=""){
                    //  auth.signUpState = 3;
                    //}
                    //..........................................................
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
