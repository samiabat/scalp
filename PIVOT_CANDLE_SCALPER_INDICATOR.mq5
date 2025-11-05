//+------------------------------------------------------------------+
//|                              PIVOT_CANDLE_SCALPER_INDICATOR.mq5 |
//|                                    Copyright 2025, PivotScalper |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, PivotScalper"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Pivot-based scalping indicator with entry/SL/TP levels"
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_plots   7

//--- Plot buffers
#property indicator_label1  "Buy Signal"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrLime
#property indicator_width1  2

#property indicator_label2  "Sell Signal"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_width2  2

#property indicator_label3  "Entry Level"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_DOT
#property indicator_width3  1

#property indicator_label4  "Stop Loss"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2

#property indicator_label5  "Take Profit 1"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrLime
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1

#property indicator_label6  "Take Profit 2"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrDodgerBlue
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1

#property indicator_label7  "Pivot Point"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrGold
#property indicator_style7  STYLE_DASH
#property indicator_width7  2

//--- Input parameters
input double   StopLossPips = 15;                 // Stop Loss in pips
input double   TakeProfit1Pips = 20;              // Take Profit 1 in pips
input double   TakeProfit2Pips = 40;              // Take Profit 2 in pips

//--- Indicator buffers
double BuySignalBuffer[];
double SellSignalBuffer[];
double EntryBuffer[];
double StopLossBuffer[];
double TakeProfit1Buffer[];
double TakeProfit2Buffer[];
double PivotBuffer[];

//--- Global variables
double g_PP, g_R1, g_R2, g_S1, g_S2;
double g_point;
double g_pipValue;
int g_digits;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Initialize symbol-specific variables
   g_point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   g_digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   if(g_digits == 5 || g_digits == 3)
      g_pipValue = g_point * 10;
   else if(g_digits == 4 || g_digits == 2)
      g_pipValue = g_point;
   else
      g_pipValue = g_point * 10;
   
   //--- Set indicator buffers
   SetIndexBuffer(0, BuySignalBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, SellSignalBuffer, INDICATOR_DATA);
   SetIndexBuffer(2, EntryBuffer, INDICATOR_DATA);
   SetIndexBuffer(3, StopLossBuffer, INDICATOR_DATA);
   SetIndexBuffer(4, TakeProfit1Buffer, INDICATOR_DATA);
   SetIndexBuffer(5, TakeProfit2Buffer, INDICATOR_DATA);
   SetIndexBuffer(6, PivotBuffer, INDICATOR_DATA);
   
   //--- Set arrow codes
   PlotIndexSetInteger(0, PLOT_ARROW, 233); // Up arrow
   PlotIndexSetInteger(1, PLOT_ARROW, 234); // Down arrow
   
   //--- Set empty values
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(4, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(5, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(6, PLOT_EMPTY_VALUE, 0.0);
   
   //--- Set indicator name
   IndicatorSetString(INDICATOR_SHORTNAME, "PivotCandleScalper Indicator");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int limit = prev_calculated == 0 ? rates_total - 100 : prev_calculated - 1;
   
   for(int i = limit; i < rates_total - 1; i++)
   {
      //--- Initialize buffers
      BuySignalBuffer[i] = 0.0;
      SellSignalBuffer[i] = 0.0;
      EntryBuffer[i] = 0.0;
      StopLossBuffer[i] = 0.0;
      TakeProfit1Buffer[i] = 0.0;
      TakeProfit2Buffer[i] = 0.0;
      
      //--- Calculate pivot points for this bar
      CalculatePivotPoints(time[i]);
      PivotBuffer[i] = g_PP;
      
      //--- Check for signals (need at least 2 bars)
      if(i < 2) continue;
      
      //--- Get current price
      double currentPrice = close[i];
      
      //--- Determine market bias
      bool bullishBias = currentPrice > g_PP;
      bool bearishBias = currentPrice < g_PP;
      
      //--- Check for bullish setup
      if(bullishBias)
      {
         double tolerance = 5 * g_pipValue;
         bool nearS1 = MathAbs(close[i] - g_S1) <= tolerance;
         bool nearPP = MathAbs(close[i] - g_PP) <= tolerance;
         
         if(nearS1 || nearPP)
         {
            bool isBullishPinBar = IsBullishPinBar(open[i], high[i], low[i], close[i]);
            bool isBullishEngulfing = IsBullishEngulfing(open[i], close[i], open[i-1], close[i-1]);
            
            if(isBullishPinBar || isBullishEngulfing)
            {
               BuySignalBuffer[i] = low[i] - 5 * g_pipValue;
               
               //--- Calculate entry, SL, and TPs
               double entry = close[i];
               double sl = low[i] - (2 * g_pipValue);
               double tp1 = entry + (TakeProfit1Pips * g_pipValue);
               double tp2 = entry + (TakeProfit2Pips * g_pipValue);
               
               //--- Draw levels for next 10 bars
               for(int j = i; j < MathMin(i + 10, rates_total - 1); j++)
               {
                  EntryBuffer[j] = entry;
                  StopLossBuffer[j] = sl;
                  TakeProfit1Buffer[j] = tp1;
                  TakeProfit2Buffer[j] = tp2;
               }
            }
         }
      }
      
      //--- Check for bearish setup
      if(bearishBias)
      {
         double tolerance = 5 * g_pipValue;
         bool nearR1 = MathAbs(close[i] - g_R1) <= tolerance;
         bool nearPP = MathAbs(close[i] - g_PP) <= tolerance;
         
         if(nearR1 || nearPP)
         {
            bool isBearishPinBar = IsBearishPinBar(open[i], high[i], low[i], close[i]);
            bool isBearishEngulfing = IsBearishEngulfing(open[i], close[i], open[i-1], close[i-1]);
            
            if(isBearishPinBar || isBearishEngulfing)
            {
               SellSignalBuffer[i] = high[i] + 5 * g_pipValue;
               
               //--- Calculate entry, SL, and TPs
               double entry = close[i];
               double sl = high[i] + (2 * g_pipValue);
               double tp1 = entry - (TakeProfit1Pips * g_pipValue);
               double tp2 = entry - (TakeProfit2Pips * g_pipValue);
               
               //--- Draw levels for next 10 bars
               for(int j = i; j < MathMin(i + 10, rates_total - 1); j++)
               {
                  EntryBuffer[j] = entry;
                  StopLossBuffer[j] = sl;
                  TakeProfit1Buffer[j] = tp1;
                  TakeProfit2Buffer[j] = tp2;
               }
            }
         }
      }
   }
   
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Calculate pivot points from previous day                         |
//+------------------------------------------------------------------+
void CalculatePivotPoints(datetime current_time)
{
   double prevHigh = iHigh(_Symbol, PERIOD_D1, 1);
   double prevLow = iLow(_Symbol, PERIOD_D1, 1);
   double prevClose = iClose(_Symbol, PERIOD_D1, 1);
   
   g_PP = (prevHigh + prevLow + prevClose) / 3.0;
   g_R1 = 2 * g_PP - prevLow;
   g_R2 = g_PP + (prevHigh - prevLow);
   g_S1 = 2 * g_PP - prevHigh;
   g_S2 = g_PP - (prevHigh - prevLow);
}

//+------------------------------------------------------------------+
//| Detect bullish pin bar pattern                                   |
//+------------------------------------------------------------------+
bool IsBullishPinBar(double open, double high, double low, double close)
{
   double body = MathAbs(close - open);
   double totalRange = high - low;
   double lowerWick = MathMin(open, close) - low;
   double upperWick = high - MathMax(open, close);
   
   if(totalRange == 0)
      return false;
   
   bool longLowerWick = lowerWick >= (2 * body);
   bool smallUpperWick = upperWick <= (0.3 * totalRange);
   
   return (longLowerWick && smallUpperWick);
}

//+------------------------------------------------------------------+
//| Detect bearish pin bar pattern                                   |
//+------------------------------------------------------------------+
bool IsBearishPinBar(double open, double high, double low, double close)
{
   double body = MathAbs(close - open);
   double totalRange = high - low;
   double lowerWick = MathMin(open, close) - low;
   double upperWick = high - MathMax(open, close);
   
   if(totalRange == 0)
      return false;
   
   bool longUpperWick = upperWick >= (2 * body);
   bool smallLowerWick = lowerWick <= (0.3 * totalRange);
   
   return (longUpperWick && smallLowerWick);
}

//+------------------------------------------------------------------+
//| Detect bullish engulfing pattern                                 |
//+------------------------------------------------------------------+
bool IsBullishEngulfing(double open1, double close1, double open2, double close2)
{
   if(close1 <= open1)
      return false;
   
   if(close2 >= open2)
      return false;
   
   bool engulfs = (open1 < close2) && (close1 > open2);
   
   return engulfs;
}

//+------------------------------------------------------------------+
//| Detect bearish engulfing pattern                                 |
//+------------------------------------------------------------------+
bool IsBearishEngulfing(double open1, double close1, double open2, double close2)
{
   if(close1 >= open1)
      return false;
   
   if(close2 <= open2)
      return false;
   
   bool engulfs = (open1 > close2) && (close1 < open2);
   
   return engulfs;
}
//+------------------------------------------------------------------+
