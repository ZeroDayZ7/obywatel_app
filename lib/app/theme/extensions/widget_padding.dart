import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/margins/app_margins.dart';

extension WidgetPaddingX on Widget {
  /// Dodaje standardowy margines sekcji (np. między grupami pól w formularzu)
  Widget withSectionPadding() =>
      Padding(padding: SectionMargins.defaultPadding, child: this);

  /// Dodaje margines karty (użyteczne dla kontenerów i boxów)
  Widget withCardPadding() => Padding(padding: CardMargins.all, child: this);

  /// Dodaje margines dolny (np. pod przyciskami lub nagłówkami)
  Widget withBottomMargin([double spacing = 16.0]) => Padding(
    padding: EdgeInsets.only(bottom: spacing),
    child: this,
  );
}
