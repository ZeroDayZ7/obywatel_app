// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_activation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessagingActivationController)
final messagingActivationControllerProvider =
    MessagingActivationControllerProvider._();

final class MessagingActivationControllerProvider
    extends
        $AsyncNotifierProvider<
          MessagingActivationController,
          MessagingActivationState
        > {
  MessagingActivationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagingActivationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagingActivationControllerHash();

  @$internal
  @override
  MessagingActivationController create() => MessagingActivationController();
}

String _$messagingActivationControllerHash() =>
    r'0be980068edc1a5bb59075e1f69c9f910a2190b2';

abstract class _$MessagingActivationController
    extends $AsyncNotifier<MessagingActivationState> {
  FutureOr<MessagingActivationState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<MessagingActivationState>,
              MessagingActivationState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<MessagingActivationState>,
                MessagingActivationState
              >,
              AsyncValue<MessagingActivationState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
