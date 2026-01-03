// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

final class TokenStorageProvider
    extends
        $FunctionalProvider<
          TokenStorage<OAuth2Token>,
          TokenStorage<OAuth2Token>,
          TokenStorage<OAuth2Token>
        >
    with $Provider<TokenStorage<OAuth2Token>> {
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage<OAuth2Token>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TokenStorage<OAuth2Token> create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage<OAuth2Token> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage<OAuth2Token>>(value),
    );
  }
}

String _$tokenStorageHash() => r'8dd4493df2a17a522d7343c2099266ad6b8d3132';
