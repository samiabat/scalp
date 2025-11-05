//+------------------------------------------------------------------+
//|                                          XAUUSD_M15_Scalper.mq4 |
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
input int Slippage = 3;                   // Maximum slippage in points

// Global variables
double PP, R1, R2, S1, S2;                // Pivot points
datetime lastCalculationDate = 0;         // Last pivot calculation date

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
   datetime currentBarTime = iTime(Symbol(), PERIOD_M15, 0);
   
   if(currentBarTime == lastBarTime) return;
   lastBarTime = currentBarTime;
   
   // Update pivots daily
   datetime currentDate = iTime(Symbol(), PERIOD_D1, 0);
   if(currentDate != lastCalculationDate)
   {
      CalculatePivots();
      lastCalculationDate = currentDate;
   }
   
   // Manage existing positions
   ManagePositions();
   
   // Check if we already have an open position
   if(HasOpenPosition()) return;
   
   // Get current price
   double close = iClose(Symbol(), PERIOD_M15, 1);
   
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
//| Manage existing positions for partial take profit                |
//+------------------------------------------------------------------+
void ManagePositions()
{
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderSymbol() != Symbol()) continue;
      if(OrderMagicNumber() != MagicNumber) continue;
      
      double positionOpenPrice = OrderOpenPrice();
      double currentVolume = OrderLots();
      int orderType = OrderType();
      string comment = OrderComment();
      
      // Check if partial TP already taken
      if(StringFind(comment, "Partial") >= 0) continue;
      
      bool shouldTakePartial = false;
      
      if(orderType == OP_BUY)
      {
         // Check if price reached R1 for long positions
         if(Bid >= R1)
         {
            shouldTakePartial = true;
         }
      }
      else if(orderType == OP_SELL)
      {
         // Check if price reached S1 for short positions
         if(Ask <= S1)
         {
            shouldTakePartial = true;
         }
      }
      
      // Close 50% of position
      if(shouldTakePartial)
      {
         double minLot = MarketInfo(Symbol(), MODE_MINLOT);
         double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
         int lotDigits = (int)MathLog10(1.0 / lotStep);
         
         double partialVolume = NormalizeDouble(currentVolume * 0.5, lotDigits);
         
         if(partialVolume >= minLot)
         {
            bool result = OrderClose(OrderTicket(), partialVolume, 
                                    orderType == OP_BUY ? Bid : Ask, 
                                    Slippage, clrGreen);
            if(result)
            {
               Print("Partial take profit executed: 50% at pivot level");
            }
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
   double prevHigh = iHigh(Symbol(), PERIOD_D1, 1);
   double prevLow = iLow(Symbol(), PERIOD_D1, 1);
   double prevClose = iClose(Symbol(), PERIOD_D1, 1);
   
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
   double low = iLow(Symbol(), PERIOD_M15, 1);
   double high = iHigh(Symbol(), PERIOD_M15, 1);
   
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
   double open = iOpen(Symbol(), PERIOD_M15, shift);
   double close = iClose(Symbol(), PERIOD_M15, shift);
   double high = iHigh(Symbol(), PERIOD_M15, shift);
   double low = iLow(Symbol(), PERIOD_M15, shift);
   
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
   double open = iOpen(Symbol(), PERIOD_M15, shift);
   double close = iClose(Symbol(), PERIOD_M15, shift);
   double high = iHigh(Symbol(), PERIOD_M15, shift);
   double low = iLow(Symbol(), PERIOD_M15, shift);
   
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
   
   double open1 = iOpen(Symbol(), PERIOD_M15, shift + 1);
   double close1 = iClose(Symbol(), PERIOD_M15, shift + 1);
   double open2 = iOpen(Symbol(), PERIOD_M15, shift);
   double close2 = iClose(Symbol(), PERIOD_M15, shift);
   
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
   
   double open1 = iOpen(Symbol(), PERIOD_M15, shift + 1);
   double close1 = iClose(Symbol(), PERIOD_M15, shift + 1);
   double open2 = iOpen(Symbol(), PERIOD_M15, shift);
   double close2 = iClose(Symbol(), PERIOD_M15, shift);
   
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
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
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
   double low = iLow(Symbol(), PERIOD_M15, 1);
   
   // Entry at current ask price
   double ask = Ask;
   
   // Stop loss below signal candle low
   double sl = low;
   
   // Calculate risk in price
   double risk = ask - sl;
   if(risk <= 0) return;
   
   // Take profit at 2x risk
   double tp = ask + (2.0 * risk);
   
   // Calculate lot size based on risk
   double lotSize = CalculateLotSize(risk);
   if(lotSize <= 0) return;
   
   // Place order
   int ticket = OrderSend(Symbol(), OP_BUY, lotSize, ask, Slippage, sl, tp, 
                          "Long Scalp", MagicNumber, 0, clrGreen);
   
   if(ticket > 0)
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
   double high = iHigh(Symbol(), PERIOD_M15, 1);
   
   // Entry at current bid price
   double bid = Bid;
   
   // Stop loss above signal candle high
   double sl = high;
   
   // Calculate risk in price
   double risk = sl - bid;
   if(risk <= 0) return;
   
   // Take profit at 2x risk
   double tp = bid - (2.0 * risk);
   
   // Calculate lot size based on risk
   double lotSize = CalculateLotSize(risk);
   if(lotSize <= 0) return;
   
   // Place order
   int ticket = OrderSend(Symbol(), OP_SELL, lotSize, bid, Slippage, sl, tp, 
                          "Short Scalp", MagicNumber, 0, clrRed);
   
   if(ticket > 0)
   {
      Print("Short position opened at ", bid, " SL: ", sl, " TP: ", tp);
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
   double accountBalance = AccountBalance();
   double riskAmount = accountBalance * RiskPercent / 100.0;
   
   double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   
   if(tickSize == 0 || riskInPrice == 0) return 0;
   
   double lotSize = riskAmount / (riskInPrice / tickSize * tickValue);
   
   // Normalize lot size
   double minLot = MarketInfo(Symbol(), MODE_MINLOT);
   double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   int lotDigits = (int)MathLog10(1.0 / lotStep);
   
   lotSize = NormalizeDouble(MathFloor(lotSize / lotStep) * lotStep, lotDigits);
   lotSize = MathMax(minLot, MathMin(maxLot, lotSize));
   
   return lotSize;
}

//+------------------------------------------------------------------+
