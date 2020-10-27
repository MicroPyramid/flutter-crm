import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword();
  @override
  State createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  String _email;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _submitForm() async {
    if (!_forgotPasswordFormKey.currentState.validate()) {
      return;
    }
    _forgotPasswordFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Navigator.pushNamed(context, '/forgot_password_text');
    // await PietrackService().login({
    //   'email': 'jagadeesh.s@micropyramid.com',
    //   'password': '1122'
    // }).then((Response value) {
    //   var res = json.decode(value.body);
    //   print(res);
    //   if (!res['error']) {
    //     NetworkService().token = res['token'];
    //     PietrackService().getCompanies({}).then((Response value) {
    //       var res = json.decode(value.body);
    //       companies.clear();
    //       for (var company in res['data']) {
    //         Company _company = Company.fromJson(company);
    //         companies.add(_company);
    //       }
    //       print(res);
    //       if (res['data'].length > 1) {
    //         Navigator.of(context).pushReplacementNamed('/companies_list');
    //       } else {
    //         NetworkService().companyId = res['data'][0]['id'].toString();
    //         selectedCompany = companies[0];
    //         openProjects.clear();
    //         closedProjects.clear();
    //         PietrackService().getProjects({}).then((Response value) {
    //           var res = json.decode(value.body);
    //           print(res);
    //           for (var project in res['data']) {
    //             Project _project = Project.fromJson(project);
    //             openProjects.add(_project);
    //           }
    //           for (var project in res['inactive']) {
    //             Project _project = Project.fromJson(project);
    //             closedProjects.add(_project);
    //           }
    //           Navigator.of(context).pushReplacementNamed('/projects');
    //         });
    //       }
    //     });
    //   } else {
    //     String _errorMessage = res['errors']['email'] != null
    //         ? res['errors']['email'][0]
    //         : res['errors']['__all__'] != null
    //             ? res['errors']['__all__'][0]
    //             : 'Invalid credentials';
    //     showErrorMessage(context, _errorMessage);
    //   }
    // });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Text('Forgot Password',
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width / 18)),
              ),
              Container(
                child: Form(
                    key: _forgotPasswordFormKey,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(221, 221, 221, 1)),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field is required.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value;
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: RaisedButton(
                              color: Theme.of(context).buttonColor,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (!_isLoading) {
                                  _submitForm();
                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              children: [
                                Container(
                                  child: Text('Already Have An Account? '),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/sub_domain');
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ForgotPasswordText extends StatefulWidget {
  ForgotPasswordText();
  @override
  State createState() => _ForgotPasswordTextState();
}

class _ForgotPasswordTextState extends State<ForgotPasswordText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Container(
            child: Text('Django CRM',
                style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width / 15)),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "We've emailed you instructions for setting your password, if an account exists with the email you entered. You should receive them shortly.",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width / 22),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "If you don't receive an email, please make sure you've entered the address you registered with, and check your spam folder.",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width / 22),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/sub_domain');
              },
              child: Text(
                'Login',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
