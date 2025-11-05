# PivotCandleScalper - Quick Start Guide

## For MetaTrader 5 Users

### Step 1: Installation
```
1. Copy PIVOT_CANDLE_SCALPER.mq5 to: 
   C:\Users\[YourName]\AppData\Roaming\MetaQuotes\Terminal\[ID]\MQL5\Experts\

2. Open MetaEditor (F4 in MT5)
3. Find the file in Navigator
4. Press F7 to compile
5. Check for "0 errors, 0 warnings" message
```

### Step 2: Setup on Chart
```
1. Open MT5
2. Open desired chart (recommended: XAUUSD M15)
3. Drag PIVOT_CANDLE_SCALPER from Navigator to chart
4. Configure parameters:
   - LotSize: 0.01 (or your preference)
   - RiskPercent: 0.5 (or 0 to use fixed lot)
   - StopLossPips: 15 (adjust for symbol volatility)
   - TakeProfit1Pips: 20
   - TakeProfit2Pips: 40
   - MaxSpread: 30
5. Click "OK"
6. Enable "AutoTrading" button (top toolbar)
```

### Step 3: Monitor
```
- Check "Experts" tab for log messages
- View pivot levels on chart (if you add them manually)
- Monitor open positions in "Trade" tab
- Review closed trades in "History" tab
```

---

## For TradingView Users

### Step 1: Add to Chart
```
1. Open TradingView
2. Select symbol (e.g., XAUUSD)
3. Set timeframe to 15 minutes
4. Click "Pine Editor" at bottom
5. Copy all content from PIVOT_CANDLE_SCALPER.pine
6. Paste into editor
7. Click "Add to Chart"
```

### Step 2: Configure Strategy
```
1. Click gear icon on strategy name
2. Adjust parameters:
   - Position Sizing section
   - Risk Management section
   - Trading Hours section
3. Click "OK"
```

### Step 3: Backtest
```
1. Open "Strategy Tester" tab at bottom
2. Review:
   - Net Profit
   - Profit Factor
   - Max Drawdown
   - Win Rate
   - Total Trades
3. Optimize parameters if needed
4. View individual trades in "List of Trades"
```

### Step 4: Set Alerts (Optional)
```
1. Click "..." menu on strategy
2. Select "Add Alert"
3. Choose condition:
   - Long Signal Alert
   - Short Signal Alert
4. Configure notification method
5. Click "Create"
```

---

## Recommended Settings by Symbol

### XAUUSD (Gold)
```
LotSize: 0.01
RiskPercent: 0.5
StopLossPips: 30
TakeProfit1Pips: 40
TakeProfit2Pips: 80
MaxSpread: 30
Timeframe: M15
```

### EURUSD (Forex)
```
LotSize: 0.01
RiskPercent: 0.5
StopLossPips: 15
TakeProfit1Pips: 20
TakeProfit2Pips: 40
MaxSpread: 20
Timeframe: M15
```

### US30 (Dow Jones)
```
LotSize: 0.01
RiskPercent: 0.5
StopLossPips: 25
TakeProfit1Pips: 35
TakeProfit2Pips: 70
MaxSpread: 50
Timeframe: M15
```

---

## Trading Hours Optimization

### London Session (Best for Forex)
```
EnableTradingHours: true
TradeStartHour: 8
TradeEndHour: 17
```

### New York Session (Best for US Indices)
```
EnableTradingHours: true
TradeStartHour: 14
TradeEndHour: 21
```

### Asian Session (Best for JPY pairs, Gold)
```
EnableTradingHours: true
TradeStartHour: 0
TradeEndHour: 8
```

### 24/7 Trading (Default)
```
EnableTradingHours: false
```

---

## Testing Checklist

Before going live:
- [ ] Test on demo account for at least 2 weeks
- [ ] Verify pivot calculations are correct
- [ ] Confirm stop loss and take profit placement
- [ ] Check that only one position opens at a time
- [ ] Verify spread filtering works
- [ ] Test during different market conditions
- [ ] Review all closed trades for accuracy
- [ ] Ensure risk per trade is acceptable
- [ ] Check EA logs for any errors
- [ ] Confirm lot sizing calculation

---

## Key Indicators to Monitor

### On Chart
- Daily pivot lines (PP, R1, R2, S1, S2)
- Price action at key levels
- Candlestick patterns forming
- Market bias (above/below PP)

### In Terminal
- Current spread
- Open positions
- Floating P/L
- Account balance/equity
- Free margin

### Strategy Performance
- Win rate (target: >50%)
- Profit factor (target: >1.5)
- Average win vs average loss
- Maximum drawdown
- Recovery factor

---

## Common Questions

**Q: Why is the EA not opening trades?**
A: Check: spread > MaxSpread, outside trading hours, position already open, no valid pattern detected

**Q: Can I use this on multiple charts?**
A: Yes, but use different MagicNumber for each chart to avoid conflicts

**Q: How do I adjust for different brokers?**
A: EA automatically adjusts for 4-digit vs 5-digit brokers, no changes needed

**Q: What's the minimum account balance?**
A: Depends on broker, but recommend at least $100 for 0.01 lot size

**Q: Can I modify take profit levels after trade opens?**
A: Yes, but EA won't manage modified positions automatically

---

## Performance Expectations

### Realistic Goals
- Win Rate: 50-65%
- Profit Factor: 1.5-2.5
- Average Risk:Reward: 1:1.5 to 1:2
- Monthly Return: 5-15% (depending on risk)
- Max Drawdown: 10-20%

### Trade Frequency
- M15 timeframe: 2-5 trades per day (depending on market)
- More trades during trending markets
- Fewer trades during low volatility periods

---

## Support & Updates

For issues or questions:
1. Check STRATEGY_DOCUMENTATION.md for detailed information
2. Review MQL5 code comments for implementation details
3. Test changes on demo account first
4. Keep track of performance metrics

**Remember**: Always test thoroughly before live trading!
