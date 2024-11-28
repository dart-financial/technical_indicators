part of '../technical_indicators.dart';

/// In stock and securities market technical analysis, parabolic SAR (parabolic stop and reverse)
/// is a method devised by J. Welles Wilder, Jr., to find potential reversals in the market price
/// direction of traded goods such as securities or currency exchanges such as forex It is a
/// trend-following (lagging) indicator and may be used to set a trailing stop loss or determine
/// entry or exit points based on prices tending to stay within a parabolic curve during a strong trend.
///
/// Similar to option theory's concept of time decay, the concept draws on the idea that "time is the enemy".
/// Thus, unless a security can continue to generate more profits over time, it should be liquidated.
/// The indicator generally works only in trending markets, and creates "whipsaws" during ranging or,
/// sideways phases. Therefore, Wilder recommends first establishing the direction or change in direction
/// of the trend through the use of parabolic SAR, and then using a different indicator such as the
/// Average Directional Index to determine the strength of the trend.
///
/// A parabola below the price is generally bullish, while a parabola above is generally bearish.
/// A parabola below the price may be used as support, whereas a parabola above the price may represent resistance.
class PSAR {
  final double start;
  final double acceleration;
  final double max;

  late bool isBullTrend;
  late double result;
  late double low1;
  late double high1;
  late double low2;
  late double high2;
  late double accelerationFactor;
  late double lowest;
  late double highest;

  late double? Function(double high, double low, double close) _next;
  late double? Function(double high, double low) _current;

  PSAR([this.start = 0.02, this.acceleration = 0.02, this.max = 0.2])
      : result = 0,
        isBullTrend = true {
    _next = (high, low, close) {
      result = close;
      low1 = low;
      high1 = high;
      low2 = low;
      high2 = high;
      highest = high;
      lowest = low;
      accelerationFactor = start;

      // Redefine métodos após a inicialização
      _next = _calculateNext;
      _current = _calculateCurrent;

      return low;
    };

    _current = (_, low) => low; // Antes da inicialização, retorna o valor atual mais baixo
  }

  double? next(double high, double low, double close) => _next(high, low, close);

  double? current(double high, double low) => _current(high, low);

  /// Lógica para calcular o próximo PSAR
  double? _calculateNext(double high, double low, double close) {
    final psar = _calculatePsar(high, low);

    _updateTrend(high, low, psar);
    _updateExtremes(high, low);
    _updateHistoricalValues(high, low);

    result = psar;
    return result;
  }

  /// Lógica para calcular o PSAR atual
  double? _calculateCurrent(double high, double low) {
    return _calculatePsar(high, low);
  }

  /// Cálculo centralizado do PSAR
  double _calculatePsar(double high, double low) {
    final adjustment = accelerationFactor * (isBullTrend ? highest - result : lowest - result);
    var psar = result + adjustment;

    if (isBullTrend) {
      psar = low < psar ? highest : _adjustForHistoricalLows(psar);
    } else {
      psar = high > psar ? lowest : _adjustForHistoricalHighs(psar);
    }

    return psar;
  }

  /// Ajusta o PSAR para os mínimos históricos
  double _adjustForHistoricalLows(double psar) {
    if (low1 < psar) psar = low1;
    if (low2 < psar) psar = low2;
    return psar;
  }

  /// Ajusta o PSAR para os máximos históricos
  double _adjustForHistoricalHighs(double psar) {
    if (high1 > psar) psar = high1;
    if (high2 > psar) psar = high2;
    return psar;
  }

  /// Atualiza a tendência de alta/baixa
  void _updateTrend(double high, double low, double psar) {
    if (isBullTrend) {
      if (low < psar) {
        isBullTrend = false;
        lowest = low;
        accelerationFactor = start;
      }
    } else {
      if (high > psar) {
        isBullTrend = true;
        highest = high;
        accelerationFactor = start;
      }
    }
  }

  /// Atualiza os extremos de alta/baixa
  void _updateExtremes(double high, double low) {
    if (isBullTrend) {
      if (high > highest) {
        highest = high;
        accelerationFactor = (accelerationFactor + acceleration).clamp(0, max);
      }
    } else {
      if (low < lowest) {
        lowest = low;
        accelerationFactor = (accelerationFactor + acceleration).clamp(0, max);
      }
    }
  }

  /// Atualiza os valores históricos
  void _updateHistoricalValues(double high, double low) {
    low2 = low1;
    low1 = low;
    high2 = high1;
    high1 = high;
  }
}
