import 'package:app/modules/auth/helpers/validators.dart';
import 'package:app/modules/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  StateMachineController? _stateMachineController;
  SMITrigger? _surf;
  SMIBool? _keepSurfing;
  SMIBool? _isDead;
  SMIBool? _isHiding;

  bool _isLoading = false;
  bool _isFormValid = false;
  bool _obscurePassword = true;

  void _onRiveInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    if (_stateMachineController == null) return;
    artboard.addController(_stateMachineController!);

    final surfInput = _stateMachineController!.findInput<bool>('surf');
    final keepSurfingInput = _stateMachineController!.findInput<bool>(
      'keepSurfing',
    );
    final isDeadInput = _stateMachineController!.findInput<bool>('isDead');
    final isHidingInput = _stateMachineController!.findInput<bool>('isHiding');

    if (surfInput is SMITrigger) _surf = surfInput;
    if (keepSurfingInput is SMIBool) _keepSurfing = keepSurfingInput;
    if (isDeadInput is SMIBool) _isDead = isDeadInput;
    if (isHidingInput is SMIBool) _isHiding = isHidingInput;

    // Initial sync with your UI state:
    _keepSurfing?.value = _isLoading;
    _isHiding?.value = _passwordFocusNode.hasFocus && !_obscurePassword;
    // Don't set _isDead initially - wait for actual validation
  }

  void _onFieldsChanged() {
    setState(() {
      _isFormValid =
          validateEmail(_emailController.text) == null &&
          validatePassword(_passwordController.text) == null;
    });
  }

  void _onFieldUnfocus(String fieldType) {
    // Only trigger _isDead when the specific field loses focus and validation fails
    bool isFieldValid = true;

    if (fieldType == 'email') {
      isFieldValid = validateEmail(_emailController.text) == null;
    } else if (fieldType == 'password') {
      isFieldValid = validatePassword(_passwordController.text) == null;
    }

    _isDead?.value = !isFieldValid;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldsChanged);
    _passwordController.addListener(_onFieldsChanged);

    // Listen to field focus changes
    _emailFocusNode.addListener(_onEmailFocusChanged);
    _passwordFocusNode.addListener(_onPasswordFocusChanged);
  }

  void _onEmailFocusChanged() {
    // Handle email field focus changes
    if (!_emailFocusNode.hasFocus) {
      // Email field lost focus - validate it
      _onFieldUnfocus('email');
    }
  }

  void _onPasswordFocusChanged() {
    _isHiding?.value =
        _passwordFocusNode.hasFocus; //  && !_obscurePassword; also nice

    if (!_passwordFocusNode.hasFocus) {
      // Password field lost focus - validate it
      _onFieldUnfocus('password');
    }
  }

  void _onPasswordVisibilityChanged() {
    _isHiding?.value =
        _passwordFocusNode.hasFocus; // && !_obscurePassword; also nice
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Trigger surf animation with keepSurfing
    _surf?.fire();
    _keepSurfing?.value = true;
    _isHiding?.value = false;

    try {
      // For demo purposes, accept any non-empty credentials
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        // Update authentication state
        await ref.read(authProvider.notifier).login();

        // Navigation will be handled automatically by the router redirect
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter valid credentials')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _keepSurfing?.value = false;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.removeListener(_onEmailFocusChanged);
    _passwordFocusNode.removeListener(_onPasswordFocusChanged);

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: RiveAnimation.asset(
                    'assets/rive/surfer.riv',
                    artboard: 'Artboard',
                    stateMachines: const ['StateMachine 1'],
                    fit: BoxFit.contain,
                    onInit: _onRiveInit,
                  ),
                ),
                const Gap(24),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,

                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: validateEmail,
                ),
                const Gap(16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                        _onPasswordVisibilityChanged();
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: validatePassword,
                ),
                const Gap(24),

                // Login Button
                ElevatedButton(
                  onPressed: switch ((_isLoading, _isFormValid)) {
                    (true, _) => null,
                    (false, true) => _login,
                    _ => null,
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign In', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
