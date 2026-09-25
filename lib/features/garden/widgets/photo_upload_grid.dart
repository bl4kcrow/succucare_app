import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/core/theme/app_radius.dart';
import 'package:succucare_app/core/theme/icon_size.dart';
import 'package:succucare_app/core/theme/insets.dart';

class PhotoUploadGrid extends StatelessWidget {
  const PhotoUploadGrid({
    super.key,
    required this.selectedImages,
    required this.onImageAdded,
    required this.onImageRemoved,
    this.existingPhotoUrl,
  });

  final List<File> selectedImages;
  final ValueChanged<File> onImageAdded;
  final ValueChanged<int> onImageRemoved;
  final String? existingPhotoUrl;

  Future<void> _pickImage(BuildContext context) async {
    final source = await _showImageSourceSheet(context);
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      onImageAdded(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PhotoGridHeader(),
        const SizedBox(height: Insets.small),
        SizedBox(
          height: screenSize.height / 4,
          width: double.infinity,
          child: selectedImages.isNotEmpty
              ? _MainPhotoPreview(
                  image: selectedImages.first,
                  onRemove: () => onImageRemoved(0),
                )
              : (existingPhotoUrl != null && existingPhotoUrl!.isNotEmpty)
              ? _ExistingPhotoPreview(
                  photoUrl: existingPhotoUrl!,
                  onReplace: () => _pickImage(context),
                )
              : _MainPhotoPlaceholder(onTap: () => _pickImage(context)),
        ),
      ],
    );
  }
}

Future<ImageSource?> _showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Cámara'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galería'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}

class _PhotoGridHeader extends StatelessWidget {
  const _PhotoGridHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'FOTO DE LA PLANTA',
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.08,
            color: AppColors.rocketMetallic,
          ),
        ),
        Text(
          '1 principal',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MainPhotoPreview extends StatelessWidget {
  const _MainPhotoPreview({required this.image, required this.onRemove});

  final File image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: Image.file(image, fit: BoxFit.cover),
          ),
          const Positioned(top: 8, left: 8, child: _MainBadge()),
          Positioned(top: 8, right: 8, child: _RemoveButton(onTap: onRemove)),
        ],
      ),
    );
  }
}

class _ExistingPhotoPreview extends StatelessWidget {
  const _ExistingPhotoPreview({
    required this.photoUrl,
    required this.onReplace,
  });

  final String photoUrl;
  final VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(color: const Color(0xFFF8F9FB));
              },
              errorWidget: (context, url, error) {
                return Container(
                  color: const Color(0xFFF8F9FB),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.coolGrey,
                  ),
                );
              },
            ),
          ),
          const Positioned(top: 8, left: 8, child: _MainBadge()),
          Positioned(top: 8, right: 8, child: _ReplaceButton(onTap: onReplace)),
        ],
      ),
    );
  }
}

class _ReplaceButton extends StatelessWidget {
  const _ReplaceButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.photo_camera_outlined, size: 16),
      ),
    );
  }
}

class _MainBadge extends StatelessWidget {
  const _MainBadge();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.coolGrey.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            'Principal',
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainPhotoPlaceholder extends StatelessWidget {
  const _MainPhotoPlaceholder({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.coolGrey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(
              color: AppColors.coolGrey.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: IconSize.small * 2,
                height: IconSize.small * 2,
                decoration: const BoxDecoration(
                  color: AppColors.coolGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Añadir foto',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.rocketMetallic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryPhotos extends StatelessWidget {
  const _SecondaryPhotos({
    required this.images,
    required this.onAddTap,
    required this.onImageRemoved,
  });

  final List<File> images;
  final VoidCallback onAddTap;
  final ValueChanged<int> onImageRemoved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AddPhotoTile(
          images: images,
          onAddTap: onAddTap,
          onImageRemoved: onImageRemoved,
        ),
        if (images.length > 2) _MorePhotosCounter(count: images.length - 2),
      ],
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({
    required this.images,
    required this.onAddTap,
    required this.onImageRemoved,
  });

  final List<File> images;
  final VoidCallback onAddTap;
  final ValueChanged<int> onImageRemoved;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onAddTap,
      child: Container(
        height: images.isNotEmpty ? null : 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: images.isNotEmpty
            ? Column(
                children: [
                  for (int i = 1; i < images.length && i < 3; i++)
                    _PhotoThumbnail(
                      image: images[i],
                      onRemove: () => onImageRemoved(i),
                    ),
                ],
              )
            : const _AddPhotoPlaceholder(),
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail({required this.image, required this.onRemove});

  final File image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              image,
              height: 36,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.delete, size: 16, color: Colors.red),
      ),
    );
  }
}

class _AddPhotoPlaceholder extends StatelessWidget {
  const _AddPhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.coolGrey.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_a_photo,
            color: AppColors.coolGrey,
            size: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Añadir foto',
          style: textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: AppColors.rocketMetallic,
          ),
        ),
      ],
    );
  }
}

class _MorePhotosCounter extends StatelessWidget {
  const _MorePhotosCounter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Center(
          child: Text(
            '+$count más',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
