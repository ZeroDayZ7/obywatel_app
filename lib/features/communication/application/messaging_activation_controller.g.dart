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
    r'4297648fbffc7301465bea76a4b4566b5f234cfe';

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
