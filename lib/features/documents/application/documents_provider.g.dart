// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DocumentsNotifier)
final documentsProvider = DocumentsNotifierProvider._();

final class DocumentsNotifierProvider
    extends $AsyncNotifierProvider<DocumentsNotifier, List<DocumentModel>> {
  DocumentsNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$documentsNotifierHash();

  @$internal
  @override
  DocumentsNotifier create() => DocumentsNotifier();
}

String _$documentsNotifierHash() => r'5d24d0f73edba9ffc5dc72fe840b3c4f755c9a88';

abstract class _$DocumentsNotifier extends $AsyncNotifier<List<DocumentModel>> {
  FutureOr<List<DocumentModel>> build();
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

@ProviderFor(DocumentDetailNotifier)
final documentDetailProvider = DocumentDetailNotifierFamily._();

final class DocumentDetailNotifierProvider
    extends $AsyncNotifierProvider<DocumentDetailNotifier, DocumentModel> {
  DocumentDetailNotifierProvider._({
    required DocumentDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentDetailNotifierHash();

  @override
  String toString() {
    return r'documentDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DocumentDetailNotifier create() => DocumentDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is DocumentDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentDetailNotifierHash() =>
    r'fdc0e48d7a3028a1af3f72beecdae42762bba31e';

final class DocumentDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DocumentDetailNotifier,
          AsyncValue<DocumentModel>,
          DocumentModel,
          FutureOr<DocumentModel>,
          String
        > {
  DocumentDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'documentDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DocumentDetailNotifierProvider call(String id) =>
      DocumentDetailNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'documentDetailProvider';
}

abstract class _$DocumentDetailNotifier extends $AsyncNotifier<DocumentModel> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<DocumentModel> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DocumentModel>, DocumentModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DocumentModel>, DocumentModel>,
              AsyncValue<DocumentModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
