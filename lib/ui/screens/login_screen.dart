import 'package:flutter/material.dart';
import 'package:responsive_flutter_ui/responsive_flutter_ui.dart';
import '../../core/api/api_client.dart';
import '../../core/state/app_state.dart';
import '../widgets/tenant_badge.dart';
import '../widgets/tenant_logo.dart';
import '../widgets/variant_switcher_modal.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@company.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final client = ApiClient();
      final result = await client.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      final user = result['user'] as Map<String, dynamic>;
      final appState = AppStateProvider.of(context);
      appState.login(
        email: user['email'] as String,
        name: user['name'] as String,
      );

      widget.onLoginSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Authentication failed: Please check credentials.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBiometricLogin() {
    final appState = AppStateProvider.of(context);
    final tenant = appState.config.tenant;
    appState.login(
      email: 'biometric.${tenant.id}@enterprise.com',
      name: '${tenant.displayName} Biometric Officer',
    );
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final tenant = appState.config.tenant;
    final env = appState.config.environment;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: ResponsiveContainer(
              maxWidth: 380,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top Tenant Badge & Environment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TenantBadge(tenant: tenant, environment: env, compact: true),
                      ),
                      IconButton(
                        tooltip: 'Switch Variant / Inspect Matrix',
                        iconSize: 18.r,
                        icon: const Icon(Icons.layers_outlined),
                        onPressed: () => VariantSwitcherModal.show(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Tenant Branding
                  TenantLogo(tenant: tenant, size: 44),
                  SizedBox(height: 8.h),
                  Text(
                    tenant.displayName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    tenant.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Login Form Card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(13.r),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sign in to your portal',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Routing via ${env.displayName} API',
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: tenant.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 14.h),

                            // Error Message Banner
                            if (_errorMessage != null) ...[
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(color: theme.colorScheme.error, width: 1.w),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: theme.colorScheme.error, size: 15.r),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                          fontSize: 10.5.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],

                            // Email input
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 12.5.sp),
                              decoration: const InputDecoration(
                                labelText: 'Enterprise Email',
                                prefixIcon: Icon(Icons.email_outlined, size: 18),
                              ),
                              validator: (val) {
                                if (val == null || !val.contains('@')) {
                                  return 'Enter a valid enterprise email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10.h),

                            // Password input
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(fontSize: 12.5.sp),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline, size: 18),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.length < 4) {
                                  return 'Password must be at least 4 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14.h),

                            // Submit Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading
                                  ? SizedBox(
                                      width: 16.r,
                                      height: 16.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Sign In',
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                            ),

                            // Biometric Auth Option (Feature gated by tenant)
                            if (tenant.featureFlags.biometricAuth) ...[
                              SizedBox(height: 8.h),
                              OutlinedButton.icon(
                                onPressed: _isLoading ? null : _handleBiometricLogin,
                                icon: Icon(Icons.fingerprint, size: 15.r),
                                label: Text('Biometric Fast Sign-In', style: TextStyle(fontSize: 12.sp)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // Quick Helper / Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.terminal, size: 12.r, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                      SizedBox(width: 4.w),
                      Text(
                        'ID: ${appState.config.effectiveApplicationId}',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
