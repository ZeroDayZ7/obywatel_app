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

String _$documentsNotifierHash() => r'ec4b7c774e94a89b17859ba24bf129758629988a';

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
