const {
  SMA,
  EMA,
  RSI,
  BollingerBands,
  MACD,
  ATR,
  WEMA,
  WMA,
  Stochastic,
  StochasticRSI,
  ROC,
  LWMA,
  ADX,
  PSAR,
  ChaikinOscillator,
  AC,
  AO,
  CCI,
  DC,
  EWMA,
  HeikenAshi,
  Move,
  Pivot,
  RMA,
  SMMA,
  SuperTrend,
  WWS,
  Wave,
  cRSI,
} = require("@debut/indicators");

// const ti = require("technicalindicators");

const fs = require("fs");
const ohlcv = require("../ohlcv.json"); // Assumindo que você tem um arquivo JSON com dados OHLCV

function calculateIndicators(data) {
  const indicators = {
    // ac: new AC(),
    adx: new ADX(14),
    // ao: new AO(5, 34),
    // atr: new ATR(14),
    // bollingerBands: new BollingerBands(20, 2),
    // cci: new CCI(20),
    // chaikin: new ChaikinOscillator(3, 10),
    // // TODO: cr
    crsi: new cRSI(),
    // dc: new DC(20),
    // // TODO: dma
    // // TODO: dmi
    // ema: new EMA(14),
    // // TODO: emv
    // ewma: new EWMA(0.1),
    // heikenAshi: new HeikenAshi(),
    // // TODO: kc
    // lwma: new LWMA(14),
    // macd: new MACD(12, 26, 9),
    // move: new Move(14),
    // // TODO: obv
    // pivot: new Pivot(),
    // psar: new PSAR(0.02, 0.2),
    // // TODO: psy
    // rma: new RMA(14),
    // roc: new ROC(10),
    // rsi: new RSI(14),
    // // sma2: new ti.SMA({ period: 14, values: [] }),
    // sma: new SMA(14),
    // smma: new SMMA(14),
    // stochastic: new Stochastic(14, 3, 3),
    // stochasticRSI: new StochasticRSI(14, 14, 3, 3),
    // supertrend: new SuperTrend(14, 3, "SMA"),
    // // TODO: trix
    // // TODO: vr
    // wave: new Wave(),
    // wema: new WEMA(14),
    // // TODO: wr: new WilliamsR(),
    // wma: new WMA(14),
    // wws: new WWS(14),
  };
  /** @type {Record<string, any[]>} */
  const values = {};
  for (const indicator of Object.keys(indicators)) {
    values[indicator] = [];
  }

  for (const point of data) {
    const { o, h, l, c, v } = point;
    for (const name in indicators) {
      switch (name) {
        case "heikenAshi":
          values[name].push(indicators[name].nextValue(o, h, l, c));
          break;
        case "pivot":
          values[name].push(indicators[name].nextValue(h, l, c));
          break;
        case "supertrend":
        case "dc":
        case "atr":
        case "adx":
          values[name].push(indicators[name].nextValue(h, l, c));
          break;
        case "ao":
        case "cci":
        case "ac":
        case "chaikin":
          values[name].push(indicators[name].nextValue(h, l, c, v));
          break;
        case "crsi":
          const current = indicators[name].momentValue(c);
          values[name].push(indicators[name].nextValue(c) || current);
          break;
        default:
          values[name].push(indicators[name].nextValue(c));
      }
    }
  }

  // Saving results to JSON files
  for (const [name, data] of Object.entries(values)) {
    fs.writeFileSync(
      `../data/${name}_values.json`,
      JSON.stringify(data, null, 2)
    );
  }
}

calculateIndicators(ohlcv);
