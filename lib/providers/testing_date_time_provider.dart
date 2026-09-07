import 'package:flutter/foundation.dart';

enum WaterTestingSourceType {
  groundwater,
  surfaceWater,
  household,
  anganwadi,
}

class TestingDateTimeProvider extends ChangeNotifier {
  // ============================================================
  // SOURCE TYPE
  // ============================================================

  WaterTestingSourceType _sourceType =
      WaterTestingSourceType.surfaceWater;

  WaterTestingSourceType get sourceType => _sourceType;

  void setSourceType(WaterTestingSourceType type) {
    if (_sourceType == type) {
      return;
    }

    _sourceType = type;
    print("updated source type is $sourceType");
    // When source changes, previously selected dates may
    // belong to a different testing window.
    _collectionDateTime = null;
    _testedDateTime = null;

    notifyListeners();
  }

  // ============================================================
  // SELECTED DATE/TIME
  // ============================================================

  DateTime? _collectionDateTime;
  DateTime? _testedDateTime;

  DateTime? get collectionDateTime => _collectionDateTime;

  DateTime? get testedDateTime => _testedDateTime;

  // ============================================================
  // TODAY
  // ============================================================

  DateTime get today {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  DateTime get endOfToday {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    );
  }

  // ============================================================
  // TESTING WINDOW START
  // ============================================================

  DateTime get windowStart {
    final now = DateTime.now();

    switch (_sourceType) {
    // ----------------------------------------------------------
    // GROUNDWATER
    //
    // H1 = April - September
    // H2 = October - March
    // ----------------------------------------------------------

      case WaterTestingSourceType.groundwater:

      // H1
        if (now.month >= 4 && now.month <= 9) {
          return DateTime(
            now.year,
            4,
            1,
          );
        }

        // H2: October - December
        if (now.month >= 10) {
          return DateTime(
            now.year,
            10,
            1,
          );
        }

        // H2: January - March
        return DateTime(
          now.year - 1,
          10,
          1,
        );

    // ----------------------------------------------------------
    // SURFACE WATER
    //
    // Q1 = April - June
    // Q2 = July - September
    // Q3 = October - December
    // Q4 = January - March
    // ----------------------------------------------------------

      case WaterTestingSourceType.surfaceWater:

      // Q1
        if (now.month >= 4 && now.month <= 6) {
          return DateTime(
            now.year,
            4,
            1,
          );
        }

        // Q2
        if (now.month >= 7 && now.month <= 9) {
          return DateTime(
            now.year,
            7,
            1,
          );
        }

        // Q3
        if (now.month >= 10 && now.month <= 12) {
          return DateTime(
            now.year,
            10,
            1,
          );
        }

        // Q4
        return DateTime(
          now.year,
          1,
          1,
        );

    // ----------------------------------------------------------
    // HOUSEHOLD
    //
    // Current month only
    // ----------------------------------------------------------

      case WaterTestingSourceType.household:
        return DateTime(
          now.year,
          now.month,
          1,
        );

    // ----------------------------------------------------------
    // ANGANWADI
    //
    // Current month only
    // ----------------------------------------------------------

      case WaterTestingSourceType.anganwadi:
        return DateTime(
          now.year,
          now.month,
          1,
        );
    }
  }

  // ============================================================
  // TESTING WINDOW END
  // ============================================================

  DateTime get windowEnd {
    // IMPORTANT:
    //
    // Never allow future dates.
    //
    // Therefore the current date/time is always the
    // maximum selectable value.

    return endOfToday;
  }

  // ============================================================
  // COLLECTION DATE
  // ============================================================

  void setCollectionDateTime(DateTime value) {
    // Validate against current testing window.
    if (!isCollectionDateTimeValid(value)) {
      return;
    }

    _collectionDateTime = value;

    // Existing tested date must remain at least 5 minutes
    // after collection.
    if (_testedDateTime != null) {
      if (_testedDateTime!.isBefore(
        value.add(
          const Duration(minutes: 5),
        ),
      )) {
        _testedDateTime = null;
      }
    }

    notifyListeners();
  }

  // ============================================================
  // TESTED DATE
  // ============================================================

  void setTestedDateTime(DateTime value) {
    if (!isTestedDateTimeValid(value)) {
      return;
    }

    _testedDateTime = value;

    notifyListeners();
  }

  // ============================================================
  // MINIMUM TESTING TIME
  // ============================================================

  DateTime? get minimumTestedDateTime {
    if (_collectionDateTime == null) {
      return null;
    }

    return _collectionDateTime!.add(
      const Duration(minutes: 5),
    );
  }

  // ============================================================
  // COLLECTION VALIDATION
  // ============================================================

  bool isCollectionDateTimeValid(DateTime value) {
    // Must be inside active testing window.
    if (value.isBefore(windowStart)) {
      return false;
    }

    // Cannot be future.
    if (value.isAfter(DateTime.now())) {
      return false;
    }

    return true;
  }

  // ============================================================
  // TESTED VALIDATION
  // ============================================================

  bool isTestedDateTimeValid(DateTime value) {
    // Must be inside active testing window.
    if (value.isBefore(windowStart)) {
      return false;
    }

    // Cannot be future.
    if (value.isAfter(DateTime.now())) {
      return false;
    }

    // Must be 5 minutes after collection.
    if (minimumTestedDateTime != null &&
        value.isBefore(minimumTestedDateTime!)) {
      return false;
    }

    return true;
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearDates() {
    _collectionDateTime = null;
    _testedDateTime = null;

    notifyListeners();
  }
}