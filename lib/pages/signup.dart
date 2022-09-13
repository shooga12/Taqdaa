// ignore_for_file: non_constant_identifier_names
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController dataofbirthController = TextEditingController();

Image cloudDcrWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 244,
    height: 169.77,
  );
}

// ignore: must_be_immutable
class Signup extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var obscureText;


   Signup({super.key}); // it was (const Signup({super.key});)
  
 
 String? validatePasswordnewMethod;

 
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var column = Column(
              children: <Widget>[
                cloudDcrWidget("pages/images/photo.png"),
                const SizedBox(
                  height: 36,
                ),
                Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: firstnameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'First Name',
                  labelStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.orange,
            )
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: lastnameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Last Name',
                  labelStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.orange,
            )
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                  labelStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.orange,
            )
                ),
              ),
            ),

            TextFormField(
              key: const ValueKey('Email'),
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              enableSuggestions: false,
              validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
              return 'Please enter a valid email address.';
              }
              return null;
              },
              keyboardType: TextInputType.emailAddress,
             )


             Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,    // make sure to if i could put (hidepass) insted of true
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                  labelStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.orange,
            )
                ),
              ),
            ),
            
            obscureText:hidepassword
             
            

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: phonenumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Phone Number',
                  labelStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.orange,
           ) 
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: dataofbirthController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Birth: 01  01  1997',
                  labelStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.orange,
            )
                ),
              ),
            ),
/*
            decoration: InputDecoration(
            border: InputBorder.none,
            labelText: "Birth  01  01  1997",
            labelStyle: TextStyle(
              fontSize: 20,
              color: Colors.white70,
            )
          ),
*/

            final _radio_colume_container = Container(
margin: const EdgeInsets.fromLTRB(50, 15, 50, 00),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
 fillColor: MaterialStateColor.resolveWith((states) => Colors.orange),
children: <Widget>[
  Text(
    'Gender',  
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      add_radio_button(0, 'Male'), 
      add_radio_button(1, 'Female'),
    ],
  ),
],
),
);
          

            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: ElevatedButton(
                  child: const Text('Sign up'),
                  onPressed: () {
                     print( firstnameController.text); 
                     print( lastnameController.text); 
                     print(emailController.text).trim(); 
                     print(passwordController.text).hidepassword();  //make sure of the hidepassword()
                     print( phonenumberController.text); 
                     print( dataofbirthController.text); 
                  },
                )
            ),

                
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
    );
    }
/*
    return Scaffold(
      body: Container(
        child: pranthises(context, column);      
  }

  get finalRB => Signup; // make sure of this getter ans signup class

  SingleChildScrollView pranthises(BuildContext context, Column column) {
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
             20, MediaQuery.of(context).size.height * 0.1, 20, MediaQuery.of(context).size.height * 0.05),
          child: column,

)
        );

 */

   get hidepass => obscureText;  // if it's comment or not nothing change

  Radiobutton() async {
    return ;
  }

/*r'^
  (?=.*[A-Z])       // should contain at least one upper case
  (?=.*[a-z])       // should contain at least one lower case
  (?=.*?[0-9])      // should contain at least one digit
  (?=.*?[!@#\$&*~]) // should contain at least one Special character
  .{8,}             // Must be at least 8 characters in length  
$
*/

  passval(String value) {
         RegExp regex =
         RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (value.isEmpty) {
         return 'Please enter password';
         } else {
        if (!regex.hasMatch(value)) {
         return 'Enter valid password';
        } else {
        return null;
      }
    }
   }
}


/*
Image logoWidget(String imageName) (
return Image.asset(
  imageName,
  fit: Boxfit.fitWidth,
  width: 200,
  height: 200,
  colors: colors.white,
);
)
*/

 /*
 class MyStatefulWidget extends StatefulWidget {
const MyStatefulWidget({Key? key}) : super(key: key);
 
@override
State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}
 
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
TextEditingController firstnameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController phonenumberController = TextEditingController();
TextEditingController dataofbirthController = TextEditingController();
*/

 /*
@override
Widget build(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign up',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
              
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last Name',
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),

          TextFormField(
            key: ValueKey('Email'),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            enableSuggestions: false,
            validator: (value) {
            if (value.isEmpty || !value.contains('@')) {
            return 'Please enter a valid email address.';
            }
            return null;
            },
            keyboardType: TextInputType.emailAddress,
           )

          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),

          TextFormField(
            key: ValueKey('password'),
           validator: (value) {
           if (value.isEmpty || value.length < 7) {
           return 'Password must be at least 7 characters long.';
           }
             return null;
           },
           obscureText: hidePassword,
          )

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date Of Birth',
              ),
            ),
          ),

          final _radio_colume_container = Container(
margin: const EdgeInsets.fromLTRB(50, 15, 50, 00),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
Text(
  'Gender',
),
Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: <Widget>[
    add_radio_button(0, 'Male'), 
    add_radio_button(1, 'Female'),
  ],
),
],
),
);
        
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Sign up'),
                onPressed: () {
                   print( firstnameController.text); 
                   print( lastnameController.text); 
                    print(emailController.text).trim(); 
                    print(passwordController.text); 
                   print( phonenumberController.text); 
                   print( dataofbirthController.text); 
                },
              )
          ),
          
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        
      );
}
}
*/
