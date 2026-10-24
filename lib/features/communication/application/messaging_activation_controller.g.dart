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
    r'9e9de6ab48018b949c80b37fd5b6df9415025bf9';

abstract class _$MessagingActivationController
    extends $AsyncNotifier<MessagingActivationState> {
  FutureOr<MessagingActivationState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
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
    return element.handleCreate(ref, build);
  }
}
