import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/user_model.dart';
import 'package:fly_ads_demo1/screens/dashboard/dashboard_screen.dart';
import 'package:fly_ads_demo1/utils/auth_helper.dart';
import 'package:fly_ads_demo1/utils/constants.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onSignInPressed;

  const SignUp({Key? key, required this.onSignInPressed}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpKey = GlobalKey<FormState>();

  UserModel userModel = UserModel(email: '', password: '');

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _signUpKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Register',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),

            // name
            TextFormField(
              // initialValue: 'Input text',
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: appPrimaryColor.shade900),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (val) {
                userModel.userName = val;
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // email
            TextFormField(
              // initialValue: 'Input text',
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: appPrimaryColor.shade900),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (val) {
                userModel.email = val ?? '';
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // password
            TextFormField(
              // initialValue: 'Input text',
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Password*',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              obscureText: _obscureText,
              onSaved: (val) {
                userModel.password = val ?? '';
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // pan
            TextFormField(
              // initialValue: 'Input text',
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'PAN (optional)',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: appPrimaryColor.shade900),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
              validator: (value) {
                // if (value!.isEmpty) {
                //   return 'Please enter some text';
                // }
                return null;
              },
              onSaved: (val) {
                userModel.pan = val;
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // GSTIN
            TextFormField(
              // initialValue: 'Input text',
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'GSTIN (optional)',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: appPrimaryColor.shade900),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
              validator: (value) {
                // if (value!.isEmpty) {
                //   return 'Please enter some text';
                // }
                return null;
              },
              onSaved: (val) {
                userModel.gstin = val;
              },
            ),

            const SizedBox(
              height: 20,
            ),

            // Company/Organization Name
            TextFormField(
              // initialValue: 'Input text',
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Company/Organization Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: appPrimaryColor.shade900),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (val) {
                userModel.orgName = val;
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                // Respond to button press

                if (_signUpKey.currentState!.validate()) {
                  _signUpKey.currentState!.save();

                  if (userModel.email.isEmpty || userModel.password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Enter Proper Email/Password')));
                    return;
                  }

                  AuthenticationHelper()
                      .signUp(userModel: userModel)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)))),
              child: Text(
                'Register',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            TextButton(
                onPressed: widget.onSignInPressed,
                child: Text(
                  'Already have an account?\nLogin here',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.black.withOpacity(0.8)),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }
}
