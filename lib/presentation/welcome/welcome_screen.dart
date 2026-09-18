import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../core/widgets/mesh_app_bar.dart';
import '../../core/widgets/mesh_bottom_nav.dart';
import '../../state/app_state.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MeshAppBar(),
      bottomNavigationBar: const MeshBottomNav(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Offline Status Badge & Greeting
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_tethering, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    'P2P OFFLINE READY',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Decentralized Academic Network',
              style: AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 18),

            // Vibrant Purple & Neon Teal Gradient Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF673AB7), // Primary Container Purple
                    Color(0xFF23252A), // Dark middle surface
                    Color(0xFF006978), // Secondary Container Teal
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33A078FF),
                    blurRadius: 28,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hub Icon in Frosted Glass Container
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Icon(
                      Icons.hub,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.appName,
                    style: AppTypography.headlineLgMobile.copyWith(
                      color: AppColors.primaryFixed,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      'Secure decentralized classroom communication without internet',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Live Mesh Node Counter Snippet
                  Container(
                    padding: const EdgeInsets.only(top: 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0x22FFFFFF)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Avatar stack
                            SizedBox(
                              width: 62,
                              height: 28,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: _buildAvatarCircle('JS', AppColors.secondary, AppColors.onSecondary),
                                  ),
                                  Positioned(
                                    left: 18,
                                    child: _buildAvatarCircle('AP', AppColors.primary, AppColors.onPrimary),
                                  ),
                                  Positioned(
                                    left: 36,
                                    child: _buildAvatarCircle('+14', AppColors.surfaceBright, AppColors.onSurface),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Peers nearby',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const PulseIndicator(color: AppColors.secondary, size: 6),
                            const SizedBox(width: 6),
                            Text(
                              'Active',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Choose your role Section
            Text(
              'Choose your role',
              style: AppTypography.headlineSm.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Select how you want to participate in the local mesh network.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),

            // Teacher Button Card
            _buildRoleCard(
              title: 'I am a Teacher',
              subtitle: 'Broadcast lectures, assignments & quizzes',
              icon: Icons.school,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              iconBackgroundColor: AppColors.onPrimary.withOpacity(0.12),
              iconColor: AppColors.onPrimary,
              onTap: () => appState.selectRole(UserRole.teacher),
            ),
            const SizedBox(height: 12),

            // Student Button Card
            _buildRoleCard(
              title: 'I am a Student',
              subtitle: 'Join classes, chat offline & sync notes',
              icon: Icons.face,
              backgroundColor: AppColors.surfaceContainerHigh,
              foregroundColor: AppColors.onSurface,
              iconBackgroundColor: AppColors.secondary.withOpacity(0.15),
              iconColor: AppColors.secondary,
              onTap: () => appState.selectRole(UserRole.student),
            ),
            const SizedBox(height: 24),

            // Footer Encryption Badge
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 14, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    'End-to-End Encrypted Bluetooth LE & Wi-Fi Direct',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCircle(String text, Color bgColor, Color textColor) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 1.5),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTypography.labelSm.copyWith(
            color: textColor,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color iconBackgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineSm.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: foregroundColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: foregroundColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
