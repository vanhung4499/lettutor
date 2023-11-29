import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/presentation/auth/base/auth_mixin.dart';
import 'package:lettutor/presentation/auth/blocs/login/login_bloc.dart';
import 'package:lettutor/presentation/auth/blocs/login/login_state.dart';
import 'package:lettutor/presentation/auth/views/widgets/render_app_bar.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/utils/state_mixins/did_change_dependencies_mixin.dart';
import 'package:lettutor/core/widgets/progress_button.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with
        DidChangeDependencies,
        AuthMixin,
    // DisposableMixin,
        SingleTickerProviderStateMixin<LoginScreen> {
  late TextEditingController _emailController;

  late TextEditingController _passwordController;

  final _passwordFocusNode = FocusNode();

  final ValueNotifier<bool> _obscureText = ValueNotifier(true);

  LoginBloc get _bloc => BlocProvider.of<LoginBloc>(context);

  Object? listenState;

  @override
  void initState() {
    _emailController = TextEditingController(text: 'student@lettutor.com');
    _passwordController = TextEditingController(text: '123456');
    super.initState();
    didChangeDependencies$
        .exhaustMap((_) => _bloc.message$)
        .exhaustMap(handleState)
        .collect();
    // .disposedBy();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onChangeObscureText() {
    _obscureText.value = !_obscureText.value;
  }

  @override
  void didChangeDependencies() {
    ///[Call] when get change value from Provider or parent widget
    super.didChangeDependencies();
    // listenState ??= _bloc.message$.flatMap(handleState).collect();
  }

  Stream<void> handleState(state) async* {
    if (state is LoginSuccessMessage) {
      log("[Login] success");
      await delay(100);
      yield null;
      // ignore: use_build_context_synchronously
      await context.pushAndRemoveAll(Routes.dashboard);
      return;
    }
    if (state is LoginErrorMessage) {
      context.showSnackBar("[Login] error ${state.toString()}");
      return;
    }
    if (state is InvalidFormatMessage) {
      context.showSnackBar("[Login] invalid format message");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: const RenderAppBar(),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Image.asset(
            ImageConstant.loginImage,
            width: double.infinity,
            height: context.heightDevice * 0.25,
          ),
          const SizedBox(height: 20.0),
          Text(
            S.of(context).sayHellToYour,
            textAlign: TextAlign.center,
            style: context.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              S.of(context).becomeFluent,
              style: context.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: _buildEmailWidget(),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
            child: _buildPasswordWidget(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () =>
                      context.openPageWithRoute(Routes.resetPassword),
                  child: Text(
                    S.of(context).forgotPassword,
                    style: context.titleSmall.copyWith(color: primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      context.openPageWithRoute(Routes.register),
                  child: Text(S.of(context).register, style: context.titleSmall),
                )
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_loginButton()],
          ),
          const SizedBox(height: 5.0),
          Text(S.of(context).orContinue,
              textAlign: TextAlign.center, style: context.titleSmall),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...[
                ImageConstant.facebook,
                ImageConstant.google,
              ].mapIndexed(
                    (index, e) => IconButton(
                  onPressed: () {
                    if (index == 1) {
                      _bloc.submitGoogleLogin();
                    }
                  },
                  icon: SvgPicture.asset(e),
                ),
              )
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildPasswordWidget() {
    return StreamBuilder<String?>(
      stream: _bloc.passwordError$,
      builder: (context, snapshot) {
        return ValueListenableBuilder<bool>(
          valueListenable: _obscureText,
          builder: (_, obscureText, __) {
            return TextField(
              obscureText: obscureText,
              controller: _passwordController,
              onChanged: _bloc.passwordChanged,
              autofillHints: const [AutofillHints.password],
              decoration: textFieldDecoration(
                suffixIcon: GestureDetector(
                  onTap: _onChangeObscureText,
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                labelText: S.of(context).password,
                errorText: snapshot.data,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmailWidget() {
    return StreamBuilder<String?>(
      stream: _bloc.emailError$,
      builder: (context, snapshot) {
        return TextField(
          controller: _emailController,
          decoration: textFieldDecoration(
            suffixIcon: const Padding(
              padding: EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(Icons.email),
            ),
            labelText: S.of(context).email,
            errorText: snapshot.data,
          ), // InputDecoration(
          keyboardType: TextInputType.emailAddress,
          maxLines: 1,
          style: const TextStyle(fontSize: 16.0),
          onChanged: _bloc.emailedChanged,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        );
      },
    );
  }

  Widget _loginButton() {
    return ProgressButton(
      call: () async {
        _bloc.submitLogin();
        return true;
      },
      width: 300,
      isAnimation: true,
      textInside: S.of(context).login,
      radius: 10.0,
    );
  }
}
