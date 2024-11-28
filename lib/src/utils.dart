import 'dart:math';

double sum(List<double> arr) {
  return arr.reversed.fold<double>(0, (a, b) => a + b);
}

double percentChange(double current, double prev) {
  return ((current - prev) / prev) * 100;
}

double avg(Iterable<double> arr, [int? period]) {
  period = period ?? arr.length;
  return sum(arr.toList()) / period;
}

double getMax(Iterable<double> arr) {
  return arr.reduce(max);
}

double getMin(Iterable<double> arr) {
  return arr.reduce(min);
}

double? getTrueRange(double high, double low, double? prevClose) {
  if (prevClose != null) {
    final hl = high - low;
    final hc = high > prevClose ? high - prevClose : prevClose - high;
    final lc = low > prevClose ? low - prevClose : prevClose - low;

    if (hl >= hc && hl >= lc) {
      return hl;
    }

    if (hc >= hl && hc >= lc) {
      return hc;
    }

    return lc;
  }
  return null;
}


/// cross(x, y)
/// crossunder(x, y)
/// crossover(x, y)
/// highest(source, length)
/// lowest(source, length)
/// 
/// rising(source, length) Test if x series rise along y axis.
/// falling(source, length) Test if x series fall along y axis.
/// 
/// atr(length) ATR (Average True Range) returns the RMA of the true range. The true fluctuation range is max(high-low, abs(high-close[1]), abs(low-close[1]))
/// hma(source, length) Hull Moving Average
/// mom(source, length) Momentum of price x and price x of a given series. This is just the difference between x - x[y].
/// dev(source, length) Deviation between series and sma
/// stdev(source, length) Standard deviation
/// vwma(source, length) Volume weighted moving average. It's the same as: sma(x * volume, y) / sma(volume, y)
/// wma(source, length) Weighted moving average
/// stoch(source, high, low, length) Stochastic indicators. Calculation equation: 100 * (close - lowest(low, length)) / (highest(high, length) - lowest(low, length))
/// alma(series, length, offset, sigma) Arnaud Legoux Moving Average. It uses Gaussian distribution as the weight of the moving average.
/// cci(source, length) CCI (Commodity Path Index) is calculated by dividing the difference between the typical price and its simple moving average by the mean deviation. The index is scaled by an inverse factor of 0.015, to provide more readable value.
/// 
/// rma(source, length) The moving average used in RSI. It is an exponentially weighted moving average line, alpha's weighted value = 1 / length.
