# PivotCandleScalper - Complete Trading Strategy Documentation

## Overview
PivotCandleScalper is a flexible, universal scalping strategy that works on any symbol (forex, metals, indices) and timeframe (optimized for M15). The strategy uses daily pivot points combined with candlestick pattern confirmation to identify high-probability entry points.

## Files Included
1. **PIVOT_CANDLE_SCALPER.mq5** - MetaTrader 5 Expert Advisor
2. **PIVOT_CANDLE_SCALPER.pine** - TradingView Pine Script Strategy

---

## Strategy Logic

### Core Principles
1. **Daily Pivot Points**: Calculate support/resistance levels from previous day's high, low, and close
2. **Market Bias**: Determine bullish/bearish bias based on price position relative to pivot point
3. **Pattern Confirmation**: Use candlestick patterns to confirm reversals at key levels
4. **Risk Management**: Two-tier profit taking (50% at TP1, 50% at TP2)

### Pivot Point Calculations
```
PP = (Previous Day High + Previous Day Low + Previous Day Close) / 3
R1 = 2 * PP - Previous Day Low
R2 = PP + (Previous Day High - Previous Day Low)
S1 = 2 * PP - Previous Day High
S2 = PP - (Previous Day High - Previous Day Low)
```

### Entry Conditions

#### Long (Buy) Entry
- **Market Bias**: Price must be above PP (bullish bias)
- **Price Level**: Price near S1 or PP (within 5 pips tolerance)
- **Pattern Confirmation**: Either:
  - Bullish Pin Bar: Lower wick ≥ 2x body, upper wick ≤ 30% of range
  - Bullish Engulfing: Current bullish candle engulfs previous bearish candle's body

#### Short (Sell) Entry
- **Market Bias**: Price must be below PP (bearish bias)
- **Price Level**: Price near R1 or PP (within 5 pips tolerance)
- **Pattern Confirmation**: Either:
  - Bearish Pin Bar: Upper wick ≥ 2x body, lower wick ≤ 30% of range
  - Bearish Engulfing: Current bearish candle engulfs previous bullish candle's body

### Exit Strategy
- **Stop Loss**: 
  - Long: Below signal candle low minus 2 pips buffer
  - Short: Above signal candle high plus 2 pips buffer
- **Take Profit 1**: Close 50% of position at configured TP1 (default: 20 pips)
- **Take Profit 2**: Close remaining 50% at configured TP2 (default: 40 pips)

---

## Input Parameters

### Position Sizing
- **LotSize** (0.01): Fixed lot size when RiskPercent = 0
- **RiskPercent** (0.5%): Risk per trade as percentage of account balance

### Risk Management
- **StopLossPips** (15): Stop loss distance in pips
- **TakeProfit1Pips** (20): First take profit level (50% close)
- **TakeProfit2Pips** (40): Second take profit level (50% close)
- **MaxSpread** (30 points): Maximum spread allowed for trade entry

### Trading Hours (Optional)
- **EnableTradingHours** (false): Enable time-based trading restriction
- **TradeStartHour** (0-23): Start hour for trading window
- **TradeEndHour** (0-23): End hour for trading window

### Identification
- **MagicNumber** (202506): Unique identifier for EA's trades

---

## MQL5 Expert Advisor (PIVOT_CANDLE_SCALPER.mq5)

### Features
✅ Universal symbol compatibility (works on forex, metals, indices)
✅ Automatic pip/point adjustment based on broker digit configuration
✅ Dynamic lot sizing based on risk percentage
✅ Two-tier profit taking system
✅ Spread filtering
✅ Optional trading hours restriction
✅ Comprehensive logging and debugging
✅ No external indicators or libraries required

### Installation
1. Copy `PIVOT_CANDLE_SCALPER.mq5` to `MetaTrader 5/MQL5/Experts/` folder
2. Compile in MetaEditor (F7) - should compile without errors
3. Restart MetaTrader 5 or refresh Expert Advisors list
4. Drag EA onto desired chart (recommended: M15 timeframe)
5. Configure input parameters as desired
6. Enable AutoTrading button
7. Ensure live trading is permitted in EA settings

### Symbol Compatibility
The EA automatically detects and adapts to:
- **Forex pairs** (EUR/USD, GBP/USD, USD/JPY, etc.)
- **Metals** (XAU/USD, XAG/USD, GOLD, SILVER)
- **Indices** (US30, NAS100, SPX500, etc.)
- **Cryptocurrencies** (BTC/USD, ETH/USD, etc.)
- **4-digit and 5-digit brokers** (automatic detection)

### How It Works
1. Calculates daily pivot points on initialization and every new day
2. Monitors price on every new candle
3. Checks trading conditions (hours, spread, existing positions)
4. Identifies market bias based on PP
5. Detects candlestick patterns at key levels
6. Executes two orders (50% each) with different TPs
7. Manages positions via stop loss and take profit levels

---

## Pine Script Strategy (PIVOT_CANDLE_SCALPER.pine)

### Features
✅ Pine Script v5 compliant
✅ All functions defined in single lines (as required)
✅ Visual pivot level display
✅ Pattern detection indicators
✅ Market bias background coloring
✅ Real-time information table showing pivot levels
✅ Alert conditions for long/short signals
✅ Compatible with TradingView strategy tester

### Installation
1. Open TradingView chart
2. Click "Pine Editor" at bottom of screen
3. Copy entire contents of `PIVOT_CANDLE_SCALPER.pine`
4. Paste into Pine Editor
5. Click "Add to Chart"
6. Configure input parameters in settings

### Visual Indicators
- **Pivot Levels**: Yellow line (PP), Red lines (R1, R2), Green lines (S1, S2)
- **Buy Signals**: Green triangle below bar
- **Sell Signals**: Red triangle above bar
- **Pin Bars**: Diamond shapes (green for bullish, red for bearish)
- **Engulfing**: Circle shapes (blue for bullish, orange for bearish)
- **Market Bias**: Light green/red background shading
- **Info Table**: Top-right corner showing current pivot levels

### Backtesting
1. Add strategy to chart
2. Open "Strategy Tester" tab at bottom
3. Review performance metrics
4. Adjust parameters for optimization
5. Analyze individual trades in "List of Trades"

### Alerts
Configure alerts for:
- Long Signal Alert: Triggers on buy setup
- Short Signal Alert: Triggers on sell setup

---

## Optimization Tips

### Best Timeframes
- **Primary**: M15 (15-minute) - optimal balance
- **Alternative**: M5 (more signals), M30 (fewer signals)

### Best Symbols
- **Forex**: Major pairs (EUR/USD, GBP/USD, USD/JPY)
- **Metals**: XAU/USD (Gold) - excellent volatility
- **Indices**: US30, NAS100 - strong trending behavior

### Parameter Tuning
1. **StopLossPips**: Adjust based on symbol volatility (10-20 for forex, 30-50 for gold)
2. **TakeProfit ratios**: Maintain 1:1.3 to 1:2.5 risk-reward ratio
3. **MaxSpread**: Tighten during volatile market conditions
4. **Trading Hours**: Enable during liquid market hours (London/NY session)

### Risk Management
- Never risk more than 1-2% per trade
- Use RiskPercent for dynamic position sizing
- Monitor drawdown carefully
- Avoid trading during major news events

---

## Key Differences: MQ5 vs Pine Script

| Feature | MQL5 | Pine Script |
|---------|------|-------------|
| **Execution** | Real trading | Backtest/paper |
| **Position Sizing** | Dynamic based on account | Percentage of equity |
| **Spread Checking** | Real-time spread data | Assumed acceptable |
| **Order Management** | Two separate orders | Strategy engine |
| **Logging** | Print statements | Visual on chart |
| **Multi-timeframe** | iTime, iHigh, etc. | request.security |

---

## Troubleshooting

### MQL5 Common Issues
1. **"Not enough money"**: Reduce LotSize or increase RiskPercent
2. **"Invalid stops"**: Broker minimum stop level exceeded, increase StopLossPips
3. **"Trade not allowed"**: Enable AutoTrading, check EA permissions
4. **"Market closed"**: Check trading hours or disable EnableTradingHours
5. **"Invalid volume"**: Check broker's minimum lot size

### Pine Script Common Issues
1. **Strategy not executing**: Ensure barstate.isconfirmed is working
2. **No signals**: Lower tolerance, check if patterns detected
3. **Visual elements missing**: Refresh chart, check plot visibility
4. **Alert not firing**: Configure alert condition after adding to chart

---

## Risk Disclaimer
This strategy is provided for educational purposes only. Past performance does not guarantee future results. Trading carries significant risk of loss. Always test thoroughly on demo account before live trading. Never risk more than you can afford to lose.

---

## Version History
- **v1.00** (2025-01-05): Initial release with complete MQL5 and Pine Script implementations

## License
Copyright 2025, PivotCandleScalper
This code is provided as-is without warranty.

## Support
For questions, improvements, or bug reports, please refer to the repository documentation.
