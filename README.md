# PivotCandleScalper Trading Strategy

Complete scalping strategy implementation for MetaTrader 5 and TradingView using daily pivot points and candlestick pattern confirmation.

## 📁 Repository Contents

### Trading Strategy Files
- **PIVOT_CANDLE_SCALPER.mq5** - MetaTrader 5 Expert Advisor (ready to compile)
- **PIVOT_CANDLE_SCALPER.pine** - TradingView Pine Script v5 Strategy

### Documentation
- **STRATEGY_DOCUMENTATION.md** - Complete strategy logic, parameters, and features
- **QUICK_START_GUIDE.md** - Installation and setup instructions
- **XAUUSD15.csv** - Sample historical data

## 🎯 Strategy Overview

PivotCandleScalper is a flexible, universal scalping strategy that:
- ✅ Works on **any symbol** (Forex, Metals, Indices, Crypto)
- ✅ Optimized for **M15 timeframe** (works on any timeframe)
- ✅ Uses **daily pivot points** (PP, R1, R2, S1, S2)
- ✅ Confirms entries with **candlestick patterns** (Pin Bars, Engulfing)
- ✅ Implements **two-tier profit taking** (50% at TP1, 50% at TP2)
- ✅ Includes **risk management** and dynamic position sizing
- ✅ Supports **trading hours restriction** and spread filtering

## 🚀 Quick Start

### For MetaTrader 5
```bash
1. Copy PIVOT_CANDLE_SCALPER.mq5 to MT5/MQL5/Experts/
2. Compile in MetaEditor (F7)
3. Drag onto chart (recommended: XAUUSD M15)
4. Configure parameters
5. Enable AutoTrading
```

### For TradingView
```bash
1. Open Pine Editor
2. Copy content from PIVOT_CANDLE_SCALPER.pine
3. Click "Add to Chart"
4. Configure strategy settings
5. Run backtest
```

## 📊 Key Features

### MQL5 Expert Advisor
- Universal symbol compatibility (auto-detects pip/point values)
- Dynamic lot sizing based on risk percentage
- Spread filtering
- Trading hours restriction
- Comprehensive logging
- No external dependencies

### Pine Script Strategy
- Pine Script v5 compliant
- Visual pivot level display
- Pattern detection indicators
- Market bias background coloring
- Real-time information table
- Alert conditions

## 📈 Strategy Logic

1. **Calculate Daily Pivots** from previous day's High, Low, Close
2. **Determine Market Bias**: Bullish (above PP) or Bearish (below PP)
3. **Wait for Pullback** to key levels (S1, PP, R1)
4. **Confirm with Pattern**:
   - **Bullish**: Pin Bar or Engulfing at S1/PP
   - **Bearish**: Pin Bar or Engulfing at R1/PP
5. **Enter** with market order on signal candle close
6. **Exit** at two profit levels (50% each) with stop loss protection

## ⚙️ Default Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| LotSize | 0.01 | Fixed lot size |
| RiskPercent | 0.5% | Risk per trade |
| StopLossPips | 15 | Stop loss distance |
| TakeProfit1Pips | 20 | First TP (50%) |
| TakeProfit2Pips | 40 | Second TP (50%) |
| MaxSpread | 30 | Max spread in points |
| MagicNumber | 202506 | Order identifier |
| EnableTradingHours | false | Time restriction |

## 📖 Documentation

For detailed information, see:
- **[Strategy Documentation](STRATEGY_DOCUMENTATION.md)** - Complete strategy details
- **[Quick Start Guide](QUICK_START_GUIDE.md)** - Setup and usage instructions

## ⚠️ Risk Disclaimer

This strategy is provided for educational purposes only. Trading carries significant risk of loss. Always test thoroughly on demo account before live trading. Past performance does not guarantee future results.

## 📝 Version

**v1.00** (2025-01-05)
- Initial release with complete MQL5 and Pine Script implementations
- All features tested and ready for compilation

## 📄 License

Copyright 2025, PivotCandleScalper  
Provided as-is without warranty.