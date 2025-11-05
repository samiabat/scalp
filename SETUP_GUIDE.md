# Visual Setup Guide

## Chart Setup

### Step 1: Add the Expert Advisor to Your Chart

1. Open MetaTrader 4 or 5
2. Navigate to **Navigator** panel (Ctrl+N)
3. Expand **Expert Advisors** section
4. Find **XAUUSD_M15_Scalper**
5. Drag and drop onto the XAU/USD M15 chart

### Step 2: Configure Expert Advisor Settings

When the EA settings window appears, configure the following:

#### Common Tab:
- ✓ Allow live trading
- ✓ Allow DLL imports (if needed)
- ✓ Confirm before trading (optional)

#### Inputs Tab:
```
RiskPercent = 1.0         // Risk 1% per trade
MagicNumber = 123456      // Unique identifier
MinWickBodyRatio = 2.0    // Pin bar sensitivity
Slippage = 3              // MT4 only
```

### Step 3: Recommended Chart Indicators (Optional)

While the EA works standalone, you may want to visualize the pivot levels:

**Add Pivot Points Indicator:**
1. Insert → Indicators → Custom → Pivot Points (Daily)
2. This will display PP, R1, R2, S1, S2 on your chart

**Add Candlestick Pattern Recognition (Optional):**
1. Insert → Indicators → Custom → Candlestick Patterns
2. Helps visualize pin bars and engulfing patterns

### Step 4: Enable Auto Trading

1. Click the **AutoTrading** button in the toolbar (should turn green)
2. Or press Alt+T
3. Verify a smiley face appears in the top-right corner of your chart

## Understanding the Visual Signals

### Pivot Point Levels on Chart

```
R2 ---------------------------------------- (Resistance 2)
    |
R1 ---------------------------------------- (Resistance 1)
    |
PP ========================================= (Pivot Point - TREND LINE)
    |
S1 ---------------------------------------- (Support 1)
    |
S2 ---------------------------------------- (Support 2)
```

### Long Trade Setup Visualization

```
Price Action:

R1 ----------------------------------------
                              📈 (uptrend)
PP ========================================= 
         ⬇️ (pullback)
         |
         v
S1 -----|--🔨------------------------------ (Bullish Pin Bar appears)
         ^
         |
         ENTRY HERE (when candle closes)
         
         SL below pin bar low
         TP1 at R1 (50%)
         TP2 at 2x risk
```

### Short Trade Setup Visualization

```
Price Action:

R1 -----|--💀------------------------------ (Bearish Pin Bar appears)
         ^
         |
         ENTRY HERE (when candle closes)
         ⬇️ (pullback)
PP =========================================
                              📉 (downtrend)
S1 ----------------------------------------

         SL above pin bar high
         TP1 at S1 (50%)
         TP2 at 2x risk
```

## Bullish Pin Bar Pattern

```
     |
     |  ← Upper wick (small)
  |-----|
  |     |  ← Body (small, green)
  |-----|
     |
     |
     |
     |  ← Lower wick (LONG - at least 2x body)
     |
```

**Key Features:**
- Long lower shadow (wick ≥ 2× body)
- Small body near the top
- Shows rejection of lower prices
- Appears in pullback zone (S1-PP for longs)

## Bearish Pin Bar Pattern

```
     |
     |  ← Upper wick (LONG - at least 2x body)
     |
     |
  |-----|
  |     |  ← Body (small, red)
  |-----|
     |  ← Lower wick (small)
     |
```

**Key Features:**
- Long upper shadow (wick ≥ 2× body)
- Small body near the bottom
- Shows rejection of higher prices
- Appears in pullback zone (PP-R1 for shorts)

## Bullish Engulfing Pattern

```
Candle 1    Candle 2
(Previous)  (Signal)

            |-----|
            |     |  ← Larger bullish candle
  |---|     |     |
  | R |     |  G  |
  |---|     |     |
            |-----|

Red candle completely engulfed by green candle
```

## Bearish Engulfing Pattern

```
Candle 1    Candle 2
(Previous)  (Signal)

            |-----|
  |---|     |     |  ← Larger bearish candle
  | G |     |  R  |
  |---|     |     |
            |-----|

Green candle completely engulfed by red candle
```

## Trade Management Flowchart

```
┌─────────────────┐
│  New M15 Candle │
│     Closes      │
└────────┬────────┘
         │
         ▼
   ┌──────────┐
   │ Price vs │
   │   PP?    │
   └─┬──────┬─┘
     │      │
  >PP│      │<PP
     │      │
     ▼      ▼
 ┌───────┐ ┌───────┐
 │ LONG  │ │ SHORT │
 │ ONLY  │ │ ONLY  │
 └───┬───┘ └───┬───┘
     │         │
     ▼         ▼
 ┌─────────────────┐
 │ In Pullback     │
 │ Zone?           │
 └────────┬────────┘
          │
       Yes│
          ▼
 ┌─────────────────┐
 │ Pin Bar or      │
 │ Engulfing?      │
 └────────┬────────┘
          │
       Yes│
          ▼
 ┌─────────────────┐
 │ ENTER TRADE     │
 │ - Set SL        │
 │ - Set TP        │
 └────────┬────────┘
          │
          ▼
 ┌─────────────────┐
 │ Monitor Position│
 │ - 50% at Pivot  │
 │ - 50% at 2R     │
 └─────────────────┘
```

## Expert Advisor Status Indicators

### In MetaTrader Terminal (Bottom Panel)

**Experts Tab Messages:**
```
✅ "XAUUSD M15 Scalper initialized" - EA loaded successfully
✅ "Pivots updated - PP: 1945..." - Daily pivots calculated
✅ "Long position opened at..." - Trade executed
✅ "Partial take profit executed..." - 50% closed at pivot
❌ "Error opening position: ..." - Issue with trade execution
```

### Journal Tab (Common Messages)

```
- "2024.01.15 08:00:00  XAUUSD M15 Scalper initialized"
- "2024.01.15 08:00:01  Pivots updated - PP: 1945.50"
- "2024.01.15 10:30:00  Long position opened at 1947.00"
```

## Parameter Adjustment Guide

### Risk Management Parameters

**RiskPercent:**
- Conservative: 0.5% - 1.0%
- Moderate: 1.0% - 2.0%
- Aggressive: 2.0% - 3.0%
- ⚠️ Not recommended: >3%

**MagicNumber:**
- Keep unique if running multiple EAs
- Default 123456 is fine for single EA

**MinWickBodyRatio:**
- Stricter (fewer signals): 2.5 - 3.0
- Balanced (recommended): 2.0
- Looser (more signals): 1.5 - 2.0

## Troubleshooting Visuals

### EA Not Trading - Checklist

```
☐ AutoTrading enabled? (green button)
☐ Correct symbol? (XAU/USD, XAUUSD, GOLD)
☐ Correct timeframe? (M15)
☐ EA shows smiley face in corner?
☐ Check terminal "Experts" tab for errors
☐ Sufficient account balance?
☐ Broker allows algorithmic trading?
```

### No Signals - Reasons

```
☐ Price not in pullback zone
☐ No valid pin bar or engulfing pattern
☐ Already have open position
☐ Risk/reward ratio not favorable
☐ Stop loss too close to entry
```

## Best Practices

1. **Start on Demo:** Test for at least 2 weeks on demo account
2. **Monitor First Week:** Watch the EA operate to understand behavior
3. **Check Settings:** Verify risk parameters match your risk tolerance
4. **Review Trades:** Analyze each trade to understand why it was taken
5. **Keep Journal:** Note market conditions when trades perform well/poorly

## Additional Resources

For more detailed information, see:
- `README.md` - Installation and basic usage
- `STRATEGY_DOCUMENTATION.md` - Complete strategy explanation
