import 'package:beat_box/Blocs/Auth/AuthBloc/autth_bloc.dart';
import 'package:beat_box/AuthScreen/AuthWidget/login_signUpWidget.dart';
import 'package:beat_box/Home/rootPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _startPosition = -20.0;
  double _endPosition = 7.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: _startPosition, end: _endPosition)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  AuthWidget authWidget = AuthWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050A30),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            duration: const Duration(seconds: 3),
          ));
          setState(() {});
        }
        if (state is AuthSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return GestureDetector(
          onTap: () {
            onTapFunction(authWidget.getFocus1, authWidget.getFocus2,
                authWidget.getFocus3);
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child:
                          Image.asset('assets/Images/design proposal (1).png')),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        //width: MediaQuery.of(context).size.width *0.,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Opacity(
                            opacity: _controller.value,
                            child: Transform.translate(
                              offset: Offset(-_animation.value, 0.0),
                              child: Image.asset(
                                  'assets/Images/Welcome to music world ! (1).png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  authWidget
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

void onTapFunction(
    FocusNode focusNode1, FocusNode focusNode2, FocusNode focusNode3) {
  if (focusNode1.hasFocus) {
    focusNode1.unfocus();
  }

  if (focusNode2.hasFocus) {
    focusNode2.unfocus();
  }

  if (focusNode3.hasFocus) {
    focusNode3.unfocus();
  }
}
