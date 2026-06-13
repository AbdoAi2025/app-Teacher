import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_mode.dart';
import '../services/environment_service.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class EnvironmentDisplayWidget extends StatelessWidget {
  const EnvironmentDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentEnv = AppMode.mode;
      final shouldShow = currentEnv == AppMode.dev || AppMode.isDebug;

      if (!shouldShow) {
        return const SizedBox.shrink();
      }

      final envName = EnvironmentService.getEnvironmentName(currentEnv);
      final color = _getEnvironmentColor(currentEnv);

      return GestureDetector(
        onTap: () => _showEnvironmentDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.settings,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                envName,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _getEnvironmentColor(int environment) {
    switch (environment) {
      case AppMode.dev:
        return Colors.orange;
      case AppMode.prod:
        return Colors.green;
      case AppMode.local:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showEnvironmentDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController();

    // Load current custom URL
    EnvironmentService.getCustomLocalUrl().then((url) {
      urlController.text = url;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Environment".tr),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Environment selection
              ...EnvironmentService.getAllEnvironments().map((env) {
                final envName = EnvironmentService.getEnvironmentName(env);
                final color = _getEnvironmentColor(env);
                final isSelected = AppMode.mode == env;

                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.radio_button_checked,
                        color: isSelected ? color : Colors.grey,
                      ),
                      title: Text(
                        envName,
                        style: TextStyle(
                          color: isSelected ? color : null,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      onTap: () async {
                        AppMode.mode = env;
                        await EnvironmentService.setEnvironment(env);
                        Navigator.of(context).pop();
                      },
                    ),
                    // Show URL input for Local environment
                    if (env == AppMode.local)
                      Padding(
                        padding: const EdgeInsets.only(left: 56, right: 16, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Base URL:".tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: urlController,
                              decoration: InputDecoration(
                                hintText: "http://192.168.1.100:8080",
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                isDense: true,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.save, size: 20),
                                  onPressed: () async {
                                    final url = urlController.text.trim();
                                    if (url.isNotEmpty) {
                                      await EnvironmentService.setCustomLocalUrl(url);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("URL saved successfully".tr),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStringsKeys.cancel.tr),
          ),
        ],
      ),
    );
  }
}