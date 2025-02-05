import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  get authManager => null;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordLoginTextController ??= TextEditingController();
    _model.passwordLoginFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 8),
                    child: Text(
                      'Login',
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily: 'Outfit',
                            color: Color(0xFF0F1113),
                            fontSize: 32,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 24),
                          child: Text(
                            'Access your account by logging in below.',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF797979),
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                    child: TextFormField(
                      controller: _model.emailAddressTextController,
                      focusNode: _model.emailAddressFocusNode,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        labelStyle:
                            FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                        hintText: 'Enter your email...',
                        hintStyle:
                            FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).secondary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: Color(0xFF0F1113),
                            fontSize: 14,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _model.emailAddressTextControllerValidator
                          .asValidator(context),
                    ),
                  ),
                  TextFormField(
                    controller: _model.passwordLoginTextController,
                    focusNode: _model.passwordLoginFocusNode,
                    obscureText: !_model.passwordLoginVisibility,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Outfit',
                                color: Color(0xFF57636C),
                                fontSize: 14,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                              ),
                      hintText: 'Enter your password...',
                      hintStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF57636C),
                                fontSize: 14,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).secondary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      suffixIcon: InkWell(
                        onTap: () => (
                          () => _model.passwordLoginVisibility =
                              !_model.passwordLoginVisibility,
                        ),
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.passwordLoginVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xFF57636C),
                          size: 22,
                        ),
                      ),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Outfit',
                          color: Color(0xFF0F1113),
                          fontSize: 14,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                    validator: _model.passwordLoginTextControllerValidator
                        .asValidator(context),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child:
                      onPressed: () async {
                        final user = await authManager.signInWithEmail(
                          context,
                          _model.emailAddressTextController.text,
                          _model.passwordLoginTextController.text,
                        );
                        if (user == null) {
                          return;
                        }

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuPageWidget(),
                          ),
                          (r) => false,
                        );
                      },
                      text: 'Login',
                      options:(
                        width: double.infinity,
                        height: 50,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 20,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                            ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                  
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: 
                      onPressed: () async {
                        final user =
                            await authManager.signInAnonymously(context);
                        if (user == null) {
                          return;
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuPageWidget(),
                          ),
                          (r) => false,
                        );
                      },
                      text: 'Anonymous Login',
                      icon: Icon(
                        Icons.person_sharp,
                        color: Color(0xFF0E9134),
                        size: 15,
                      ),
                      options: (
                        width: double.infinity,
                        height: 50,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0x00F1F4F8),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF0E9134),
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).secondary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child:
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountPageWidget(),
                          ),
                        );
                      },
                      text: 'Create account',
                      options: (
                        width: double.infinity,
                        height: 50,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: Color(0x00F1F4F8),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF57636C),
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void LoginPageModel() {}
}

createModel(BuildContext context, void Function() param1) {
}

class MenuPageWidget {
}

class CreateAccountPageWidget {
}

class FlutterFlowTheme {
  static of(BuildContext context) {}
}
