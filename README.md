# XAU/USD M15 Scalping Expert Advisor

A professional MetaTrader 5 Expert Advisor for scalping XAU/USD (Gold) on the M15 timeframe using daily pivot points and candlestick patterns.

## Features

### 1. Daily Pivot Points
- Automatically calculates daily pivot points (PP, R1, R2, S1, S2) from previous day's High, Low, and Close
- Pivots are updated at the start of each new trading day

### 2. Trend Filter
- **Long trades only**: When price is above the Pivot Point (PP)
- **Short trades only**: When price is below the Pivot Point (PP)

### 3. Pullback Zone Entry
- **Long setups**: Wait for price to pull back to S1/PP zone
- **Short setups**: Wait for price to pull back to R1/PP zone

### 4. Signal Confirmation
Requires one of the following candlestick patterns:
- **Pin Bar**: Wick must be at least 2× the body size
  - Bullish pin bar: Long lower wick with close near high
  - Bearish pin bar: Long upper wick with close near low
- **Engulfing Pattern**: Current candle completely engulfs the previous candle
  - Bullish engulfing: Bearish candle followed by larger bullish candle
  - Bearish engulfing: Bullish candle followed by larger bearish candle

### 5. Entry Execution
- Market order executed on candle close
- Enters immediately when all conditions are met

### 6. Stop Loss (SL)
- **Long trades**: Placed below the signal candle's low
- **Short trades**: Placed above the signal candle's high

### 7. Take Profit (TP)
- Primary TP: 2× risk reward ratio
- Note: For partial profit taking (50% at next pivot level), manual monitoring is recommended or additional trade management can be implemented

## Installation

1. Copy `XAUUSD_M15_Scalper.mq5` to your MetaTrader 5 installation directory:
   ```
   C:\Program Files\MetaTrader 5\MQL5\Experts\
   ```
   Or through MetaTrader:
   ```
   File → Open Data Folder → MQL5 → Experts
   ```

2. Compile the Expert Advisor in MetaEditor (F7) or it will auto-compile when you drag it to a chart

3. Attach to XAU/USD M15 chart

## Configuration Parameters

- **RiskPercent** (default: 1.0): Percentage of account balance to risk per trade
- **MagicNumber** (default: 123456): Unique identifier for this EA's trades
- **MinWickBodyRatio** (default: 2.0): Minimum ratio of wick to body for pin bar detection

## Usage Instructions

1. Open MetaTrader 5
2. Navigate to XAU/USD symbol
3. Set timeframe to M15 (15 minutes)
4. Drag the Expert Advisor onto the chart
5. Enable AutoTrading (check "Allow Algo Trading" in options)
6. Adjust input parameters as needed
7. Click OK to start trading

## Trading Logic Flow

```
1. Check if new M15 candle has closed
2. Update daily pivot points if new day
3. Skip if position already open
4. Determine trend: Price > PP (long) or Price < PP (short)
5. Check if price is in pullback zone
6. Confirm with pin bar or engulfing pattern
7. Calculate position size based on risk percentage
8. Place market order with SL and TP
```

## Risk Warning

Trading foreign exchange and gold carries a high level of risk and may not be suitable for all investors. Past performance is not indicative of future results. Always ensure you understand the risks and manage your capital appropriately.

## System Requirements

- MetaTrader 5 build 3000+
- Account with XAU/USD trading enabled
- Sufficient margin for position sizing

## License

This Expert Advisor is provided as-is for educational and trading purposes.