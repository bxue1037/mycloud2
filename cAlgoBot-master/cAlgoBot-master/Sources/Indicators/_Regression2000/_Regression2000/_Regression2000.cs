﻿using System;
using cAlgo.API;
using cAlgo.API.Indicators;

namespace cAlgo.Indicators
{
    [Indicator(IsOverlay = true, AccessRights = AccessRights.None, AutoRescale = false)]
    public class Regression : Indicator
    {
        [Parameter(DefaultValue = 3.0, MinValue = 1, MaxValue = 4)]
        public int degree { get; set; }

        [Parameter(DefaultValue = 2000)]
        public int period { get; set; }

        [Parameter(DefaultValue = 1.7)]
        public double strdDev { get; set; }

        [Output("PRC", Color = Colors.Gray, LineStyle = LineStyle.Lines)]
        public IndicatorDataSeries prc { get; set; }

        [Output("SQH", Color = Colors.Red, LineStyle = LineStyle.Lines)]
        public IndicatorDataSeries sqh { get; set; }

        [Output("SQL", Color = Colors.DodgerBlue, LineStyle = LineStyle.Lines)]
        public IndicatorDataSeries sql { get; set; }

        public int ix { get; set; }

        private double[,] ai = new double[10, 10];
        private double[] b = new double[10];
        private double[] x = new double[10];
        private double[] sx = new double[10];
        private double sum;
        private int ip;
        private int p;
        private int n;
        private double qq;
        private double mm;
        private double tt;
        private int ii;
        private int jj;
        private int kk;
        private int ll;
        private int nn;
        private double sq;
        private double sq2;
        private double sq3;
        private int i0 = 0;
        private int mi;

        public override void Calculate(int index)
        {
            //if (!IsLastBar || index < period)
            //return;

            int i = index;
            ix = i;
            ip = period;
            p = ip;
            sx[1] = p + 1;
            nn = degree + 1;
            //----------------------sx-------------------------------------------------------------------
            //

            for (mi = 1; mi <= nn * 2 - 2; mi++)
            {
                sum = 0;
                for (n = i0; n <= i0 + p; n++)
                {
                    sum += Math.Pow(n, mi);
                }
                sx[mi + 1] = sum;
            }
            //----------------------syx-----------

            for (mi = 1; mi <= nn; mi++)
            {
                sum = 0.0;
                for (n = i0; n <= i0 + p; n++)
                {
                    if (mi == 1)
                        sum += MarketSeries.Close[index - n];
                    else
                        sum += MarketSeries.Close[index - n] * Math.Pow(n, mi - 1);
                }
                b[mi] = sum;
            }
            //===============Matrix=======================================================================================================

            for (jj = 1; jj <= nn; jj++)
            {
                for (ii = 1; ii <= nn; ii++)
                {
                    kk = ii + jj - 1;
                    ai[ii, jj] = sx[kk];
                }
            }

            //===============Gauss========================================================================================================
            for (kk = 1; kk <= nn - 1; kk++)
            {
                ll = 0;
                mm = 0;
                for (ii = kk; ii <= nn; ii++)
                {
                    if (Math.Abs(ai[ii, kk]) > mm)
                    {
                        mm = Math.Abs(ai[ii, kk]);
                        ll = ii;
                    }
                }
                if (ll == 0)
                    return;
                if (ll != kk)
                {
                    for (jj = 1; jj <= nn; jj++)
                    {
                        tt = ai[kk, jj];
                        ai[kk, jj] = ai[ll, jj];
                        ai[ll, jj] = tt;
                    }
                    tt = b[kk];
                    b[kk] = b[ll];
                    b[ll] = tt;
                }
                for (ii = kk + 1; ii <= nn; ii++)
                {
                    qq = ai[ii, kk] / ai[kk, kk];
                    for (jj = 1; jj <= nn; jj++)
                    {
                        if (jj == kk)
                            ai[ii, jj] = 0;
                        else
                            ai[ii, jj] = ai[ii, jj] - qq * ai[kk, jj];
                    }
                    b[ii] = b[ii] - qq * b[kk];
                }
            }

            x[nn] = b[nn] / ai[nn, nn];
            for (ii = nn - 1; ii >= 1; ii--)
            {
                tt = 0;
                for (jj = 1; jj <= nn - ii; jj++)
                {
                    tt = tt + ai[ii, ii + jj] * x[ii + jj];
                    x[ii] = (1 / ai[ii, ii]) * (b[ii] - tt);
                }
            }
            sq = 0.0;
            sq2 = 0.0;
            sq3 = 0.0;
            for (n = i0; n <= i0 + p; n++)
            {
                sum = 0;
                for (kk = 1; kk <= degree; kk++)
                {
                    sum += x[kk + 1] * Math.Pow(n, kk);
                }

                prc[index - n] = (x[1] + sum);
                sq += Math.Pow(MarketSeries.Close[index - n] - prc[index - n], 2);
                sq2 = sq;
                sq3 = sq;
            }

            sq = Math.Sqrt(sq / (p + 1)) * strdDev;

            for (n = 0; n <= period; n++)
            {

                sqh[index - n] = prc[index - n] + sq;
                sql[index - n] = prc[index - n] - sq;
            }

            prc[index - period] = double.NaN;
            sqh[index - period] = double.NaN;
            sql[index - period] = double.NaN;

        }


    }
}
