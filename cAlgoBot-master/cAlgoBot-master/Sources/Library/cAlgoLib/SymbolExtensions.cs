﻿#region Licence
//The MIT License (MIT)
//Copyright (c) 2014 abdallah HACID, https://www.facebook.com/ab.hacid

//Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//and associated documentation files (the "Software"), to deal in the Software without restriction,
//including without limitation the rights to use, copy, modify, merge, publish, distribute,
//sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
//is furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all copies or
//substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// Project Hosting for Open Source Software on Github : https://github.com/abhacid/cAlgoBot
#endregion

using cAlgo.API.Internals;

namespace cAlgo.Lib
{
	/// <summary>
	/// Méthodes d'extensions du type cAlgo.API.Robot.Symbol
	/// </summary>
	public static class SymbolExtensions
	{
		public static double Mid(this Symbol symbol)
		{
			double midPrice = (symbol.Ask + symbol.Bid) / 2; 

			return midPrice;
		}

		public static double marginRequired(this Symbol symbol, double lots, int leverage)
		{
			double margin;
			double crossPrice = symbol.Ask;

			//USD / XXX:  
			margin = lots / leverage;

			//XXX / USD:
			margin = crossPrice * lots / leverage;

			//XXX / YYY:
			//a). (EUR/GBP, AUD/NZD ...)
			//margin = crossPrice  * currentPrice(XXX/USD) * lots / leverage;
			//b). (CAD/CHF, CHF/JPY ....)
			// margin = crossPrice / currentPrice(USD/XXX)  * lots / leverage;

			return margin;
		}
	}
}

