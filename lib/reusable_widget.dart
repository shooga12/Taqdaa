import 'package:flutter/material.dart';

Image cloudDcrWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 244,
    height: 169.77,
  );
}

TextField reusableTextField(
    String text, bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Color.fromARGB(255, 37, 43, 121),
    style: TextStyle(color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),
    decoration: InputDecoration(
// prefixIcon : Icon(
// icon,
// color: Colors .white70,
// ), // Icon
      labelText: text,
      labelStyle:
          TextStyle(color: Color.fromARGB(236, 113, 113, 117).withOpacity(0.9)),
      filled: true,

      fillColor: Colors.white.withOpacity(0.9),
      // border: OutlineInputBorder(
      //  borderRadius: BorderRadius.circular(30.0),),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 15, 53, 120), width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Colors.orange, width: 2.0),
      ),
    ),

// OutlineInput Border

    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container ReusableButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey;
            }
            return Colors.orange;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}
