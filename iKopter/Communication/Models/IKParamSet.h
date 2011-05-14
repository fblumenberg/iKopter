// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010-2011, Frank Blumenberg
//
// See License.txt for complete licensing and attribution information.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// ///////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

#import "IKMkDataTypes.h"

@interface IKParamSet: NSObject {

  IKMkParamset _parameter;
}

+ (id)settingWithData:(NSData *)data;
- (id)initWithData:(NSData*)data;
- (NSData*) data;

@property(assign) NSNumber* Index;
@property(assign) NSNumber* Revision;
@property(assign) NSNumber* Kanalbelegung_00;
@property(assign) NSNumber* Kanalbelegung_01;
@property(assign) NSNumber* Kanalbelegung_02;
@property(assign) NSNumber* Kanalbelegung_03;
@property(assign) NSNumber* Kanalbelegung_04;
@property(assign) NSNumber* Kanalbelegung_05;
@property(assign) NSNumber* Kanalbelegung_06;
@property(assign) NSNumber* Kanalbelegung_07;
@property(assign) NSNumber* Kanalbelegung_08;
@property(assign) NSNumber* Kanalbelegung_09;
@property(assign) NSNumber* Kanalbelegung_10;
@property(assign) NSNumber* Kanalbelegung_11;
@property(assign) NSNumber* GlobalConfig;
@property(assign) NSNumber* GlobalConfig_HOEHENREGELUNG;
@property(assign) NSNumber* GlobalConfig_HOEHEN_SCHALTER;
@property(assign) NSNumber* GlobalConfig_HEADING_HOLD;
@property(assign) NSNumber* GlobalConfig_KOMPASS_AKTIV;
@property(assign) NSNumber* GlobalConfig_KOMPASS_FIX;
@property(assign) NSNumber* GlobalConfig_GPS_AKTIV;
@property(assign) NSNumber* GlobalConfig_ACHSENKOPPLUNG_AKTIV;
@property(assign) NSNumber* GlobalConfig_DREHRATEN_BEGRENZER ;
@property(assign) NSNumber* Hoehe_MinGas;
@property(assign) NSNumber* Luftdruck_D;
@property(assign) NSNumber* MaxHoehe;
@property(assign) NSNumber* Hoehe_P;
@property(assign) NSNumber* Hoehe_Verstaerkung;
@property(assign) NSNumber* Hoehe_ACC_Wirkung;
@property(assign) NSNumber* Hoehe_HoverBand;
@property(assign) NSNumber* Hoehe_GPS_Z;
@property(assign) NSNumber* Hoehe_StickNeutralPoint;
@property(assign) NSNumber* Stick_P;
@property(assign) NSNumber* Stick_D;
@property(assign) NSNumber* Gier_P;
@property(assign) NSNumber* Gas_Min;
@property(assign) NSNumber* Gas_Max;
@property(assign) NSNumber* GyroAccFaktor;
@property(assign) NSNumber* KompassWirkung;
@property(assign) NSNumber* Gyro_P;
@property(assign) NSNumber* Gyro_I;
@property(assign) NSNumber* Gyro_D;
@property(assign) NSNumber* Gyro_Gier_P;
@property(assign) NSNumber* Gyro_Gier_I;
@property(assign) NSNumber* Gyro_Stability;
@property(assign) NSNumber* UnterspannungsWarnung;
@property(assign) NSNumber* NotGas;
@property(assign) NSNumber* NotGasZeit;
@property(assign) NSNumber* Receiver;
@property(assign) NSNumber* I_Faktor;
@property(assign) NSNumber* UserParam1;
@property(assign) NSNumber* UserParam2;
@property(assign) NSNumber* UserParam3;
@property(assign) NSNumber* UserParam4;
@property(assign) NSNumber* ServoNickControl;
@property(assign) NSNumber* ServoNickComp;
@property(assign) NSNumber* ServoNickMin;
@property(assign) NSNumber* ServoNickMax;
@property(assign) NSNumber* ServoRollControl;
@property(assign) NSNumber* ServoRollComp;
@property(assign) NSNumber* ServoRollMin;
@property(assign) NSNumber* ServoRollMax;
@property(assign) NSNumber* ServoNickRefresh;
@property(assign) NSNumber* ServoManualControlSpeed;
@property(assign) NSNumber* CamOrientation;
@property(assign) NSNumber* Servo3;
@property(assign) NSNumber* Servo4;
@property(assign) NSNumber* Servo5;
@property(assign) NSNumber* LoopGasLimit;
@property(assign) NSNumber* LoopThreshold;
@property(assign) NSNumber* LoopHysterese;
@property(assign) NSNumber* AchsKopplung1;
@property(assign) NSNumber* AchsKopplung2;
@property(assign) NSNumber* CouplingYawCorrection;
@property(assign) NSNumber* WinkelUmschlagNick;
@property(assign) NSNumber* WinkelUmschlagRoll;
@property(assign) NSNumber* GyroAccAbgleich;
@property(assign) NSNumber* Driftkomp;
@property(assign) NSNumber* DynamicStability;
@property(assign) NSNumber* UserParam5;
@property(assign) NSNumber* UserParam6;
@property(assign) NSNumber* UserParam7;
@property(assign) NSNumber* UserParam8;
@property(assign) NSNumber* J16Bitmask;
@property(assign) NSNumber* J16Timing;
@property(assign) NSNumber* J17Bitmask;
@property(assign) NSNumber* J17Timing;
@property(assign) NSNumber* WARN_J16_Bitmask;
@property(assign) NSNumber* WARN_J17_Bitmask;
@property(assign) NSNumber* NaviGpsModeControl;
@property(assign) NSNumber* NaviGpsGain;
@property(assign) NSNumber* NaviGpsP;
@property(assign) NSNumber* NaviGpsI;
@property(assign) NSNumber* NaviGpsD;
@property(assign) NSNumber* NaviGpsPLimit;
@property(assign) NSNumber* NaviGpsILimit;
@property(assign) NSNumber* NaviGpsDLimit;
@property(assign) NSNumber* NaviGpsACC;
@property(assign) NSNumber* NaviGpsMinSat;
@property(assign) NSNumber* NaviStickThreshold;
@property(assign) NSNumber* NaviWindCorrection;
@property(assign) NSNumber* NaviSpeedCompensation;
@property(assign) NSNumber* NaviOperatingRadius;
@property(assign) NSNumber* NaviAngleLimitation;
@property(assign) NSNumber* NaviPH_LoginTime;
@property(assign) NSNumber* ExternalControl;
@property(assign) NSNumber* OrientationAngle;
@property(assign) NSNumber* OrientationModeControl;
@property(assign) NSNumber* MotorSafetySwitch;
@property(assign) NSNumber* BitConfig;
@property(assign) NSNumber* BitConfig_LOOP_OBEN;
@property(assign) NSNumber* BitConfig_LOOP_UNTEN;
@property(assign) NSNumber* BitConfig_LOOP_LINKS;
@property(assign) NSNumber* BitConfig_LOOP_RECHTS;
@property(assign) NSNumber* BitConfig_MOTOR_BLINK;
@property(assign) NSNumber* BitConfig_MOTOR_OFF_LED1;
@property(assign) NSNumber* BitConfig_MOTOR_OFF_LED2;
@property(assign) NSNumber* ServoCompInvert;
@property(assign) NSNumber* ServoCompInvert_NICK;
@property(assign) NSNumber* ServoCompInvert_ROLL;
@property(assign) NSNumber* ExtraConfig;
@property(assign) NSNumber* ExtraConfig_HEIGHT_LIMIT;
@property(assign) NSNumber* ExtraConfig_VARIO_BEEP;
@property(assign) NSNumber* ExtraConfig_SENSITIVE_RC;
@property(assign) NSNumber* ExtraConfig_3_3V_REFERENCE;
@property(assign) NSString*  Name;

@end