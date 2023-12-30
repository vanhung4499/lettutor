import 'package:flutter/material.dart';

import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/progress_button.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/presentation/auth/base/auth_mixin.dart';
import 'package:lettutor/presentation/auth/blocs/register/register_state.dart';
import 'package:lettutor/presentation/auth/views/widgets/render_app_bar.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/register/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with AuthMixin {
  RegisterBloc get _bloc => BlocProvider.of<RegisterBloc>(context);

  Object? listen;

  late TextEditingController _emailController;

  late TextEditingController _passwordController;

  late TextEditingController _rePasswordController;

  final ValueNotifier<bool> _obscureText = ValueNotifier(true);

  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'student@lettutor.com');
    _passwordController = TextEditingController(text: '123456');
    _rePasswordController = TextEditingController();
    listen ??= _bloc.state$.flatMap(handleState).collect();
  }

  void _onChangeObscureText() {
    _obscureText.value = !_obscureText.value;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  Stream handleState(RegisterState state) async* {
    if (state is RegisterSuccess) {
      context
          .showSnackBar("🌟[Register] register success please verify account");
      return;
    }
    if (state is RegisterError) {
      context.showSnackBar("🐛[Register error] ${state.message}");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        title: const RenderAppBar(),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Image.asset(
            ImageConstant.loginImage,
            height: context.heightDevice * 0.25,
            width: double.infinity,
          ),
          const SizedBox(height: 20.0),
          Text(
            S.of(context).startLearning,
            textAlign: TextAlign.center,
            style: context.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              S.of(context).becomeFluent,
              style: context.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15.0),
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
                      context.backToPageWithRoute(Routes.login),
                  child: Text(S.of(context).login, style: context.titleSmall),
                )
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildRegisterButton()],
          ),
        ],
      ),
    );
  }

  // Widget _rePasswordField() {}

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
          onChanged: _bloc.emailChanged,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return ProgressButton(
      call: () async {
        _bloc.submitRegister();
        return true;
      },
      width: 300,
      isAnimation: true,
      textInside: S.of(context).register,
      radius: 10.0,
    );
  }
}
