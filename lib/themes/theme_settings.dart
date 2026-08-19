
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

// Dialog widget to handle app theme and primary color selection
class ThemeSettings extends StatefulWidget {
  final ThemeMode themeMode;
  final Color primaryColor;
  final List<Color> colors;

  final Function(ThemeMode) changeTheme;
  final Function(Color) changeColor;

  const ThemeSettings({
    super.key,
    required this.themeMode,
    required this.primaryColor,
    required this.colors,
    required this.changeTheme,
    required this.changeColor,
  });

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  // Helper method to build custom theme selection tiles
  Widget _buildThemeTile(String label, ThemeMode mode, StateSetter updateState) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: widget.themeMode,
      onChanged: (selectedMode) {
        if (selectedMode != null) {
          widget.changeTheme(selectedMode);
          updateState(() {});
        }
      },
    );
  }

  void openTheme(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Theme Settings"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Choose Mode:", style: TextStyle(fontWeight: FontWeight.bold)),
                    
                    // Reusable theme options
                    _buildThemeTile("Light", ThemeMode.light, setDialogState),
                    _buildThemeTile("Dark", ThemeMode.dark, setDialogState),
                    _buildThemeTile("System", ThemeMode.system, setDialogState),

                    const Divider(height: 24),

                    const Text("Choose Color:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    ColorPicker(
                      color: widget.primaryColor,
                      onColorChanged: (newColor) {
                        widget.changeColor(newColor);
                        setDialogState(() {});
                      },
                    ),

                    if (widget.colors.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text("Recent Colors:"),
                      const SizedBox(height: 8),
                      
                      // Render recently picked colors
                      Wrap(
                        spacing: 8,
                        children: widget.colors.map((c) {
                          return GestureDetector(
                            onTap: () {
                              widget.changeColor(c);
                              setDialogState(() {});
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).dividerColor),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.palette),
      onPressed: () => openTheme(context),
    );
  }
}