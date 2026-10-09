import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/views/screens/settings/theme_settings_screen/widget/app_theme_preference.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() =>
      _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  ThemeMode _selectedThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeMode = await AppThemePreference.load();

    if (!mounted) return;

    setState(() {
      _selectedThemeMode = themeMode;
    });
  }

  Future<void> _selectTheme(ThemeMode themeMode) async {
    if (_selectedThemeMode == themeMode) return;

    setState(() {
      _selectedThemeMode = themeMode;
    });

    Get.changeThemeMode(themeMode);

    await AppThemePreference.save(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          "Theme Settings",
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 56.r,
                      width: 56.r,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.palette_outlined,
                        size: 28.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      "Choose your appearance",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      "Personalize your app by selecting a theme "
                      "that feels comfortable to you.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        height: 1.6,
                        color: colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              CustomText(
                "APPEARANCE",
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: colorScheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              _ThemeOptionCard(
                title: "Light",
                subtitle: "Bright background and dark text",
                icon: Icons.light_mode_rounded,
                themeMode: ThemeMode.light,
                isSelected:
                    _selectedThemeMode == ThemeMode.light,
                onTap: () => _selectTheme(ThemeMode.light),
              ),

              _ThemeOptionCard(
                title: "Dark",
                subtitle: "Dark background with comfortable contrast",
                icon: Icons.dark_mode_rounded,
                themeMode: ThemeMode.dark,
                isSelected:
                    _selectedThemeMode == ThemeMode.dark,
                onTap: () => _selectTheme(ThemeMode.dark),
              ),

              _ThemeOptionCard(
                title: "System default",
                subtitle: "Follow your device appearance settings",
                icon: Icons.settings_brightness_rounded,
                themeMode: ThemeMode.system,
                isSelected:
                    _selectedThemeMode == ThemeMode.system,
                onTap: () => _selectTheme(ThemeMode.system),
              ),

              SizedBox(height: 20.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18.sp,
                    color: colorScheme.onSurface.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomText(
                      "Your appearance preference is saved "
                      "automatically and applied throughout the app.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        height: 1.5,
                        color: colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode themeMode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.10),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(
                            alpha: 0.12,
                          )
                        : colorScheme.onSurface.withValues(
                            alpha: 0.05,
                          ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    icon,
                    size: 25.sp,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                  ),
                ),

                SizedBox(width: 14.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      CustomText(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: colorScheme.onSurface.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  size: 23.sp,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}