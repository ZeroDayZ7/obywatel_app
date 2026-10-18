// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(attachmentPreview)
final attachmentPreviewProvider = AttachmentPreviewFamily._();

final class AttachmentPreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  AttachmentPreviewProvider._({
    required AttachmentPreviewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'attachmentPreviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$attachmentPreviewHash();

  @override
  String toString() {
    return r'attachmentPreviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as String;
    return attachmentPreview(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentPreviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attachmentPreviewHash() => r'b7fda969c5a22470541950f3767488e1c7eebef9';

final class AttachmentPreviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List?>, String> {
  AttachmentPreviewFamily._()
    : super(
        retry: null,
        name: r'attachmentPreviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AttachmentPreviewProvider call(String attachmentId) =>
      AttachmentPreviewProvider._(argument: attachmentId, from: this);

  @override
  String toString() => r'attachmentPreviewProvider';
}

@ProviderFor(attachmentFullImage)
final attachmentFullImageProvider = AttachmentFullImageFamily._();

final class AttachmentFullImageProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  AttachmentFullImageProvider._({
    required AttachmentFullImageFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'attachmentFullImageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$attachmentFullImageHash();

  @override
  String toString() {
    return r'attachmentFullImageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as String;
    return attachmentFullImage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentFullImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attachmentFullImageHash() => r'11d5543d6d9de7f5a764b9c0e5e33347d79a3df5';

final class AttachmentFullImageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List?>, String> {
  AttachmentFullImageFamily._()
    : super(
        retry: null,
        name: r'attachmentFullImageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AttachmentFullImageProvider call(String attachmentId) =>
      AttachmentFullImageProvider._(argument: attachmentId, from: this);

  @override
  String toString() => r'attachmentFullImageProvider';
}
