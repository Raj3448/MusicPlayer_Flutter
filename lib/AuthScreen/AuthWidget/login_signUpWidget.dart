import 'dart:io';
import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPathProvider;

class AuthWidget extends StatefulWidget {
  AuthWidget._empty({super.key});

  static AuthWidget? _singleInstance;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();
  get getFocus1 => emailFocusNode;
  get getFocus2 => passwordFocusNode;
  get getFocus3 => userNameFocusNode;

  factory AuthWidget() {
    _singleInstance ??= AuthWidget._empty();
    return _singleInstance!;
  }
  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool _isObscured = true;
  String? email;
  String? password;
  String? userName = '';
  File? _storedImage;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _submit(BuildContext context) async {
    if (_storedImage == null && (!_isLogin)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('please select image'),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    if (!(_globalKey.currentState!.validate())) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    _globalKey.currentState!.save();

    context.read<AuthBloc>().add(AuthLoginRequested(
        username: userName,
        email: email!,
        password: password!,
        isLogin: _isLogin,
        context: context,
        storedImage: _storedImage));
    setState(() {
      _isLoading = false;
    });

    debugPrint(email);
    debugPrint(password);
    debugPrint(userName);
  }

  Future<void> _getDirectory(XFile receivedImage) async {
    final appDirectory =
        await sysPathProvider.getApplicationDocumentsDirectory();
    final imageFile = File(receivedImage.path);
    final fileName = path.basename(imageFile.path);
    final storageResponse =
        await imageFile.copy('${appDirectory.path}/$fileName');

    print("Image Added Succesfully at :- $storageResponse");
  }

  Future<void> _takeImage() async {
    final XFile? receivedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (receivedImage == null) {
      return;
    }
    setState(() {
      _storedImage = File(receivedImage.path);
    });

    _getDirectory(receivedImage);
  }

  Future<void> _selectImage() async {
    final XFile? receivedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);

    if (receivedImage == null) {
      return;
    }
    setState(() {
      _storedImage = File(receivedImage.path);
    });

    _getDirectory(receivedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
            key: _globalKey,
            child: Column(
              children: [
                if (!_isLogin)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: _storedImage != null
                              ? MediaQuery.of(context).size.height * 0.13
                              : MediaQuery.of(context).size.height * 0.11,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 22, 157, 174)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _storedImage == null
                                  ? Image.asset(
                                      'assets/Images/music-lover.png',
                                    )
                                  : Image.file(_storedImage!),
                            ),
                          ),
                        ),
                      ),
                      // CircleAvatar(
                      //     radius: 50,
                      //     backgroundImage: _storedImage == null
                      //         ? null
                      //         : FileImage(
                      //             _storedImage!,
                      //           ),
                      //     backgroundColor:
                      //         _storedImage == null ? Colors.deepOrange : null),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 2.0),
                        child: DropdownButton(
                            underline: const Text(
                              'Upload Image',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'Take Image',
                                child: Container(
                                  child: const Row(
                                    children: [
                                      Icon(Icons.exit_to_app),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('Take Image'),
                                    ],
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Choose Gallery',
                                child: Container(
                                  child: const Row(
                                    children: [
                                      Icon(Icons.exit_to_app),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text('Choose Gallery'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                            onChanged: (identifier) {
                              if (identifier == 'Take Image') {
                                _takeImage();
                              }
                              if (identifier == 'Choose Gallery') {
                                _selectImage();
                              }
                            }),
                      )
                    ],
                  ),
                if (!_isLogin)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      key: const ValueKey('username'),
                      focusNode: widget.userNameFocusNode,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter username';
                        }

                        return null;
                      },
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        label: const Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      onSaved: (value) {
                        userName = value;
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    key: const ValueKey('email'),
                    focusNode: widget.emailFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      label: const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    key: const ValueKey('password'),
                    focusNode: widget.passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    obscureText: _isObscured,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 7) {
                        return 'Please enter a valid password with at least 7 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: 'Password',
                      labelStyle:
                          const TextStyle(color: Colors.white, fontSize: 18),
                      focusColor: Colors.white,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                        icon: Icon(
                          !_isObscured
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                  const Size(250, 50),
                ),
                backgroundColor: MaterialStateProperty.all(
                    const Color(0xff334155)) // Set the size here
                ),
            onPressed: _isLoading
                ? null
                : () async {
                    await _submit(context);
                  },
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 5.0,
                      backgroundColor: Colors.grey,
                    ),
                  )
                : Text(
                    _isLogin ? 'Log In' : 'Create Account',
                    style: const TextStyle(color: Colors.white),
                  )),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLogin ? 'Don\'t have account?' : 'Already have an account?',
              style: const TextStyle(color: Colors.white38),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _storedImage = null;
                  });
                },
                child: Text(
                  _isLogin ? 'Create Now' : 'Login',
                  style: const TextStyle(color: Colors.white),
                ))
          ],
        )
      ],
    );
  }
}
