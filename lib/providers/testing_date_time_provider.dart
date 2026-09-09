import 'package:flutter/foundation.dart';

enum WaterTestingSourceType {
  groundwater,
  surfaceWater,
  household,
  anganwadi,
  storage,
  handpump,
}

class TestingDateTimeProvider extends ChangeNotifier {
  // ============================================================
  // SOURCE TYPE
  // ============================================================

  WaterTestingSourceType _sourceType = WaterTestingSourceType.surfaceWater;

  WaterTestingSourceType get sourceType => _sourceType;

  // ============================================================
  // SELECTED DATE/TIME
  // ============================================================

  DateTime? _collectionDateTime;
  DateTime? _testedDateTime;

  DateTime? get collectionDateTime => _collectionDateTime;

  DateTime? get testedDateTime => _testedDateTime;

  // ============================================================
  // SOURCE TYPE
  // ============================================================

  void setSourceType(WaterTestingSourceType type) {
    if (_sourceType == type) {
      return;
    }

    _sourceType = type;

    print("updated source type is $sourceType");

    // ----------------------------------------------------------
    // STORAGE / HANDPUMP
    // ----------------------------------------------------------
    //
    // Both Collection and Tested Date/Time are automatically
    // fixed to the current DateTime.
    //
    // User cannot change them.
    //
    // No 5-minute gap is required.
    // ----------------------------------------------------------

    if (type == WaterTestingSourceType.storage ||
        type == WaterTestingSourceType.handpump) {
      final now = DateTime.now();

      _collectionDateTime = now;
      _testedDateTime = now;
    } else {
      // --------------------------------------------------------
      // NORMAL SOURCE
      // --------------------------------------------------------
      //
      // Clear old values because the testing window may change.
      // --------------------------------------------------------

      _collectionDateTime = null;
      _testedDateTime = null;
    }

    notifyListeners();
  }

  // ============================================================
  // IS FIXED DATE/TIME SOURCE?
  // ============================================================

  bool get isFixedDateTimeSource {
    return _sourceType == WaterTestingSourceType.storage ||
        _sourceType == WaterTestingSourceType.handpump;
  }

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
  // CURRENT DATE/TIME
  // ============================================================

  DateTime get currentDateTime {
    return DateTime.now();
  }

  // ============================================================
  // TESTING WINDOW START
  // ============================================================

  DateTime get windowStart {
    final now = DateTime.now();

    switch (_sourceType) {
      // --------------------------------------------------------
      // GROUNDWATER
      //
      // H1 = April - September
      // H2 = October - March
      // --------------------------------------------------------

      case WaterTestingSourceType.groundwater:
        if (now.month >= 4 && now.month <= 9) {
          return DateTime(
            now.year,
            4,
            1,
          );
        }

        if (now.month >= 10) {
          return DateTime(
            now.year,
            10,
            1,
          );
        }

        return DateTime(
          now.year - 1,
          10,
          1,
        );

      // --------------------------------------------------------
      // SURFACE WATER
      //
      // Q1 = April - June
      // Q2 = July - September
      // Q3 = October - December
      // Q4 = January - March
      // --------------------------------------------------------

      case WaterTestingSourceType.surfaceWater:
        if (now.month >= 4 && now.month <= 6) {
          return DateTime(
            now.year,
            4,
            1,
          );
        }

        if (now.month >= 7 && now.month <= 9) {
          return DateTime(
            now.year,
            7,
            1,
          );
        }

        if (now.month >= 10 && now.month <= 12) {
          return DateTime(
            now.year,
            10,
            1,
          );
        }

        return DateTime(
          now.year,
          1,
          1,
        );

      // --------------------------------------------------------
      // HOUSEHOLD
      // --------------------------------------------------------

      case WaterTestingSourceType.household:
        return DateTime(
          now.year,
          now.month,
          1,
        );

      // --------------------------------------------------------
      // ANGANWADI
      // --------------------------------------------------------

      case WaterTestingSourceType.anganwadi:
        return DateTime(
          now.year,
          now.month,
          1,
        );

      // --------------------------------------------------------
      // STORAGE
      // --------------------------------------------------------
      //
      // Calendar is not used.
      // Return today just to keep the getter valid.
      // --------------------------------------------------------

      case WaterTestingSourceType.storage:
        return today;

      // --------------------------------------------------------
      // HANDPUMP
      // --------------------------------------------------------

      case WaterTestingSourceType.handpump:
        return today;
    }
  }

  // ============================================================
  // TESTING WINDOW END
  // ============================================================

  DateTime get windowEnd {
    return endOfToday;
  }

  // ============================================================
  // COLLECTION DATE
  // ============================================================

  void setCollectionDateTime(DateTime value) {
    // Storage / Handpump are fixed.
    if (isFixedDateTimeSource) {
      return;
    }

    if (!isCollectionDateTimeValid(value)) {
      return;
    }

    _collectionDateTime = value;

    // Existing tested date must remain at least 5 minutes
    // after collection for normal sources.
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
    // Storage / Handpump are fixed.
    if (isFixedDateTimeSource) {
      return;
    }

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
    // Storage / Handpump have NO 5-minute restriction.
    if (isFixedDateTimeSource) {
      return null;
    }

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
    if (isFixedDateTimeSource) {
      return false;
    }

    if (value.isBefore(windowStart)) {
      return false;
    }

    if (value.isAfter(DateTime.now())) {
      return false;
    }

    return true;
  }

  // ============================================================
  // TESTED VALIDATION
  // ============================================================

  bool isTestedDateTimeValid(DateTime value) {
    if (isFixedDateTimeSource) {
      return false;
    }

    if (value.isBefore(windowStart)) {
      return false;
    }

    if (value.isAfter(DateTime.now())) {
      return false;
    }

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
    // For Storage / Handpump we don't clear because their values
    // are automatically fixed to current DateTime.
    if (isFixedDateTimeSource) {
      final now = DateTime.now();

      _collectionDateTime = now;
      _testedDateTime = now;
    } else {
      _collectionDateTime = null;
      _testedDateTime = null;
    }

    notifyListeners();
  }
}
