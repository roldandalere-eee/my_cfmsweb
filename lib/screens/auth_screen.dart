import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/success_dialog.dart';

enum AuthMode { login, signUp, forgotPassword }

class AuthScreen extends StatefulWidget {
  final bool initialIsSignUp;

  const AuthScreen({super.key, this.initialIsSignUp = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AuthMode _mode;
  late AnimationController _animController;
  bool _rememberMe = false;

  // Password visibility states
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = widget.initialIsSignUp ? AuthMode.signUp : AuthMode.login;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_mode == AuthMode.signUp) {
        showDialog(
          context: context,
          builder: (context) => SuccessModal(
            title: "ACCOUNT CREATED!",
            buttonText: "CONTINUE TO LOGIN",
            onConfirm: () {
              setState(() {
                _mode = AuthMode.login;
              });
            },
          ),
        );
      } else if (_mode == AuthMode.forgotPassword) {
        showDialog(
          context: context,
          builder: (context) => SuccessModal(
            title: "PASSWORD CHANGED!",
            buttonText: "CONTINUE TO LOGIN",
            onConfirm: () {
              setState(() {
                _mode = AuthMode.login;
              });
            },
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Flowing maroon background effect
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: FlowingMaroonPainter(progress: _animController.value),
              );
            },
          ),

          // Main Centered Split Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isCompact ? 440 : 820,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: isCompact
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLogoSection(),
                              const Divider(height: 32),
                              _buildFormSection(),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(36.0),
                                child: _buildFormSection(),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 400,
                              color: const Color(0xFFEFEFEF),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.all(36.0),
                                child: _buildLogoSection(),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Image.asset(
            'assets/images/logo.png',
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                color: AppTheme.accentGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.apartment,
                color: AppTheme.primaryMaroon,
                size: 42,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          "CFMS",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: AppTheme.primaryMaroon,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "CAMPUS FACILITY\nMAINTENANCE SYSTEM",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondary,
            height: 1.3,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_mode == AuthMode.login) ...[
            const Text(
              "WELCOME!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Log in to your account to continue",
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email / Username",
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppTheme.primaryMaroon,
                        onChanged: (val) =>
                            setState(() => _rememberMe = val ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("Remember Me", style: TextStyle(fontSize: 11)),
                  ],
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => _mode = AuthMode.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primaryMaroon,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryMaroon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _handleSubmit,
                child: const Text("LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ",
                    style:
                        TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                GestureDetector(
                  onTap: () => setState(() => _mode = AuthMode.signUp),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (_mode == AuthMode.signUp) ...[
            const Text(
              "Create Your Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name / Username",
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined, size: 20),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryMaroon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _handleSubmit,
                child: const Text("SIGN UP",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style:
                        TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                GestureDetector(
                  onTap: () => setState(() => _mode = AuthMode.login),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const Text(
              "Change Your Password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email or Username",
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "New Password",
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryMaroon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _handleSubmit,
                child: const Text("SUBMIT",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _mode = AuthMode.login),
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryMaroon,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FlowingMaroonPainter extends CustomPainter {
  final double progress;

  FlowingMaroonPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double flowOffset = math.sin(progress * math.pi * 2) * 20.0;

    final Path topRightPath = Path()
      ..moveTo(size.width * 0.45, 0)
      ..quadraticBezierTo(
        size.width * 0.70 + flowOffset,
        size.height * 0.15 - flowOffset,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, 0)
      ..close();

    final Paint topRightPaint = Paint()
      ..shader = LinearGradient(
        colors: const [
          Color(0xFF50000A),
          Color(0xFF7A0C0C),
          Color(0xFF9E1B1B),
        ],
        begin: Alignment(1.0 + (flowOffset / 100), -1.0),
        end: Alignment(-0.5, 0.8),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(topRightPath, topRightPaint);

    final Path bottomLeftPath = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.25 - flowOffset,
        size.height * 0.85 + flowOffset,
        size.width * 0.55,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();

    final Paint bottomLeftPaint = Paint()
      ..shader = LinearGradient(
        colors: const [
          Color(0xFF7A0C0C),
          Color(0xFF4A000B),
          Color(0xFF2E0006),
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(bottomLeftPath, bottomLeftPaint);
  }

  @override
  bool shouldRepaint(covariant FlowingMaroonPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
