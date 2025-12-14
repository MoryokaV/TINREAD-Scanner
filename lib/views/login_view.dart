import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinread_rfid_scanner/utils/responsive.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';
import 'package:tinread_rfid_scanner/widgets/custom_checkbox.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // final UserController userController = UserController();

  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();

  bool rememberMe = true;

  void loginUser() async {
    // final username = usernameFieldController.text;
    // final password = passwordFieldController.text;

    print("login");
    // try {
    //   AuthToken authToken = await userController.login(username, password);

    //   if (mounted) await Provider.of<UserProvider>(context, listen: false).setUser(authToken, rememberMe);
    //   if (mounted) Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
    // } on ApiException catch (exception) {
    //   if (mounted) showErrorDialog(context, exception);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 0,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: kBackgroundColor,
              expandedHeight: Responsive.screenWidth * 0.65,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: Responsive.screenWidth,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(top: Responsive.safePaddingTop + 24, bottom: 24),
                  child: SvgPicture.asset("assets/icons/login.svg", fit: BoxFit.contain, height: double.infinity),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(24),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: const SizedBox(height: 24),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: Responsive.screenHeight - Responsive.screenWidth * 0.65),
                child: Container(
                  width: Responsive.screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Autentificare",
                        // AppLocalizations.of(context).signIn,
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 24),
                      ),
                      SizedBox(height: 36),
                      Text(
                        "Utilizator",
                        // AppLocalizations.of(context).username,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 6),
                      UsernameField(
                        controller: usernameFieldController,
                        // hintText: AppLocalizations.of(context).usernameInputHint,
                        hintText: "ionpopescu86",
                      ),
                      SizedBox(height: 12),
                      Text(
                        // AppLocalizations.of(context).password,
                        "Parolă",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 6),
                      PasswordField(controller: passwordFieldController, hintText: "•••••••••••"),

                      SizedBox(height: 24),
                      Row(
                        spacing: 10,
                        children: [
                          CustomCheckbox(
                            value: rememberMe,
                            onChanged: (bool newValue) {
                              setState(() {
                                rememberMe = newValue;
                              });
                            },
                          ),
                          Text(
                            "Ține-mă minte",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(height: 0.9),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.safeBlockVertical * 6),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            // AppLocalizations.of(context).signIn,
                            "Autentificare",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.safeBlockVertical * 4),
                      Center(child: Image.asset("assets/images/ime.png", width: Responsive.screenWidth / 3)),
                      SizedBox(height: Responsive.safePaddingBottom + 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsernameField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const UsernameField({required this.hintText, required this.controller, super.key});

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  FocusNode focusNode = FocusNode();
  late String hintText;

  @override
  void initState() {
    super.initState();

    hintText = widget.hintText;

    focusNode.addListener(() {
      hintText = focusNode.hasFocus ? "" : widget.hintText;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      focusNode: focusNode,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightGrey, width: 1),
        ),
        isDense: true,
        hintText: hintText,
        prefixIcon: Icon(FontAwesomeIcons.solidUser, size: 20),
        prefixIconColor: focusNode.hasFocus ? kPrimaryColor : kDisabledIconColor,
      ),
      onSubmitted: (_) {},
      onEditingComplete: () {},
    );
  }
}

class PasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const PasswordField({required this.hintText, required this.controller, super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  FocusNode focusNode = FocusNode();
  late String hintText;

  @override
  void initState() {
    super.initState();

    hintText = widget.hintText;

    focusNode.addListener(() {
      hintText = focusNode.hasFocus ? "" : widget.hintText;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      focusNode: focusNode,
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightGrey, width: 1),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          icon: FaIcon(_isObscured ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye),
        ),
        isDense: true,
        hintText: hintText,
        prefixIcon: Icon(FontAwesomeIcons.lock, size: 20),
        prefixIconColor: focusNode.hasFocus ? kPrimaryColor : kDisabledIconColor,
      ),
      onSubmitted: (_) {},
      onEditingComplete: () {},
    );
  }
}
