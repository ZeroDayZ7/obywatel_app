// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Documents)
final documentsProvider = DocumentsProvider._();

final class DocumentsProvider
    extends $StreamNotifierProvider<Documents, List<DocumentModel>> {
  DocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsHash();

  @$internal
  @override
  Documents create() => Documents();
}

String _$documentsHash() => r'a0459b58160414abe37e105f8346687b1499550f';

abstract class _$Documents extends $StreamNotifier<List<DocumentModel>> {
  Stream<List<DocumentModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<DocumentModel>>, List<DocumentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DocumentModel>>, List<DocumentModel>>,
              AsyncValue<List<DocumentModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(documentDetail)
final documentDetailProvider = DocumentDetailFamily._();

final class DocumentDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<DocumentModel?>,
          DocumentModel?,
          FutureOr<DocumentModel?>
        >
    with $FutureModifier<DocumentModel?>, $FutureProvider<DocumentModel?> {
  DocumentDetailProvider._({
    required DocumentDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentDetailProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentDetailHash();

  @override
  String toString() {
    return r'documentDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DocumentModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DocumentModel?> create(Ref ref) {
    final argument = this.argument as String;
    return documentDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentDetailHash() => r'39483435b62e681e9155553a698ee08ae6f1ef57';

final class DocumentDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DocumentModel?>, String> {
  DocumentDetailFamily._()
    : super(
        retry: null,
        name: r'documentDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  DocumentDetailProvider call(String id) =>
      DocumentDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'documentDetailProvider';
}
