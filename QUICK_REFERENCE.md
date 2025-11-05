# Quick Reference Guide - XAU/USD M15 Scalper

## Strategy At-a-Glance

| Component | Description |
|-----------|-------------|
| **Symbol** | XAU/USD (Gold) |
| **Timeframe** | M15 (15 minutes) |
| **Strategy Type** | Scalping with pivot points |
| **Risk/Reward** | 2:1 (with partial TP at 1:1) |

## Setup Checklist

- [ ] Install EA in MT4/MT5 Experts folder
- [ ] Compile in MetaEditor (F7)
- [ ] Open XAU/USD chart
- [ ] Set timeframe to M15
- [ ] Drag EA onto chart
- [ ] Enable AutoTrading
- [ ] Verify settings (Risk%, Magic#, etc.)
- [ ] Test on demo first!

## Entry Rules - LONG

✅ **Must have ALL:**
1. Price > Pivot Point (PP)
2. Price pulled back to S1-PP zone
3. Bullish pin bar OR bullish engulfing
4. No existing position open

📈 **Entry:** Market buy when signal candle closes
🛑 **Stop Loss:** Below signal candle low
🎯 **Take Profit:** 50% at R1, 50% at 2× risk

## Entry Rules - SHORT

✅ **Must have ALL:**
1. Price < Pivot Point (PP)
2. Price pulled back to PP-R1 zone
3. Bearish pin bar OR bearish engulfing
4. No existing position open

📉 **Entry:** Market sell when signal candle closes
🛑 **Stop Loss:** Above signal candle high
🎯 **Take Profit:** 50% at S1, 50% at 2× risk

## Candlestick Patterns

### Bullish Pin Bar
```
Wick ≥ 2× body, long lower wick, close > open
```

### Bearish Pin Bar
```
Wick ≥ 2× body, long upper wick, close < open
```

### Bullish Engulfing
```
Bearish candle followed by larger bullish candle
```

### Bearish Engulfing
```
Bullish candle followed by larger bearish candle
```

## Pivot Point Formulas

```
PP = (H + L + C) / 3
R1 = (2 × PP) - L
R2 = PP + (H - L)
S1 = (2 × PP) - H
S2 = PP - (H - L)
```

Where H, L, C = Previous day's High, Low, Close

## Input Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| RiskPercent | 1.0 | Risk per trade (% of balance) |
| MagicNumber | 123456 | EA identifier |
| MinWickBodyRatio | 2.0 | Pin bar sensitivity |
| Slippage (MT4) | 3 | Max slippage in points |

## Risk Management

- **Default risk:** 1% per trade
- **One position at a time**
- **No martingale or grid**
- **Position sizing:** Auto-calculated based on SL distance
- **Daily pivot update:** Automatic at day change

## Common Issues & Solutions

| Problem | Solution |
|---------|----------|
| EA not trading | Check AutoTrading is ON (green) |
| No signals | Wait for pullback to zone + pattern |
| Trades not opening | Check account balance & margin |
| Wrong symbol | Verify chart is XAU/USD or XAUUSD |
| Wrong timeframe | Must be M15 (15 minutes) |

## Performance Tips

✅ **Do:**
- Start on demo account
- Monitor during London/New York sessions
- Check news calendar (avoid major events)
- Keep risk at 1-2% maximum
- Review trades weekly

❌ **Avoid:**
- Trading during major news releases
- Increasing risk after losses
- Manually interfering with EA trades
- Running on wrong timeframe
- Multiple EAs with same magic number

## Expected Behavior

**Good Market Conditions:**
- 2-5 signals per week
- Win rate: 50-65%
- Average R:R: 1.5-2.0

**Poor Market Conditions:**
- Choppy/ranging markets
- Low liquidity periods
- Extreme volatility
- News-driven spikes

## Trade Example

**Long Setup:**
```
Date: 2024-01-15
PP: 1945.00, R1: 1950.00, S1: 1940.00
Price: 1942.50 (below PP, waiting...)
Price: 1943.00 (pullback to S1-PP zone)
Signal: Bullish pin bar at 1943.00, low 1941.50
Entry: 1943.50 (market)
SL: 1941.00 (below low)
Risk: 2.5 points
TP1: 1950.00 at R1 (50% position)
TP2: 1948.50 (2R = 5 points)
```

## Files in Repository

| File | Purpose |
|------|---------|
| `XAUUSD_M15_Scalper.mq5` | MetaTrader 5 Expert Advisor |
| `XAUUSD_M15_Scalper.mq4` | MetaTrader 4 Expert Advisor |
| `README.md` | Main documentation |
| `STRATEGY_DOCUMENTATION.md` | Detailed strategy guide |
| `SETUP_GUIDE.md` | Visual setup instructions |
| `QUICK_REFERENCE.md` | This file |

## Support & Resources

- **Test Period:** Minimum 2 weeks on demo
- **Recommended Capital:** $1,000+ for live trading
- **Recommended Broker:** ECN/STP with low spreads on gold
- **Backtesting:** Use at least 6 months of tick data

## Version History

- **v1.00** - Initial release
  - Daily pivot calculations
  - Pin bar and engulfing detection
  - Partial take profit management
  - MT4 and MT5 versions

---

**⚠️ Risk Warning:** Trading involves substantial risk. Only trade with money you can afford to lose. Past performance does not guarantee future results.
