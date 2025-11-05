//+------------------------------------------------------------------+
//|                                          XAUUSD_M15_Scalper.mq5 |
//|                                     XAU/USD M15 Scalping Expert |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Trading Expert"
#property link      ""
#property version   "1.00"
#property strict

// Input parameters
input double RiskPercent = 1.0;           // Risk per trade (%)
input int MagicNumber = 123456;           // Magic number
input double MinWickBodyRatio = 2.0;      // Minimum wick to body ratio for pin bars

// Global variables
double PP, R1, R2, S1, S2;                // Pivot points
datetime lastCalculationDate = 0;         // Last pivot calculation date
bool newBar = false;                      // New bar flag

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("XAUUSD M15 Scalper initialized");
   CalculatePivots();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("XAUUSD M15 Scalper stopped");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check for new bar
   static datetime lastBarTime = 0;
   datetime currentBarTime = iTime(_Symbol, PERIOD_M15, 0);
   
   if(currentBarTime != lastBarTime)
   {
      newBar = true;
      lastBarTime = currentBarTime;
   }
   else
   {
      newBar = false;
   }
   
   // Update pivots daily
   datetime currentDate = iTime(_Symbol, PERIOD_D1, 0);
   if(currentDate != lastCalculationDate)
   {
      CalculatePivots();
      lastCalculationDate = currentDate;
   }
   
   // Only trade on new bar close
   if(!newBar) return;
   
   // Check if we already have an open position
   if(HasOpenPosition()) return;
   
   // Get current price
   double close = iClose(_Symbol, PERIOD_M15, 1);
   
   // Determine trend direction
   bool longTrend = close > PP;
   bool shortTrend = close < PP;
   
   // Check for trading signals
   if(longTrend)
   {
      // Long signal conditions
      if(IsInPullbackZone(true))
      {
         if(IsBullishPinBar(1) || IsBullishEngulfing(1))
         {
            OpenLongPosition();
         }
      }
   }
   else if(shortTrend)
   {
      // Short signal conditions
      if(IsInPullbackZone(false))
      {
         if(IsBearishPinBar(1) || IsBearishEngulfing(1))
         {
            OpenShortPosition();
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Calculate daily pivot points                                     |
//+------------------------------------------------------------------+
void CalculatePivots()
{
   // Get previous day's HLC
   double prevHigh = iHigh(_Symbol, PERIOD_D1, 1);
   double prevLow = iLow(_Symbol, PERIOD_D1, 1);
   double prevClose = iClose(_Symbol, PERIOD_D1, 1);
   
   // Calculate pivot point
   PP = (prevHigh + prevLow + prevClose) / 3.0;
   
   // Calculate resistance levels
   R1 = 2.0 * PP - prevLow;
   R2 = PP + (prevHigh - prevLow);
   
   // Calculate support levels
   S1 = 2.0 * PP - prevHigh;
   S2 = PP - (prevHigh - prevLow);
   
   Print("Pivots updated - PP: ", PP, " R1: ", R1, " R2: ", R2, " S1: ", S1, " S2: ", S2);
}

//+------------------------------------------------------------------+
//| Check if price is in pullback zone                              |
//+------------------------------------------------------------------+
bool IsInPullbackZone(bool isLong)
{
   double low = iLow(_Symbol, PERIOD_M15, 1);
   double high = iHigh(_Symbol, PERIOD_M15, 1);
   
   if(isLong)
   {
      // For long: check if price touched S1 or PP from below
      return (low <= PP && low >= S1);
   }
   else
   {
      // For short: check if price touched R1 or PP from above
      return (high >= PP && high <= R1);
   }
}

//+------------------------------------------------------------------+
//| Check for bullish pin bar                                        |
//+------------------------------------------------------------------+
bool IsBullishPinBar(int shift)
{
   double open = iOpen(_Symbol, PERIOD_M15, shift);
   double close = iClose(_Symbol, PERIOD_M15, shift);
   double high = iHigh(_Symbol, PERIOD_M15, shift);
   double low = iLow(_Symbol, PERIOD_M15, shift);
   
   double body = MathAbs(close - open);
   double lowerWick = MathMin(open, close) - low;
   double upperWick = high - MathMax(open, close);
   
   // Bullish pin bar: long lower wick, small body, close near high
   if(body > 0 && lowerWick >= MinWickBodyRatio * body && close > open)
   {
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Check for bearish pin bar                                        |
//+------------------------------------------------------------------+
bool IsBearishPinBar(int shift)
{
   double open = iOpen(_Symbol, PERIOD_M15, shift);
   double close = iClose(_Symbol, PERIOD_M15, shift);
   double high = iHigh(_Symbol, PERIOD_M15, shift);
   double low = iLow(_Symbol, PERIOD_M15, shift);
   
   double body = MathAbs(close - open);
   double upperWick = high - MathMax(open, close);
   double lowerWick = MathMin(open, close) - low;
   
   // Bearish pin bar: long upper wick, small body, close near low
   if(body > 0 && upperWick >= MinWickBodyRatio * body && close < open)
   {
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Check for bullish engulfing pattern                             |
//+------------------------------------------------------------------+
bool IsBullishEngulfing(int shift)
{
   if(shift < 1) return false;
   
   double open1 = iOpen(_Symbol, PERIOD_M15, shift + 1);
   double close1 = iClose(_Symbol, PERIOD_M15, shift + 1);
   double open2 = iOpen(_Symbol, PERIOD_M15, shift);
   double close2 = iClose(_Symbol, PERIOD_M15, shift);
   
   // Previous candle is bearish, current is bullish and engulfs previous
   if(close1 < open1 && close2 > open2 && open2 < close1 && close2 > open1)
   {
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Check for bearish engulfing pattern                             |
//+------------------------------------------------------------------+
bool IsBearishEngulfing(int shift)
{
   if(shift < 1) return false;
   
   double open1 = iOpen(_Symbol, PERIOD_M15, shift + 1);
   double close1 = iClose(_Symbol, PERIOD_M15, shift + 1);
   double open2 = iOpen(_Symbol, PERIOD_M15, shift);
   double close2 = iClose(_Symbol, PERIOD_M15, shift);
   
   // Previous candle is bullish, current is bearish and engulfs previous
   if(close1 > open1 && close2 < open2 && open2 > close1 && close2 < open1)
   {
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Check if there is an open position                              |
//+------------------------------------------------------------------+
bool HasOpenPosition()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol && 
            PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            return true;
         }
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| Open long position                                               |
//+------------------------------------------------------------------+
void OpenLongPosition()
{
   double low = iLow(_Symbol, PERIOD_M15, 1);
   double close = iClose(_Symbol, PERIOD_M15, 1);
   
   // Entry at current ask price
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   
   // Stop loss below signal candle low
   double sl = low;
   
   // Calculate risk in price
   double risk = ask - sl;
   if(risk <= 0) return;
   
   // First target: next pivot (R1)
   double tp1 = R1;
   
   // Second target: 2x risk
   double tp2 = ask + (2.0 * risk);
   
   // Use the farther target
   double tp = tp2;
   
   // Calculate lot size based on risk
   double lotSize = CalculateLotSize(risk);
   if(lotSize <= 0) return;
   
   // Place order
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.type = ORDER_TYPE_BUY;
   request.price = ask;
   request.sl = sl;
   request.tp = tp;
   request.magic = MagicNumber;
   request.comment = "Long Scalp";
   
   if(OrderSend(request, result))
   {
      Print("Long position opened at ", ask, " SL: ", sl, " TP: ", tp);
   }
   else
   {
      Print("Error opening long position: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Open short position                                              |
//+------------------------------------------------------------------+
void OpenShortPosition()
{
   double high = iHigh(_Symbol, PERIOD_M15, 1);
   double close = iClose(_Symbol, PERIOD_M15, 1);
   
   // Entry at current bid price
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   // Stop loss above signal candle high
   double sl = high;
   
   // Calculate risk in price
   double risk = sl - bid;
   if(risk <= 0) return;
   
   // First target: next pivot (S1)
   double tp1 = S1;
   
   // Second target: 2x risk
   double tp2 = bid - (2.0 * risk);
   
   // Use the farther target
   double tp = tp2;
   
   // Calculate lot size based on risk
   double lotSize = CalculateLotSize(risk);
   if(lotSize <= 0) return;
   
   // Place order
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.type = ORDER_TYPE_SELL;
   request.price = bid;
   request.sl = sl;
   request.tp = tp;
   request.magic = MagicNumber;
   request.comment = "Short Scalp";
   
   if(OrderSend(request, result))
   {
      Print("Short position opened at ", bid, " SL: ", sl, " TP: ", tp);
      
      // Note: For partial close at 50% at next pivot, this would need to be managed
      // separately with a trade management function in OnTick checking distance to R1/S1
   }
   else
   {
      Print("Error opening short position: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                |
//+------------------------------------------------------------------+
double CalculateLotSize(double riskInPrice)
{
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * RiskPercent / 100.0;
   
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   if(tickSize == 0 || riskInPrice == 0) return 0;
   
   double lotSize = riskAmount / (riskInPrice / tickSize * tickValue);
   
   // Normalize lot size
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   lotSize = MathFloor(lotSize / lotStep) * lotStep;
   lotSize = MathMax(minLot, MathMin(maxLot, lotSize));
   
   return lotSize;
}

//+------------------------------------------------------------------+
