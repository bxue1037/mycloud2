//+------------------------------------------------------------------+ 
//|                                        3_Level_ZZ_Semafor.mq4    | 
//+------------------------------------------------------------------+ 
//| 3_Level_ZZ_Semafor_TRO_MODIFIED_VERSION                          |
//| MODIFIED BY AVERY T. HORTON, JR. AKA THERUMPLEDONE@GMAIL.COM     |
//| I am NOT the ORIGINAL author 
//  and I am not claiming authorship of this indicator. 
//  All I did was modify it. I hope you find my modifications useful.|
//|                                                                  |
//+------------------------------------------------------------------+
 
#property copyright "asystem2000" 
#property link      "asystem2000@yandex.ru" 

#property indicator_chart_window 
#property indicator_buffers 6
#property indicator_color1 Chocolate 
#property indicator_color2 Chocolate 
#property indicator_color3 MediumVioletRed
#property indicator_color4 MediumVioletRed
#property indicator_color5 Yellow
#property indicator_color6 Yellow
//+--------- TRO MODIFICATION ---------------------------------------+ 

extern bool   Sound.Alert    = false ;
 
//---- input parameters 
extern double Period1=5; 
extern double Period2=13; 
extern double Period3=34; 
extern string   Dev_Step_1="1,3";
extern string   Dev_Step_2="8,5";
extern string   Dev_Step_3="13,8";
extern int Symbol_1_Kod=140;
extern int Symbol_2_Kod=141;
extern int Symbol_3_Kod=142;

//---- buffers 
double FP_BuferUp[];
double FP_BuferDn[]; 
double NP_BuferUp[];
double NP_BuferDn[]; 
double HP_BuferUp[];
double HP_BuferDn[]; 

int F_Period;
int N_Period;
int H_Period;
int Dev1;
int Stp1;
int Dev2;
int Stp2;
int Dev3;
int Stp3;
//+--------- TRO MODIFICATION ---------------------------------------+ 
string symbol, tChartPeriod,  tShortName ;  
int    digits, period  ; 

bool Trigger1,  Trigger2,  Trigger3 ;

int OldBars = -1 ;

color tColor = Yellow ;

//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init() 
  { 
//+--------- TRO MODIFICATION ---------------------------------------+  
   period       = Period() ;     
   tChartPeriod =  TimeFrameToString(period) ;
   symbol       =  Symbol() ;
   digits       =  Digits ;   

   tShortName = "tbb"+ symbol + tChartPeriod  ;
    
   
  
// --------- ������������ ������� ��� ���������� ��������
  
  
   if (Period1>0) F_Period=MathCeil(Period1*Period()); else F_Period=0; 
   if (Period2>0) N_Period=MathCeil(Period2*Period()); else N_Period=0; 
   if (Period3>0) H_Period=MathCeil(Period3*Period()); else H_Period=0; 
   
//---- ������������ 1 ����� 
   if (Period1>0)
   {
   SetIndexStyle(0,DRAW_ARROW,0,1); 
   SetIndexArrow(0,Symbol_1_Kod); 
   SetIndexBuffer(0,FP_BuferUp); 
   SetIndexEmptyValue(0,0.0); 
   
   SetIndexStyle(1,DRAW_ARROW,0,1); 
   SetIndexArrow(1,Symbol_1_Kod); 
   SetIndexBuffer(1,FP_BuferDn); 
   SetIndexEmptyValue(1,0.0); 
   }
   
//---- ������������ 2 ����� 
   if (Period2>0)
   {
   SetIndexStyle(2,DRAW_ARROW,0,2); 
   SetIndexArrow(2,Symbol_2_Kod); 
   SetIndexBuffer(2,NP_BuferUp); 
   SetIndexEmptyValue(2,0.0); 
   
   SetIndexStyle(3,DRAW_ARROW,0,2); 
   SetIndexArrow(3,Symbol_2_Kod); 
   SetIndexBuffer(3,NP_BuferDn); 
   SetIndexEmptyValue(3,0.0); 
   }
//---- ������������ 3 ����� 
   if (Period3>0)
   {
   SetIndexStyle(4,DRAW_ARROW,0,4); 
   SetIndexArrow(4,Symbol_3_Kod); 
   SetIndexBuffer(4,HP_BuferUp); 
   SetIndexEmptyValue(4,0.0); 

   SetIndexStyle(5,DRAW_ARROW,0,4); 
   SetIndexArrow(5,Symbol_3_Kod); 
   SetIndexBuffer(5,HP_BuferDn); 
   SetIndexEmptyValue(5,0.0); 
   }
// ������������ �������� �������� � �����
   int CDev=0;
   int CSt=0;
   int Mass[]; 
   int C=0;  
   if (IntFromStr(Dev_Step_1,C, Mass)==1) 
      {
        Stp1=Mass[1];
        Dev1=Mass[0];
      }
   
   if (IntFromStr(Dev_Step_2,C, Mass)==1)
      {
        Stp2=Mass[1];
        Dev2=Mass[0];
      }      
   
   
   if (IntFromStr(Dev_Step_3,C, Mass)==1)
      {
        Stp3=Mass[1];
        Dev3=Mass[0];
      }      
   return(0); 
  } 
//+------------------------------------------------------------------+ 
//| Custor indicator deinitialization function                       | 
//+------------------------------------------------------------------+ 
int deinit() 
  { 
//---- 
    
//---- 
   return(0); 
  } 

//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+ 
int start() 
  { 
  

//+--------- TRO MODIFICATION ---------------------------------------+   
   if( Bars != OldBars ) { Trigger1 = True ; Trigger2 = True ; Trigger3 = True ;}
   
     
   if (Period1>0) CountZZ(FP_BuferUp,FP_BuferDn,Period1,Dev1,Stp1);
   if (Period2>0) CountZZ(NP_BuferUp,NP_BuferDn,Period2,Dev2,Stp2);
   if (Period3>0) CountZZ(HP_BuferUp,HP_BuferDn,Period3,Dev3,Stp3);
   
   
//+--------- TRO MODIFICATION ---------------------------------------+  
      
      if ( Trigger1 &&  Sound.Alert ) 
      {
        if( FP_BuferUp[0] != 0 ) { Trigger1 = False ; Alert(symbol,"  ", tChartPeriod, " Level 1 Lower "+ DoubleToStr(Close[0] ,digits)); }
        if( FP_BuferDn[0] != 0 ) { Trigger1 = False ; Alert(symbol,"  ", tChartPeriod, " Level 1 Upper "+ DoubleToStr(Close[0] ,digits)); }
      }
      
      if ( Trigger2 &&  Sound.Alert ) 
      {
        if( NP_BuferUp[0] != 0 ) { Trigger2 = False ; Alert(symbol,"  ", tChartPeriod, " Level 2 Lower "+ DoubleToStr(Close[0] ,digits)); }
        if( NP_BuferDn[0] != 0 ) { Trigger2 = False ; Alert(symbol,"  ", tChartPeriod, " Level 2 Upper "+ DoubleToStr(Close[0] ,digits)); }
      }
      
      if ( Trigger3 &&  Sound.Alert ) 
      {     
        if( HP_BuferUp[0] != 0 ) { Trigger3 = False ; Alert(symbol,"  ", tChartPeriod, " Level 3 Lower "+ DoubleToStr(Close[0] ,digits)); }
        if( HP_BuferDn[0] != 0 ) { Trigger3 = False ; Alert(symbol,"  ", tChartPeriod, " Level 3 Upper "+ DoubleToStr(Close[0] ,digits)); }
      }

    
   OldBars = Bars ;   

//+--------- TRO MODIFICATION ---------------------------------------+                  
   return(0);
}

//+--------- TRO MODIFICATION ---------------------------------------+  

string TimeFrameToString(int tf)
{
   string tfs;
   switch(tf) {
      case PERIOD_M1:  tfs="M1"  ; break;
      case PERIOD_M5:  tfs="M5"  ; break;
      case PERIOD_M15: tfs="M15" ; break;
      case PERIOD_M30: tfs="M30" ; break;
      case PERIOD_H1:  tfs="H1"  ; break;
      case PERIOD_H4:  tfs="H4"  ; break;
      case PERIOD_D1:  tfs="D1"  ; break;
      case PERIOD_W1:  tfs="W1"  ; break;
      case PERIOD_MN1: tfs="MN";
   }
   return(tfs);
}

//+------------------------------------------------------------------+ 
// �������������� �������
//int Take



//+------------------------------------------------------------------+ 
//| ����� ������������ �������                        | 
//+------------------------------------------------------------------+  
int CountZZ( double& ExtMapBuffer[], double& ExtMapBuffer2[], int ExtDepth, int ExtDeviation, int ExtBackstep )
  {
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;

   for(shift=Bars-ExtDepth; shift>=0; shift--)
     {
      val=Low[Lowest(NULL,0,MODE_LOW,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else 
        { 
         lastlow=val; 
         if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer[shift+back];
               if((res!=0)&&(res>val)) ExtMapBuffer[shift+back]=0.0; 
              }
           }
        } 
        
          ExtMapBuffer[shift]=val;
      //--- high
      val=High[Highest(NULL,0,MODE_HIGH,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else 
        {
         lasthigh=val;
         if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer2[shift+back];
               if((res!=0)&&(res<val)) ExtMapBuffer2[shift+back]=0.0; 
              } 
           }
        }
      ExtMapBuffer2[shift]=val;
     }
   // final cutting 
   lasthigh=-1; lasthighpos=-1;
   lastlow=-1;  lastlowpos=-1;

   for(shift=Bars-ExtDepth; shift>=0; shift--)
     {
      curlow=ExtMapBuffer[shift];
      curhigh=ExtMapBuffer2[shift];
      if((curlow==0)&&(curhigh==0)) continue;
      //---
      if(curhigh!=0)
        {
         if(lasthigh>0) 
           {
            if(lasthigh<curhigh) ExtMapBuffer2[lasthighpos]=0;
            else ExtMapBuffer2[shift]=0;
           }
         //---
         if(lasthigh<curhigh || lasthigh<0)
           {
            lasthigh=curhigh;
            lasthighpos=shift;
           }
         lastlow=-1;
        }
      //----
      if(curlow!=0)
        {
         if(lastlow>0)
           {
            if(lastlow>curlow) ExtMapBuffer[lastlowpos]=0;
            else ExtMapBuffer[shift]=0;
           }
         //---
         if((curlow<lastlow)||(lastlow<0))
           {
            lastlow=curlow;
            lastlowpos=shift;
           } 
         lasthigh=-1;
        }
     }
  
   for(shift=Bars-1; shift>=0; shift--)
     {
      if(shift>=Bars-ExtDepth) ExtMapBuffer[shift]=0.0;
      else
        {
         res=ExtMapBuffer2[shift];
         if(res!=0.0) ExtMapBuffer2[shift]=res;
        }
     }
 }

//+------------------------------------------------------------------+   
int Str2Massive(string VStr, int& M_Count, int& VMass[])
  {
    int val=StrToInteger( VStr);
    if (val>0)
       {
         M_Count++;
         int mc=ArrayResize(VMass,M_Count);
         if (mc==0)return(-1);
          VMass[M_Count-1]=val;
         return(1);
       }
    else return(0);    
  } 
  

//+------------------------------------------------------------------+   
int IntFromStr(string ValStr,int& M_Count, int& VMass[])
  {
    
    if (StringLen(ValStr)==0) return(-1);
    string SS=ValStr;
    int NP=0; 
    string CS;
    M_Count=0;
    ArrayResize(VMass,M_Count);
    while (StringLen(SS)>0)
      {
            NP=StringFind(SS,",");
            if (NP>0)
               {
                 CS=StringSubstr(SS,0,NP);
                 SS=StringSubstr(SS,NP+1,StringLen(SS));  
               }
               else
               {
                 if (StringLen(SS)>0)
                    {
                      CS=SS;
                      SS="";
                    }
               }
            if (Str2Massive(CS,M_Count,VMass)==0) 
               {
                 return(-2);
               }
      }
    return(1);    
  }
  

//+------------------------------------------------------------------+   