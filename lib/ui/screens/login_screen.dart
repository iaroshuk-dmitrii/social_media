import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/business_logic/login_cubit.dart';
import 'package:social_media/ui/constants.dart';
import 'package:social_media/ui/navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushNamedAndRemoveUntil(Screens.mainTabs, (Route<dynamic> route) => false);
        }
        if (state.status == LoginStatus.error) {
          final String errorMessage = state.error;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(errorMessage),
                );
              });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.lightBlue,
                Colors.indigo,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 47, horizontal: 25),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(height: 50),
                    const _EmailInput(),
                    const _PasswordInput(),
                    const SizedBox(height: 40),
                    const _LoginButton(),
                    const _SwitchSign(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        labelStyle: TextStyle(fontSize: 17),
      ),
      style: const TextStyle(fontSize: 17),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
        labelText: 'Пароль',
        labelStyle: TextStyle(fontSize: 17),
      ),
      style: const TextStyle(fontSize: 17),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      final String buttonTitle = state.loginType == LoginType.login ? 'Войти' : 'Регистрация';
      final bool loading = state.status == LoginStatus.inProgress;
      return ElevatedButton(
        onPressed: () {
          state.loginType == LoginType.login ? context.read<LoginCubit>().login() : context.read<LoginCubit>().signUp();
        },
        style: whiteButtonStyle,
        child: Center(child: Text(buttonTitle)),
      );
    });
  }
}

class _SwitchSign extends StatelessWidget {
  const _SwitchSign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      final String text = state.loginType == LoginType.login ? 'Ещё нет аккаунта? ' : 'Уже есть аккаунт? ';
      final String buttonText = state.loginType == LoginType.login ? 'Регистрация' : 'Войти';
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
          TextButton(
            child: Text(
              buttonText,
            ),
            onPressed: () {
              state.loginType == LoginType.login
                  ? context.read<LoginCubit>().switchToSignUp()
                  : context.read<LoginCubit>().switchToLogin();
            },
          ),
        ],
      );
    });
  }
}
