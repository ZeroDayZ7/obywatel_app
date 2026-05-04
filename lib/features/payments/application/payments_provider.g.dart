// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Payments)
final paymentsProvider = PaymentsProvider._();

final class PaymentsProvider
    extends $AsyncNotifierProvider<Payments, PaymentsState> {
  PaymentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentsHash();

  @$internal
  @override
  Payments create() => Payments();
}

String _$paymentsHash() => r'c1696fc8002f27d6878fde43735761edce361fab';

abstract class _$Payments extends $AsyncNotifier<PaymentsState> {
  FutureOr<PaymentsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PaymentsState>, PaymentsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaymentsState>, PaymentsState>,
              AsyncValue<PaymentsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
