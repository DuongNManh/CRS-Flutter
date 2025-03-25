import 'package:flutter/material.dart';
import 'package:learning_android_1/data/constants.dart';
import 'package:learning_android_1/data/notifiers.dart';

class TestUiPage extends StatefulWidget {
  const TestUiPage({super.key});

  @override
  State<TestUiPage> createState() => _TestUiPageState();
}

class _TestUiPageState extends State<TestUiPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isChecked = false;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add Scaffold here
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton(
                value: dropdownValue,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                hint: Text(
                  'Select an item',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'i1',
                    child: Text(
                      'Item 1',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'i2',
                    child: Text(
                      'Item 2',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'i3',
                    child: Text(
                      'Item 3',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                  });
                  final snackBarContent =
                      value != null ? "$value Selected!" : "No item selected!";
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(snackBarContent),
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.md),
              TextField(
                controller: nameController,
                style: AppTextStyle.input,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: AppTextStyle.label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ),
                onEditingComplete: () => setState(() {}),
              ),
              Text(nameController.text, style: AppTextStyle.bodyMedium),
              SizedBox(height: AppSpacing.md),
              TextField(
                controller: emailController,
                style: AppTextStyle.input,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: AppTextStyle.label,
                ),
                onEditingComplete: () => setState(() {}),
              ),
              Text(emailController.text, style: AppTextStyle.bodyMedium),
              Checkbox.adaptive(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              SizedBox(height: AppSpacing.md),
              CheckboxListTile.adaptive(
                title: Text('Check me', style: AppTextStyle.bodyMedium),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Switch.adaptive(
                value: isSwitched,
                onChanged: (bool? value) {
                  setState(() {
                    isSwitched = value!;
                  });
                },
              ),
              SwitchListTile.adaptive(
                title: Text("Switch me", style: AppTextStyle.bodyMedium),
                value: isSwitched,
                onChanged: (bool? value) {
                  setState(() {
                    isSwitched = value!;
                  });
                },
              ),
              Slider.adaptive(
                value: sliderValue,
                min: 0,
                max: 300,
                onChanged: (double value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
              ),
              Image.asset(
                'assets/images/HaiCau.jpg',
                width: sliderValue,
                height: sliderValue,
              ),
              ValueListenableBuilder(
                valueListenable: isDarkModeNotifier,
                builder: (context, value, child) {
                  return InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
