﻿/*
 * H = CurrentClose   (High MAX + Low MIN) / 2
 
HS1 =Exponential Moving Average(H,3)
HS2 = Exponential Moving Average(HS1,3)
 
DHL1 =Exponential Moving Average  (High MAX   Low MIN,3) 
DHL2 = Exponential Moving Average (High MAX   Low MIN, 3) / 2
 
SMI TODAY = (HS2 / DHL2) * 100
 */

using cAlgo.API;
using cAlgo.API.Indicators;

namespace cAlgo.Indicators
{
    [Indicator()]
    internal class SMI : Indicator
    {
        private ExponentialMovingAverage _emaDiffCenter;
        private ExponentialMovingAverage _emaDiffHighLow;
        private ExponentialMovingAverage _emaDiffHighLow2;
        private ExponentialMovingAverage _emaSmoothed;
        private MovingAverage _maSmi;
        private IndicatorDataSeries _iDataSeries;
        private IndicatorDataSeries _iDataSeriesHighLow;
        private IndicatorDataSeries _smi;

        [Parameter("Period", DefaultValue = 10)]
        public int Period { get; set; }

        [Parameter("MA Type", DefaultValue = MovingAverageType.Simple)]
        public MovingAverageType MaType { get; set; }

        [Parameter("Use Zones", DefaultValue = true)]
        public bool UseZones { get; set; }

        [Parameter("Upper Zone", DefaultValue = 40, MinValue = -100, MaxValue = 100)]
        public int UpperZone { get; set; }
        [Parameter("Lower Zone", DefaultValue = -40, MinValue = -100, MaxValue = 100)]
        public int LowerZone { get; set; }


        [Output("HighSignal", Color = Colors.LightSteelBlue, PlotType = PlotType.Histogram, Thickness = 5)]
        public IndicatorDataSeries HighSignal { get; set; }

        [Output("LowSignal", Color = Colors.SteelBlue, PlotType = PlotType.Histogram, Thickness = 5)]
        public IndicatorDataSeries LowSignal { get; set; }

        [Output("NoSignal", Color = Colors.DimGray, PlotType = PlotType.Histogram, Thickness = 5)]
        public IndicatorDataSeries NoSignal { get; set; }

        protected override void Initialize()
        {
            _iDataSeries = CreateDataSeries();
            _emaDiffCenter = Indicators.ExponentialMovingAverage(_iDataSeries, 3);
            _emaSmoothed = Indicators.ExponentialMovingAverage(_emaDiffCenter.Result, 3);

            _iDataSeriesHighLow = CreateDataSeries();
            _emaDiffHighLow = Indicators.ExponentialMovingAverage(_iDataSeriesHighLow, 3);
            _emaDiffHighLow2 = Indicators.ExponentialMovingAverage(_emaDiffHighLow.Result, 3);

            _smi = CreateDataSeries();
            _maSmi = Indicators.MovingAverage(_smi, Period, MaType);
        }

        public override void Calculate(int index)
        {
            double center = (High(index) + Low(index)) / 2;
            _iDataSeries[index] = MarketSeries.Close[index] - center;

            _iDataSeriesHighLow[index] = (High(index) - Low(index));
            _emaDiffHighLow2.Result[index] /= 2;

            _smi[index] = 100 * (_emaSmoothed.Result[index] / _emaDiffHighLow2.Result[index]);
            //Result[index] = _smi[index];
            //MaResult[index] = _maSmi.Result[index];

            HighSignal[index] = 0;
            LowSignal[index] = 0;
            NoSignal[index] = 5;

            if (UseZones == true)
            {

                if (_smi[index] > _maSmi.Result[index] && _smi[index] <= LowerZone && _maSmi.Result[index] <= LowerZone)
                {
                    HighSignal[index] = 5;
                    LowSignal[index] = 0;
                    NoSignal[index] = 0;
                }
                if (_smi[index] < _maSmi.Result[index] && _smi[index] >= UpperZone && _maSmi.Result[index] >= UpperZone)
                {
                    HighSignal[index] = 0;
                    LowSignal[index] = 5;
                    NoSignal[index] = 0;
                }

            }
            else
            {
                if (_smi[index] > _maSmi.Result[index])
                {
                    HighSignal[index] = 5;
                    LowSignal[index] = 0;
                    NoSignal[index] = 0;
                }
                if (_smi[index] < _maSmi.Result[index])
                {
                    HighSignal[index] = 0;
                    LowSignal[index] = 5;
                    NoSignal[index] = 0;
                }
            }




            //SellLine[index] = 40;
            //BuyLine[index] = -40;
        }

        /// <summary>
        /// Retrieve the Highest Price of the past Period
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private double High(int index)
        {
            double high = MarketSeries.High[index - Period];

            for (int i = index - Period + 1; i <= index; i++)
            {
                if (MarketSeries.High[i] > high)
                    high = MarketSeries.High[i];
            }

            return high;
        }

        /// <summary>
        /// Retrieve the Lowest Price of the past Period
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        private double Low(int index)
        {
            double low = MarketSeries.Low[index - Period];

            for (int i = index - Period + 1; i <= index; i++)
            {
                if (MarketSeries.Low[i] < low)
                    low = MarketSeries.Low[i];
            }

            return low;
        }
    }
}
