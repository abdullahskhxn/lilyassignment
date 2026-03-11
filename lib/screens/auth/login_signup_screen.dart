import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/app_provider.dart';
import '../../models/user_model.dart';

class LoginSignupScreen extends StatefulWidget {
  final String role;

  const LoginSignupScreen({super.key, required this.role});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _contactController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contactController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final isSignup = _tabController.index == 1;
    final contact = _contactController.text.trim();
    final name = isSignup ? _nameController.text.trim() : 'User';

    // Set dummy user in provider
    context.read<AppProvider>().setUser(
      UserModel(
        id: '1',
        name: name.isEmpty ? 'Demo User' : name,
        email: contact.contains('@') ? contact : '',
        phone: contact.contains('@') ? '' : contact,
        role: widget.role,
        walletBalance: 125.50,
      ),
    );
    context.read<AppProvider>().setRole(widget.role);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _loading = false);
        context.go(
          '/otp/${widget.role}',
          extra: {'contact': contact},
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHost = widget.role == 'host';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go('/role'),
        ),
        title: Row(
          children: [
            const Text('Sign In  '),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary),
              ),
              child: Text(
                isHost ? 'HOST' : 'GUEST',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                isHost ? 'Host your\nbandwidth' : 'Connect to the\nnetwork',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your details to continue',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Login'),
                    Tab(text: 'Sign Up'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Login tab
                        Column(
                          children: [
                            CustomTextField(
                              label: 'Email or Phone Number',
                              controller: _contactController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.alternate_email),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                        // Sign Up tab
                        Column(
                          children: [
                            CustomTextField(
                              label: 'Full Name',
                              controller: _nameController,
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (v) => _tabController.index == 1 && (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Email or Phone Number',
                              controller: _contactController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.alternate_email),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      label: 'Send OTP',
                      onPressed: _submit,
                      loading: _loading,
                      icon: Icons.send_outlined,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.divider)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.divider)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      label: 'Continue as Demo User',
                      onPressed: () {
                        context.read<AppProvider>().setUser(UserModel(
                          id: 'demo',
                          name: 'Demo User',
                          email: 'demo@strata.io',
                          phone: '+1234567890',
                          role: widget.role,
                          walletBalance: 125.50,
                        ));
                        context.read<AppProvider>().setRole(widget.role);
                        if (widget.role == 'host') {
                          context.go('/host/onboarding');
                        } else {
                          context.go('/guest/location');
                        }
                      },
                      outlined: true,
                      icon: Icons.play_arrow_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
