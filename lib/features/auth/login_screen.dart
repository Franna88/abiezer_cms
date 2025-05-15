import 'package:flutter/material.dart';
import '../../core/theme/color_theme.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utilities/constants.dart';
import '../../core/utilities/utilities.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/forms/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Admin and Project Manager demo credentials
  final Map<String, Map<String, String>> _demoCredentials = {
    'admin': {'email': 'admin@abiezer.com', 'password': 'Admin@123'},
    'project_manager': {'email': 'pm@abiezer.com', 'password': 'Manager@123'},
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _fillCredentials(String userType) {
    if (_demoCredentials.containsKey(userType)) {
      setState(() {
        _emailController.text = _demoCredentials[userType]!['email']!;
        _passwordController.text = _demoCredentials[userType]!['password']!;
        _errorMessage = null;
      });
    }
  }

  void _handleLogin() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulate login - will be replaced with actual authentication
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;

          // For demo purposes, check if using one of our demo accounts
          if (_emailController.text == _demoCredentials['admin']!['email'] &&
              _passwordController.text ==
                  _demoCredentials['admin']!['password']) {
            // Navigate to dashboard as admin
            Navigator.pushReplacementNamed(
              context,
              AppConstants.routeDashboard,
            );
          } else if (_emailController.text ==
                  _demoCredentials['project_manager']!['email'] &&
              _passwordController.text ==
                  _demoCredentials['project_manager']!['password']) {
            // Navigate to dashboard as project manager
            Navigator.pushReplacementNamed(
              context,
              '/project-manager-dashboard',
            );
          } else {
            // In a real app, this would validate against a database
            // For demo purposes, we'll show an error message for invalid credentials
            _errorMessage = 'Invalid credentials. Please try again.';
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              maxWidth: const ResponsiveValue<double>(
                mobile: double.infinity,
                tablet: 600,
                desktop: 500,
              ),
              padding: Utils.paddingMD,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Utils.borderRadiusLG),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo or App name
                        const Center(
                          child: Text(
                            'Abiezer Construction',
                            style: AppTextStyles.heading1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Materials Management System',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Error message if login fails
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                Utils.borderRadiusSM,
                              ),
                              border: Border.all(
                                color: AppColors.error.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Demo account buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _fillCredentials('admin'),
                                icon: const Icon(Icons.admin_panel_settings),
                                label: const Text('Admin'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    () => _fillCredentials('project_manager'),
                                icon: const Icon(Icons.engineering),
                                label: const Text('Project Manager'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Email field
                        CustomTextField(
                          label: 'Email',
                          hintText: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!Utils.isValidEmail(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Password field
                        CustomTextField(
                          label: 'Password',
                          hintText: 'Enter your password',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigate to forgot password screen
                            },
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        PrimaryButton(
                          text: 'Login',
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
                        ),

                        // Divider
                        if (false) ...[
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.divider,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'OR',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.divider,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Register button
                          SecondaryButton(
                            text: 'Create Account',
                            onPressed: () {
                              // Navigate to registration screen
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget for responsive container
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final ResponsiveValue<double> maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    required this.maxWidth,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth =
        Utils.isMobile(context)
            ? (maxWidth.mobile is double ? maxWidth.mobile : double.infinity)
            : Utils.isTablet(context)
            ? maxWidth.tablet
            : maxWidth.desktop;

    return Container(
      width: containerWidth,
      padding: padding,
      constraints: BoxConstraints(
        maxWidth: containerWidth,
        maxHeight: screenWidth > 600 ? 800 : double.infinity,
      ),
      child: child,
    );
  }
}

// Simple class to hold responsive values
class ResponsiveValue<T> {
  final T mobile;
  final T tablet;
  final T desktop;

  const ResponsiveValue({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });
}
