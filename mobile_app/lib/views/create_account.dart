import 'package:flutter/material.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/core/comeponents/app_input.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/logic/providers/auth_provider.dart';
import 'package:graduation_project/views/home/home.dart';
import 'package:graduation_project/views/login.dart';
import 'package:provider/provider.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool isChecked = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // Reset errors
    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _generalError = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Local validation
    bool hasError = false;

    if (name.isEmpty) {
      setState(() => _nameError = '╪د┘╪▒╪ش╪د╪ة ╪ح╪»╪«╪د┘ ╪د┘╪د╪│┘à ╪د┘┘â╪د┘à┘');
      hasError = true;
    }

    if (email.isEmpty) {
      setState(() => _emailError = '╪د┘╪▒╪ش╪د╪ة ╪ح╪»╪«╪د┘ ╪د┘╪ذ╪▒┘è╪» ╪د┘╪ح┘┘â╪ز╪▒┘ê┘┘è');
      hasError = true;
    } else if (!email.contains('@') || !email.contains('.')) {
      setState(() => _emailError = '╪╡┘è╪║╪ر ╪د┘╪ذ╪▒┘è╪» ╪د┘╪ح┘┘â╪ز╪▒┘ê┘┘è ╪║┘è╪▒ ╪╡╪ص┘è╪ص╪ر');
      hasError = true;
    }

    if (phone.isEmpty) {
      setState(() => _phoneError = '╪د┘╪▒╪ش╪د╪ة ╪ح╪»╪«╪د┘ ╪▒┘é┘à ╪د┘┘ç╪د╪ز┘');
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = '╪د┘╪▒╪ش╪د╪ة ╪ح╪»╪«╪د┘ ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒');
      hasError = true;
    } else if (password.length < 4) {
      setState(() => _passwordError = '┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒ ┘è╪ش╪ذ ╪ث┘ ╪ز┘â┘ê┘ 4 ╪ث╪ص╪▒┘ ╪╣┘┘ë ╪د┘╪ث┘é┘');
      hasError = true;
    }

    if (confirmPassword.isEmpty) {
      setState(() => _confirmPasswordError = '╪د┘╪▒╪ش╪د╪ة ╪ز╪ث┘â┘è╪» ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒');
      hasError = true;
    } else if (password != confirmPassword) {
      setState(() => _confirmPasswordError = '┘â┘┘à╪ز╪د ╪د┘┘à╪▒┘ê╪▒ ╪║┘è╪▒ ┘à╪ز╪╖╪د╪ذ┘é╪ز┘è┘');
      hasError = true;
    }

    if (!isChecked) {
      setState(() => _generalError = '┘è╪ش╪ذ ╪د┘┘à┘ê╪د┘┘é╪ر ╪╣┘┘ë ╪د┘╪┤╪▒┘ê╪╖ ┘ê╪د┘╪ث╪ص┘â╪د┘à ╪ث┘ê┘╪د┘ï');
      hasError = true;
    }

    if (hasError) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      name: name,
      email: email,
      phoneNumber: phone,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      if (!mounted) return;
      final error = auth.errorMessage ?? '';

      // Handles both English (new backend) and Arabic (legacy) messages
      if (error.contains('┘à╪│╪ش┘ّ┘ ╪ذ╪د┘┘╪╣┘') || error.contains('EMAIL_EXISTS') ||
          error.contains('Email already exists') || error.contains('already exists')) {
        setState(() => _emailError = '┘ç╪░╪د ╪د┘╪ذ╪▒┘è╪» ╪د┘╪ح┘┘â╪ز╪▒┘ê┘┘è ┘à╪│╪ش┘ّ┘ ╪ذ╪د┘┘╪╣┘╪î ┘è┘à┘â┘┘â ╪ز╪│╪ش┘è┘ ╪د┘╪»╪«┘ê┘');
      } else if (error.contains('┘à╪ز╪╖╪د╪ذ┘é╪ز┘è┘') || error.contains('PASSWORD_MISMATCH')) {
        setState(() => _confirmPasswordError = '┘â┘┘à╪ز╪د ╪د┘┘à╪▒┘ê╪▒ ╪║┘è╪▒ ┘à╪ز╪╖╪د╪ذ┘é╪ز┘è┘');
      } else if (error.contains('Connection') || error.contains('SocketException') || error.contains('Failed host')) {
        setState(() => _generalError = '┘╪د ┘è┘à┘â┘ ╪د┘╪د╪ز╪╡╪د┘ ╪ذ╪د┘╪«╪د╪»┘à╪î ╪ز╪ث┘â╪» ┘à┘ ╪د╪ز╪╡╪د┘┘â ╪ذ╪د┘╪ح┘╪ز╪▒┘╪ز');
      } else {
        setState(() => _generalError = error.isNotEmpty ? error : '┘╪┤┘ ╪ح┘╪┤╪د╪ة ╪د┘╪ص╪│╪د╪ذ╪î ╪ص╪د┘ê┘ ┘à╪▒╪ر ╪ث╪«╪▒┘ë');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text: 'Car',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: 'Ma',
                          style: TextStyle(color: AppTheme.carmaGold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    '╪ح┘╪┤╪د╪ة ╪ص╪│╪د╪ذ ╪ش╪»┘è╪»',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // General error banner
                  if (_generalError != null) ...[
                    _ErrorBanner(message: _generalError!),
                    const SizedBox(height: 16),
                  ],

                  AppInput(
                    controller: _nameController,
                    label: '╪د┘╪د╪│┘à ╪د┘┘â╪د┘à┘',
                    hint: '╪ث╪»╪«┘ ╪د╪│┘à┘â ╪د┘┘â╪د┘à┘',
                    keyboardType: TextInputType.name,
                    onChanged: (_) => setState(() => _nameError = null),
                  ),
                  if (_nameError != null) _InlineError(message: _nameError!),
                  const SizedBox(height: 20),

                  AppInput(
                    controller: _emailController,
                    label: '╪د┘╪ذ╪▒┘è╪» ╪د┘╪ح┘┘â╪ز╪▒┘ê┘┘è',
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() => _emailError = null),
                  ),
                  if (_emailError != null) _InlineError(message: _emailError!),
                  const SizedBox(height: 20),

                  AppInput(
                    controller: _phoneController,
                    label: '╪▒┘é┘à ╪د┘┘ç╪د╪ز┘',
                    hint: '5xxxxxxxx',
                    keyboardType: TextInputType.phone,
                    withCuntryCode: false,
                    onChanged: (_) => setState(() => _phoneError = null),
                  ),
                  if (_phoneError != null) _InlineError(message: _phoneError!),
                  const SizedBox(height: 20),

                  AppInput(
                    controller: _passwordController,
                    label: '┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒',
                    hint: '╪ث╪»╪«┘ ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒',
                    isPassword: true,
                    onChanged: (_) => setState(() => _passwordError = null),
                  ),
                  if (_passwordError != null) _InlineError(message: _passwordError!),
                  const SizedBox(height: 20),

                  AppInput(
                    controller: _confirmPasswordController,
                    label: '╪ز╪ث┘â┘è╪» ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒',
                    hint: '╪ث╪╣╪» ╪ح╪»╪«╪د┘ ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒',
                    isPassword: true,
                    onChanged: (_) => setState(() => _confirmPasswordError = null),
                  ),
                  if (_confirmPasswordError != null) _InlineError(message: _confirmPasswordError!),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: isChecked,
                          activeColor: AppTheme.carmaGold,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          side: BorderSide(color: Theme.of(context).colorScheme.outline),
                          onChanged: (value) {
                            setState(() {
                              isChecked = value ?? false;
                              if (isChecked) _generalError = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '╪ث┘ê╪د┘┘é ╪╣┘┘ë ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        '╪د┘╪┤╪▒┘ê╪╖ ┘ê╪د┘╪ث╪ص┘â╪د┘à',
                        style: TextStyle(
                          color: AppTheme.carmaGold,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      if (auth.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return AppButton(
                        text: '╪ح┘╪┤╪د╪ة ╪ص╪│╪د╪ذ',
                        onPressed: _handleRegister,
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '┘╪»┘è┘â ╪ص╪│╪د╪ذ ╪ذ╪د┘┘╪╣┘╪ا ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          '╪ز╪│╪ش┘è┘ ╪»╪«┘ê┘',
                          style: TextStyle(
                            color: AppTheme.carmaGold,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

// ظ¤ظ¤ظ¤ Inline error under a field ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
class _InlineError extends StatelessWidget {
  final String message;
  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 14, color: Color(0xFFE7000B)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFE7000B), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ظ¤ظ¤ظ¤ General error banner ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB3B3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFE7000B), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFB00020), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
