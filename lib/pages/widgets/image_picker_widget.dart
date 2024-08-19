import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'dart:io';
import '../../helpers/app_localizations.dart';

class ImagePickerWidget extends StatelessWidget {
  final List<File?> selectedImages;
  final void Function(int index) onPickImage;

  const ImagePickerWidget({
    super.key,
    required this.selectedImages,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).translate('image_picker_title'),
          style: TextStyle(fontSize: 16, color: theme.textTheme.titleLarge?.color),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(3, (index) {
              return GestureDetector(
                onTap: () => onPickImage(index),
                child: Card(
                  surfaceTintColor: theme.cardColor,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: DashedBorder.fromBorderSide(
                          dashLength: 8,
                          side: BorderSide(color: theme.dividerColor, width: 1),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: selectedImages[index] != null
                          ? Image.file(
                        selectedImages[index]!,
                        fit: BoxFit.cover,
                      )
                          : Center(
                        child: Icon(
                          Icons.upload_rounded,
                          size: 30,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
