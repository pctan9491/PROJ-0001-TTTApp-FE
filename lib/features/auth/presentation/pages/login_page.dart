import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/app_config.dart';
import '../../../experimental/presentation/pages/experimental.dart';
import '../../../home/presentation/pages/main_page.dart';
import 'forgot_password_page.dart';
import 'registration_page.dart';
import '../../../../core/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  // Design Colors
  //static const Color _primaryColor = Color(0xFF01344F);
  //static const Color _accentColor = Color(0xFFFAE3AC);

  // Keys for identifying widgets in tests or inspector
  static const Key loginIDFieldKey = Key('login_id_field');
  static const Key passwordFieldKey = Key('password_field');
  static const Key googleLoginKey = Key('google_login_button');
  static const Key loginButtonKey = Key('login_button');
  static const Key signUpLinkKey = Key('sign_up_link');
  static const Key experimentFabKey = Key('experiment_fab');

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


Future<void> _login() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  try {
    // Step 1: Call Django Login API
    final result = await ApiService.login(
      _loginController.text.trim(),
      _passwordController.text,
    );

    // Step 2: Check returned User
    debugPrint(
      'Login Success: ${result['user']['user_id']}',
    );

    if (!mounted) return;

    // Step 3: Only navigate after successful login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );

  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login failed: $error'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: _primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 40),
                        _buildLoginIDField(),
                        const SizedBox(height: 24),
                        _buildPasswordField(),
                        const SizedBox(height: 24),
                        _buildLoginButton(),
                        _buildSocialLogin(),
                        const SizedBox(height: 24),
                        _buildSignUpLink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildExperimentalFab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExperimentalFab(BuildContext context) {
    if (!AppConfig.isExperimentalFeatureVisible) {
      return const SizedBox.shrink();
    }
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton(
        key: experimentFabKey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExperimentalPage()),
          );
        },
        backgroundColor: Colors.red,
        child: const FaIcon(FontAwesomeIcons.flask, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Welcome!!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome to your to-do targeting app! Sign in to your account to proceed.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginIDField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login ID',
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: loginIDFieldKey,
          controller: _loginController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter your login ID',
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (AppConfig.experiment1BypassLoginValidation) return null; // Experiment 1
            if (value == null || value.isEmpty) {
              return 'Please enter your login ID';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: passwordFieldKey,
          controller: _passwordController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
              ),
              color: Colors.grey[300],
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
          obscureText: _isObscure,
          validator: (value) {
            if (AppConfig.experiment1BypassLoginValidation) return null; // Experiment 1
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: loginButtonKey,
        onPressed: _login,
        child: const Text(
          'Sign In',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            children: [
              Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('OR', style: TextStyle(color: Colors.grey[300], fontSize: 14)),
              ),
              Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
            ],
          ),
        ),
        OutlinedButton(
          key: googleLoginKey,
          onPressed: () {
             // TODO: Google Sign In
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Simple G placeholder
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: TextStyle(color: Colors.grey[400])),
        GestureDetector(
          key: signUpLinkKey,
          onTap: () {
             // TODO: Navigate to registration page
             Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage(),));
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}