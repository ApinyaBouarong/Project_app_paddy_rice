import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:paddy_rice/constants/color.dart';
import 'package:paddy_rice/widgets/CustomButton.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@RoutePage()
class OtpRoute extends StatelessWidget {
  final String inputType;
  final String inputValue;

  const OtpRoute({
    Key? key,
    required this.inputType,
    required this.inputValue,
  }) : super(key: key);

  Future<void> resendOtp(BuildContext context) async {
    final String apiUrl =
        'http://10.0.2.2:3000/resend_otp'; // Adjust URL as needed
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contact': inputValue, 'type': inputType}),
      );

      if (response.statusCode == 200) {
        print("OTP resent successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP resent successfully.')),
        );
      } else {
        print("Failed to resend OTP. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend OTP.')),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while resending OTP.')),
      );
    }
  }

  Future<void> verifyOtp(BuildContext context, String otp) async {
    final String apiUrl =
        'http://10.0.2.2:3000/verify_otp'; // Adjust URL as needed
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'otp': otp, 'contact': inputValue, 'type': inputType}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verified successfully.')),
        );
        context.router.replaceNamed('/change_password');
      } else {
        print("Failed to verify OTP. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP.')),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while verifying OTP.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _pinController = TextEditingController();
    String contactInfo = inputType == 'phone' ? inputValue : inputValue;

    return Scaffold(
      backgroundColor: maincolor,
      appBar: AppBar(
        backgroundColor: maincolor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconcolor),
          onPressed: () => context.router.replaceNamed('/forgot'),
        ),
        title: Text(
          "OTP Verification",
          style: TextStyle(
            color: fontcolor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to start
          children: [
            Center(
              child: Icon(
                inputType == 'phone' ? Icons.phone : Icons.email,
                size: 100,
                color: iconcolor,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Please enter the 6 digit verification code sent to $contactInfo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fontcolor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _pinController,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.white,
                selectedColor: iconcolor,
                inactiveColor: Colors.grey,
                activeFillColor: fill_color,
                selectedFillColor: fill_color,
                inactiveFillColor: fill_color,
              ),
              keyboardType: TextInputType.number,
              boxShadows: [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
              onChanged: (value) {},
              enableActiveFill: true,
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () async {
                  await resendOtp(context);
                },
                child: Text(
                  "Didn't receive the OTP? Resend code",
                  style: TextStyle(
                    color: unnecessary_colors,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: CustomButton(
                text: "VERIFY AND PROCEED",
                onPressed: () async {
                  await verifyOtp(context, _pinController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
