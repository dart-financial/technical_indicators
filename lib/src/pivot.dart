part of '../technical_indicators.dart';

/// Pivot points are major support and resistance levels where there likely to be a retracement
/// of price used by traders to objectively determine potential entry and exit levels of underlying assets.
/// Pivot point breaks can be an entry marker, confirmation of trend direction
/// also confirmation of trend reversal -exit marker.
/// These retracement calculation is based on the last day trading data as we follow
/// the market open, high, low, close on every day.
/// You can also calculate these pivot level on weekly basis.
/// For weekly pivot you need to weekly high, low, and close prices.

enum PivotMode { classic, woodie, camarilla, fibonacci }

class PivotValue {
  final num? r6;
  final num? r5;
  final num? r4;
  final num? r3;
  final num r2;
  final num r1;
  final num pp;
  final num s1;
  final num s2;
  final num? s3;
  final num? s4;
  final num? s5;
  final num? s6;

  const PivotValue({
    required this.pp,
    required this.s1,
    required this.s2,
    this.s3,
    this.s4,
    this.s5,
    this.s6,
    required this.r1,
    required this.r2,
    this.r3,
    this.r4,
    this.r5,
    this.r6,
  });
}

typedef Calculator = PivotValue Function(num h, num l, num c);

/// Pivot points are major support and resistance levels where there likely to be a retracement
/// of price used by traders to objectively determine potential entry and exit levels of underlying assets.
/// Pivot point breaks can be an entry marker, confirmation of trend direction
/// also confirmation of trend reversal -exit marker.
/// These retracement calculation is based on the last day trading data as we follow
/// the market open, high, low, close on every day.
/// You can also calculate these pivot level on weekly basis.
/// For weekly pivot you need to weekly high, low, and close prices.
class Pivot {
  final Calculator calculator;

  const Pivot._(this.calculator);

  factory Pivot(PivotMode mode) {
    switch (mode) {
      case PivotMode.classic:
        return Pivot._(classic);
      case PivotMode.camarilla:
        return Pivot._(camarilla);
      case PivotMode.woodie:
        return Pivot._(woodie);
      case PivotMode.fibonacci:
        return Pivot._(fibonacci);
    }
  }

  PivotValue next(num h, num l, num c) {
    return calculator(h, l, c);
  }

  /// Classsic
  /// Pivot Point (P) = (High + Low + Close)/3
  /// Support 1 (S1) = (P x 2) - High
  /// Support 2 (S2) = P  -  (High  -  Low)
  /// Support 3 (S3) = Low – 2(High – PP)
  /// Resistance 1 (R1) = (P x 2) - Low
  /// Resistance 2 (R2) = P + (High  -  Low)
  /// Resistance 3 (R3) = High + 2(PP – Low)
  static PivotValue classic(num h, num l, num c) {
    final double pp = (h + l + c) / 3;

    return PivotValue(
      pp: pp,
      s1: pp * 2 - h,
      s2: pp - (h - l),
      s3: l - 2 * (h - pp),
      r1: pp * 2 - l,
      r2: pp + (h - l),
      r3: h + 2 * (pp - l),
    );
  }

  /// Woodie
  /// R2 = PP + High – Low
  /// R1 = (2 X PP) – Low
  /// PP = (H + L + 2C) / 4
  /// S1 = (2 X PP) – High
  /// S2 = PP – High + Low
  static PivotValue woodie(num h, num l, num c) {
    final double pp = (h + l + 2 * c) / 4;

    return PivotValue(
      pp: pp,
      s1: 2 * pp - h,
      s2: pp - h + l,
      r1: pp + h - l,
      r2: 2 * pp - l,
    );
  }

  /// Camarilla
  /// pivot = (high + low + close ) / 3.0
  /// range = high - low
  /// h5 = (high/low) * close
  /// h4 = close + (high - low) * 1.1 / 2.0
  /// h3 = close + (high - low) * 1.1 / 4.0
  /// h2 = close + (high - low) * 1.1 / 6.0
  /// h1 = close + (high - low) * 1.1 / 12.0
  /// l1 = close - (high - low) * 1.1 / 12.0
  /// l2 = close - (high - low) * 1.1 / 6.0
  /// l3 = close - (high - low) * 1.1 / 4.0
  /// l4 = close - (high - low) * 1.1 / 2.0
  /// h6 = h5 + 1.168 * (h5 - h4)
  /// l5 = close - (h5 - close)
  /// l6 = close - (h6 - close)
  static PivotValue camarilla(num h, num l, num c) {
    final delta = (h - l) * 1.1;

    final r5 = (h / l) * c;
    final r4 = c + delta / 2;
    final r6 = r5 + 1.168 * (r5 - r4);

    return PivotValue(
      r6: r6,
      r5: r5,
      r4: r4,
      r3: c + delta / 4,
      r2: c + delta / 6,
      r1: c + delta / 12,
      pp: (h + l + c) / 3,
      s1: c - delta / 12,
      s2: c - delta / 6,
      s3: c - delta / 4,
      s4: c - delta / 2,
      s5: c - (r5 - c),
      s6: c - (r6 - c),
    );
  }

  /// Fibonacci Pivot Point
  /// R3 = PP + ((High – Low) x 1.000)
  /// R2 = PP + ((High – Low) x .618)
  /// R1 = PP + ((High – Low) x .382)
  /// PP = (H + L + C) / 3
  /// S1 = PP – ((High – Low) x .382)
  /// S2 = PP – ((High – Low) x .618)
  /// S3 = PP – ((High – Low) x 1.000)
  static PivotValue fibonacci(num h, num l, num c) {
    final delta = h - l;
    final pp = (h + l + c) / 3;

    return PivotValue(
      pp: pp,
      r3: pp + delta,
      r2: pp + delta * 0.618,
      r1: pp + delta * 0.382,
      s1: pp - delta * 0.382,
      s2: pp - delta * 0.618,
      s3: pp - delta,
    );
  }
}
