import 'package:flutter/material.dart';
import 'package:jkstore/models/user_model.dart';
import 'package:jkstore/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Criar conta",
              style: TextStyle(
                fontSize: 15
              ),
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignupScreen())
              );
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(child: CircularProgressIndicator());

          return Form(
            key: _formKey,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(),
                ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Icon(
                      Icons.store_mall_directory,
                      color: Theme.of(context).primaryColor,
                      size: 160,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty || !text.contains("@")) {
                          return "E-mail inválido";
                        }
                        return "";
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 5) {
                          return "Senha inválida";
                        } else {
                          return "";
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty){
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Insira seu e-mail para recuperar a senha"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }else{
                            model.recoverPass(_emailController.text);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Um e-mail de recuperação de senha foi enviado"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                        },
                        child: Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {

                          }
                          model.signIn(
                            email: _emailController.text,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFailure: _onFailure
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFailure(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao tentar logar"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
