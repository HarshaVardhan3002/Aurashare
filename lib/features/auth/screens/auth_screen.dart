import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // App Logo & Title
              _buildHeader(context),

              const Spacer(flex: 3),

              // Sign In Section
              _buildSignInSection(context),

              const Spacer(flex: 2),

              // Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // App Icon/Logo Placeholder
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          ),
          child: const Icon(
            Icons.qr_code_scanner,
            size: 60,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(duration: 600.ms, curve: Curves.easeOutBack)
            .fadeIn(duration: 400.ms),

        const SizedBox(height: AppTheme.spacingL),

        // App Name
        Text(
          'AuraSync',
          style: Theme.of(context).textTheme.displayLarge,
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(
            begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut),

        const SizedBox(height: AppTheme.spacingS),

        // Tagline
        Text(
          'Lightning-fast photo sharing for events',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(
            begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut),
      ],
    );
  }

  Widget _buildSignInSection(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Column(
          children: [
            // Welcome Text
            Text(
              'Welcome to AuraSync',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms),

            const SizedBox(height: AppTheme.spacingS),

            Text(
              'Join events instantly with QR codes.\nNo accounts needed.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 700.ms, duration: 600.ms),

            const SizedBox(height: AppTheme.spacingXL),

            // Get Started Button
            CustomButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () {
                      authProvider.signInAnonymously();
                    },
              isLoading: authProvider.isLoading,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: AppTheme.spacingM),
                  Text('Get Started'),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideY(
                begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOut),

            // Error Message
            if (authProvider.error != null) ...[
              const SizedBox(height: AppTheme.spacingM),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Text(
                  authProvider.error!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.errorColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(duration: 300.ms).shake(duration: 500.ms),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.security, color: Colors.blue[700], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Anonymous and secure. Your privacy is protected.',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
      ],
    );
  }
}
