![pub.dev](https://img.shields.io/pub/v/technical_indicators)
![pub points](https://img.shields.io/pub/points/technical_indicators)
![license](https://img.shields.io/github/license/dart-financial/technical_indicators)

# Streaming Technical Indicators for Dart

## High performance indicators for trading applications

The **technical_indicators** library provides high-performance technical analysis indicators, designed for real-time and historical data analysis in Dart. It simplifies indicator usage with a consistent API and supports efficient calculations with minimal state.

## Features

- **High performance**: Optimized for streaming candle data.
- **Easy to use**: Works seamlessly with real-time or historical data.
- **Minimal state**: Efficient memory usage for calculations.
- **Real-time calculations**: Supports both closed candle and tick-based calculations.
- **Unit tested**: Cross-validated against well-known implementations.

## Available Indicators

- **Momentum Indicators**:
  - Accelerator Oscillator (AO)
  - Awesome Oscillator (AC)
  - Chaikin Oscillator
  - Commodity Channel Index (CCI)
  - Connors RSI (CRSI)
  - Moving Average Convergence Divergence (MACD)
  - Rate of Change (ROC)
  - Relative Strength Index (RSI)
  - Stochastic Oscillator
  - Stochastic RSI (StochRSI)
- **Trend Indicators**:
  - Average Directional Index (ADX)
  - Average True Range (ATR)
  - Bollinger Bands
  - Donchian Channels
  - SuperTrend
  - Parabolic Stop And Reverse (PSAR)
- **Moving Averages**:
  - Adaptive Moving Average (AMA)
  - Exponential Moving Average (EMA)
  - Exponentially Weighted Moving Average (EWMA)
  - Linearly Weighted Moving Average (LWMA)
  - Simple Moving Average (SMA)
  - Smoothed Moving Average (SMMA)
  - Wilder's Smoothed Moving Average (WEMA)
  - Relative Moving Average (RMA)
- **Candlestick Analysis**:
  - Heiken Ashi

## How it Works

### `next`

The `next` method calculates the indicator's value using closed candle data. This affects the indicator's internal state and all subsequent calculations.

### `current`

The `current` method calculates the indicator's momentary value for tick data. This does not alter the internal state, making it useful for real-time updates.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  technical_indicators: ^1.0.0
```

Install it with:

```bash
dart pub get
```

## Example Usage

### Simple Moving Average (SMA)

```dart
import 'package:technical_indicators/technical_indicators.dart';

void main() {
  final sma = SMA(4); // Create an SMA with a 4-period window

  // Add values to the SMA
  print(sma.next(1)); // null
  print(sma.next(2)); // null
  print(sma.next(3)); // null
  print(sma.next(4)); // 2.5
  print(sma.next(5)); // 3.5
  print(sma.next(6)); // 4.5

  // Calculate the momentary value
  print(sma.current(7)); // 5.5
}
```

### Relative Strength Index (RSI)

```dart
import 'package:technical_indicators/technical_indicators.dart';

void main() {
  final rsi = RSI(14);

  // Add close prices to the RSI
  print(rsi.next(44.34)); // null
  print(rsi.next(44.09)); // null
  print(rsi.next(44.15)); // null
  print(rsi.next(43.61)); // RSI value
}
```

### SuperTrend

```dart
import 'package:technical_indicators/technical_indicators.dart';

void main() {
  final superTrend = SuperTrend(10, 3.0);

  print(superTrend.next(45.0, 42.0, 43.5)); // Upper/Lower bands
  print(superTrend.current(46.0, 44.0, 45.0)); // Momentary value
}
```

## Acknowledgment

This library is inspired by the [@debut/indicators](https://github.com/debut-js/Indicators) library in TypeScript. The Dart implementation adapts its concepts to provide a seamless experience in Dart-based applications.

---

For more examples and documentation, visit [technical_indicators documentation](https://pub.dev/packages/technical_indicators).
