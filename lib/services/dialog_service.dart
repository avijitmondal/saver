import 'package:flutter/material.dart';

class DialogService {
  static Future<String?> showEditDialog({
    required BuildContext context,
    required String title,
    required String currentValue,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLines,
  }) async {
    controller.text = currentValue;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $title',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    return result;
  }

  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
    Color? confirmButtonColor,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelButtonText),
          ),
          ElevatedButton(
            style: confirmButtonColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmButtonColor)
                : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmButtonText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  static Future<void> showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: SimpleDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    Color? primaryColor,
  }) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        if (primaryColor == null) {
          return child!;
        }

        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<List<String>?> showNameEditDialog({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
  }) async {
    firstNameController.text = firstName;
    lastNameController.text = lastName;

    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(
              context, 
              [firstNameController.text, lastNameController.text],
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    return result;
  }
}
