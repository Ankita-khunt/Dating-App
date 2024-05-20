import 'dart:async';

import 'package:dating_app/src/widgets/custom_card_swiper/enums.dart';
import 'package:flutter/material.dart';

typedef CardSwiperOnSwipe = FutureOr<bool> Function(
  int previousIndex,
  int? currentIndex,
  CardSwiperDirection direction,
);

typedef CardSwiperOnSwipeUpdate = Function(
  int? currentIndex,
  CardSwiperDirection direction,
);

typedef NullableCardBuilder = Widget? Function(
  BuildContext context,
  int index,
  int horizontalOffsetPercentage,
  int verticalOffsetPercentage,
);

typedef CardSwiperDirectionChange = Function(
  CardSwiperDirection horizontalDirection,
  CardSwiperDirection verticalDirection,
);

typedef CardSwiperOnEnd = FutureOr<void> Function();

typedef CardSwiperOnTapDisabled = FutureOr<void> Function();

typedef CardSwiperOnUndo = bool Function(
  int? previousIndex,
  int currentIndex,
  CardSwiperDirection direction,
);
