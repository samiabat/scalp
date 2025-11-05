# XAU/USD M15 Scalping Strategy Documentation

## Strategy Overview

This is a systematic scalping strategy for XAU/USD (Gold) on the 15-minute timeframe that combines daily pivot point analysis with candlestick pattern recognition.

## Core Components

### 1. Daily Pivot Points

The strategy uses classical pivot points calculated from the previous day's price action:

**Calculation:**
- **Pivot Point (PP)** = (Previous High + Previous Low + Previous Close) / 3
- **Resistance 1 (R1)** = (2 × PP) - Previous Low
- **Resistance 2 (R2)** = PP + (Previous High - Previous Low)
- **Support 1 (S1)** = (2 × PP) - Previous High
- **Support 2 (S2)** = PP - (Previous High - Previous Low)

**Purpose:** These levels act as potential support and resistance zones where price tends to react.

### 2. Trend Filter

The pivot point acts as a trend filter:

- **Price > PP**: Market is in an uptrend → Only look for LONG trades
- **Price < PP**: Market is in a downtrend → Only look for SHORT trades

**Rationale:** Trading with the trend increases probability of success.

### 3. Pullback Zones

Instead of chasing the market, we wait for pullbacks to key levels:

**For Long Trades:**
- Wait for price to pull back into the zone between S1 and PP
- This represents a buying opportunity in an uptrend

**For Short Trades:**
- Wait for price to pull back into the zone between PP and R1
- This represents a selling opportunity in a downtrend

**Rationale:** Entering on pullbacks provides better risk/reward ratios.

### 4. Signal Confirmation

Two candlestick patterns are used to confirm entry:

#### Pin Bar (Hammer/Shooting Star)
**Requirements:**
- Wick must be at least 2× the body size
- **Bullish Pin Bar**: Long lower wick, close near high, bullish candle
- **Bearish Pin Bar**: Long upper wick, close near low, bearish candle

**Psychology:** Pin bars show rejection of a price level and potential reversal.

#### Engulfing Pattern
**Requirements:**
- **Bullish Engulfing**: Bearish candle followed by larger bullish candle that completely engulfs it
- **Bearish Engulfing**: Bullish candle followed by larger bearish candle that completely engulfs it

**Psychology:** Engulfing patterns show strong momentum shift and conviction.

### 5. Entry Execution

**Timing:** Enter at market price when the signal candle closes and all conditions are met.

**Order Type:** Market order (immediate execution)

**Rationale:** M15 timeframe provides enough time to execute without significant slippage.

### 6. Stop Loss Placement

**For Long Trades:** Place SL below the low of the signal candle

**For Short Trades:** Place SL above the high of the signal candle

**Rationale:** If price breaks the signal candle's extreme, the setup is invalidated.

### 7. Take Profit Strategy

The strategy uses a two-tier take profit approach:

**First Target (50% of position):**
- Long trades: Close 50% when price reaches R1
- Short trades: Close 50% when price reaches S1

**Second Target (remaining 50%):**
- Close at 2× risk reward ratio (2R)

**Example for Long Trade:**
- Entry: 1950
- SL: 1945 (5 points risk)
- First TP at R1: e.g., 1955 (5 points = 1R)
- Final TP: 1960 (10 points = 2R)

**Rationale:** Taking partial profits at pivot levels locks in gains while letting the rest run for larger profits.

## Trade Flow Example

### Long Trade Scenario

1. **Market Context:** Price is at 1948, PP is at 1945, S1 is at 1940
2. **Trend Check:** Price (1948) > PP (1945) ✓ → Long only
3. **Pullback:** Price pulls back to 1946 (between S1 and PP) ✓
4. **Signal:** A bullish pin bar forms with low at 1945, close at 1947
5. **Entry:** Market buy at 1947 when candle closes
6. **SL:** 1944.5 (below pin bar low at 1945)
7. **Risk:** 1947 - 1944.5 = 2.5 points
8. **First TP:** R1 at 1952 (close 50% of position)
9. **Final TP:** 1952 (2R = 1947 + 5 points)

### Short Trade Scenario

1. **Market Context:** Price is at 1942, PP is at 1945, R1 is at 1950
2. **Trend Check:** Price (1942) < PP (1945) ✓ → Short only
3. **Pullback:** Price rallies to 1944 (between PP and R1) ✓
4. **Signal:** A bearish engulfing pattern forms with high at 1945
5. **Entry:** Market sell at 1943 when candle closes
6. **SL:** 1945.5 (above engulfing high at 1945)
7. **Risk:** 1945.5 - 1943 = 2.5 points
8. **First TP:** S1 at 1938 (close 50% of position)
9. **Final TP:** 1938 (2R = 1943 - 5 points)

## Position Sizing

The EA uses percentage-based risk management:

**Formula:**
```
Lot Size = (Account Balance × Risk%) / (Stop Loss Distance in Points × Point Value)
```

**Default:** Risk 1% of account balance per trade

**Example:**
- Account: $10,000
- Risk per trade: 1% = $100
- Stop loss: 5 points
- Point value for gold: $1 per point per standard lot
- Position size: $100 / (5 × $1) = 20 micro lots (0.20 lots)

## Risk Management Rules

1. **Single Position:** Only one position open at a time
2. **Risk Per Trade:** Default 1% (adjustable)
3. **No Martingale:** Each trade is independent
4. **Daily Pivot Update:** Pivots recalculate daily, no trades during calculation
5. **New Bar Entry:** Only enter on confirmed candle close

## Market Conditions

**Best Performance:**
- Trending markets with clear pullbacks
- Active trading sessions (London/New York)
- Normal volatility conditions

**Avoid:**
- Major news events (NFP, FOMC, etc.)
- Holidays with low liquidity
- Extreme volatility spikes

## Optimization Tips

1. **Time Filter:** Consider adding session filters (e.g., avoid Asian session)
2. **News Filter:** Disable trading 30 minutes before/after major news
3. **Volatility Filter:** Use ATR to avoid choppy markets
4. **Maximum Daily Trades:** Limit to 2-3 trades per day
5. **Maximum Daily Loss:** Stop trading after -3% daily loss

## Backtesting Recommendations

**Timeframe:** At least 6 months of historical data

**Quality:** Use tick data or high-quality M1 data

**Metrics to Track:**
- Win rate
- Average R:R ratio
- Maximum drawdown
- Profit factor
- Average trade duration

## Advanced Enhancements

Potential additions for experienced traders:

1. **Multiple Timeframe Confirmation:** Check H1 trend alignment
2. **Volume Profile:** Add volume analysis at pivot levels
3. **Fibonacci Retracements:** Combine with 38.2% or 61.8% levels
4. **Trailing Stop:** Move SL to breakeven after first TP hit
5. **Time-Based Exit:** Close position if no movement after X bars

## Disclaimer

This strategy is provided for educational purposes. Past performance does not guarantee future results. Always test thoroughly on a demo account before live trading. Consider market conditions, spreads, and commissions in your analysis.
