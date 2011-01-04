// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010, Frank Blumenberg
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

#define kHostnameKey @"hostname" 
#define kHostportKey @"hostport" 
#define kUseDummyConnKey @"usedummy" 
#define kUseConnClassKey @"useconnclass" 


#define kMKDataKeyVersion      @"version"
#define kMKDataKeyVersionShort @"versionShort"
#define kMKDataKeyMenuItem     @"menuItem"
#define kMKDataKeyMaxMenuItem  @"maxMenuItem"
#define kMKDataKeyMenuRows     @"menuRows"
#define kMKDataKeyDebugData    @"debugData"
#define kMKDataKeyLabel        @"label"
#define kMKDataKeyIndex        @"index"
#define kMKDataKeyChannels     @"channels"

#define kMKDataKeyResult       @"result"
#define kMKDataKeyRawValue     @"rawvalue"

#define kMKDataKeyAddress      @"address"

#define kIKLcdDisplay          @"IKLcdDisplay"
#define kIKParamSet            @"IKParamSet"


//   unsigned char Kanalbelegung[12];
#define kKeyKanalbelegung00 @"Kanalbelegung00"
#define kKeyKanalbelegung01 @"Kanalbelegung01"
#define kKeyKanalbelegung02 @"Kanalbelegung02"
#define kKeyKanalbelegung03 @"Kanalbelegung03"
#define kKeyKanalbelegung04 @"Kanalbelegung04"
#define kKeyKanalbelegung05 @"Kanalbelegung05"
#define kKeyKanalbelegung06 @"Kanalbelegung06"
#define kKeyKanalbelegung07 @"Kanalbelegung07"
#define kKeyKanalbelegung08 @"Kanalbelegung08"
#define kKeyKanalbelegung09 @"Kanalbelegung09"
#define kKeyKanalbelegung10 @"Kanalbelegung10"
#define kKeyKanalbelegung11 @"Kanalbelegung11"
#define kKeyKanalbelegung12 @"Kanalbelegung12"
#define kKeyGlobalConfig    @"GlobalConfig"
//   unsigned char GlobalConfig;
// #define CFG_HOEHENREGELUNG       0x01
// #define CFG_HOEHEN_SCHALTER      0x02
// #define CFG_HEADING_HOLD         0x04
// #define CFG_KOMPASS_AKTIV        0x08
// #define CFG_KOMPASS_FIX          0x10
// #define CFG_GPS_AKTIV            0x20
// #define CFG_ACHSENKOPPLUNG_AKTIV 0x40
// #define CFG_DREHRATEN_BEGRENZER  0x80
#define kKeyGlobalConfig_HOEHENREGELUNG       @"GlobalConfig_HOEHENREGELUNG"
#define kKeyGlobalConfig_HOEHEN_SCHALTER      @"GlobalConfig_HOEHEN_SCHALTER"
#define kKeyGlobalConfig_HEADING_HOLD         @"GlobalConfig_HEADING_HOLD"
#define kKeyGlobalConfig_KOMPASS_AKTIV        @"GlobalConfig_KOMPASS_AKTIV"
#define kKeyGlobalConfig_KOMPASS_FIX          @"GlobalConfig_KOMPASS_FIX"
#define kKeyGlobalConfig_GPS_AKTIV            @"GlobalConfig_GPS_AKTIV"
#define kKeyGlobalConfig_ACHSENKOPPLUNG_AKTIV @"GlobalConfig_ACHSENKOPPLUNG_AKTIV"
#define kKeyGlobalConfig_DREHRATEN_BEGRENZER  @"GlobalConfig_DREHRATEN_BEGRENZER"
//   unsigned char Hoehe_MinGas;           // Wert : 0-100
#define kKeyHoehe_MinGas                      @"Hoehe_MinGas"
//   unsigned char Luftdruck_D;            // Wert : 0-250
#define kKeyLuftdruck_D                       @"Luftdruck_D"
//   unsigned char MaxHoehe;               // Wert : 0-32
#define kKeyMaxHoehe                          @"MaxHoehe"
//   unsigned char Hoehe_P;                // Wert : 0-32
#define kKeyHoehe_P                           @"Hoehe_P"
//   unsigned char Hoehe_Verstaerkung;     // Wert : 0-50
#define kKeyHoehe_Verstaerkung                @"Hoehe_Verstaerkung"
//   unsigned char Hoehe_ACC_Wirkung;      // Wert : 0-250
#define kKeyHoehe_ACC_Wirkung                 @"Hoehe_ACC_Wirkung"
//   unsigned char Hoehe_HoverBand;        // Wert : 0-250
#define kKeyHoehe_HoverBand                   @"Hoehe_HoverBand"
//   unsigned char Hoehe_GPS_Z;            // Wert : 0-250
#define kKeyHoehe_GPS_Z                       @"Hoehe_GPS_Z"
//   unsigned char Hoehe_StickNeutralPoint;// Wert : 0-250
#define kKeyHoehe_StickNeutralPoint           @"Hoehe_StickNeutralPoint"
//   unsigned char Stick_P;                // Wert : 1-6
#define kKeyStick_P                           @"Stick_P"
//   unsigned char Stick_D;                // Wert : 0-64
#define kKeyStick_D                           @"Stick_D"
//   unsigned char Gier_P;                 // Wert : 1-20
#define kKeyGier_P                            @"Gier_P"
//   unsigned char Gas_Min;                // Wert : 0-32
#define kKeyGas_Min                           @"Gas_Min"
//   unsigned char Gas_Max;                // Wert : 33-250
#define kKeyGas_Max                           @"Gas_Max"
//   unsigned char GyroAccFaktor;          // Wert : 1-64
#define kKeyGyroAccFaktor                     @"GyroAccFaktor"
//   unsigned char KompassWirkung;         // Wert : 0-32
#define kKeyKompassWirkung                    @"KompassWirkung"
//   unsigned char Gyro_P;                 // Wert : 10-250
#define kKeyGyro_P                            @"Gyro_P"
//   unsigned char Gyro_I;                 // Wert : 0-250
#define kKeyGyro_I                            @"Gyro_I"
//   unsigned char Gyro_D;                 // Wert : 0-250
#define kKeyGyro_D                            @"Gyro_D"
//   unsigned char Gyro_Gier_P;                 // Wert : 10-250
#define kKeyGyro_Gier_P                       @"Gyro_Gier_P"
//   unsigned char Gyro_Gier_I;                 // Wert : 0-250
#define kKeyGyro_Gier_I                       @"Gyro_Gier_I"
//   unsigned char UnterspannungsWarnung;  // Wert : 0-250
#define kKeyUnterspannungsWarnung             @"UnterspannungsWarnung"
//   unsigned char NotGas;                 // Wert : 0-250     //Gaswert bei Empfangsverlust
#define kKeyNotGas                            @"NotGas"
//   unsigned char NotGasZeit;             // Wert : 0-250     // Zeitbis auf NotGas geschaltet wird, wg. Rx-Problemen
#define kKeyNotGasZeit                        @"NotGasZeit"
//   unsigned char Receiver;             // 0= Summensignal, 1= Spektrum, 2 =Jeti, 3=ACT DSL, 4=ACT S3D
#define kKeyReceiver                          @"Receiver"
//   unsigned char I_Faktor;               // Wert : 0-250
#define kKeyI_Faktor                          @"I_Faktor"
//   unsigned char UserParam1;             // Wert : 0-250
#define kKeyUserParam1                        @"UserParam1"
//   unsigned char UserParam2;             // Wert : 0-250
#define kKeyUserParam2                        @"UserParam2"
//   unsigned char UserParam3;             // Wert : 0-250
#define kKeyUserParam3                        @"UserParam3"
//   unsigned char UserParam4;             // Wert : 0-250
#define kKeyUserParam4                        @"UserParam4"
//   unsigned char ServoNickControl;       // Wert : 0-250     // Stellung des Servos
#define kKeyServoNickControl                  @"ServoNickControl"
//   unsigned char ServoNickComp;          // Wert : 0-250     // Einfluss Gyro/Servo
#define kKeyServoNickComp                     @"ServoNickComp"
//   unsigned char ServoNickMin;           // Wert : 0-250     // Anschlag
#define kKeyServoNickMin                      @"ServoNickMin"
//   unsigned char ServoNickMax;           // Wert : 0-250     // Anschlag
#define kKeyServoNickMax                      @"ServoNickMax"
// //--- Seit V0.75
//   unsigned char ServoRollControl;       // Wert : 0-250     // Stellung des Servos
#define kKeyServoRollControl                  @"ServoRollControl"
//   unsigned char ServoRollComp;          // Wert : 0-250
#define kKeyServoRollComp                     @"ServoRollComp"
//   unsigned char ServoRollMin;           // Wert : 0-250
#define kKeyServoRollMin                      @"ServoRollMin"
//   unsigned char ServoRollMax;           // Wert : 0-250
#define kKeyServoRollMax                      @"ServoRollMax"
// //---
//   unsigned char ServoNickRefresh;       // Speed of the Servo
#define kKeyServoNickRefresh                  @"ServoNickRefresh"
//   unsigned char Servo3;             // Value or mapping of the Servo Output
#define kKeyServo3                            @"Servo3"
//   unsigned char Servo4;             // Value or mapping of the Servo Output
#define kKeyServo4                            @"Servo4"
//   unsigned char Servo5;             // Value or mapping of the Servo Output
#define kKeyServo5                            @"Servo5"
//   unsigned char LoopGasLimit;           // Wert: 0-250  max. Gas während Looping
#define kKeyLoopGasLimit                      @"LoopGasLimit"
//   unsigned char LoopThreshold;          // Wert: 0-250  Schwelle für Stickausschlag
#define kKeyLoopThreshold                     @"LoopThreshold"
//   unsigned char LoopHysterese;          // Wert: 0-250  Hysterese für Stickausschlag
#define kKeyLoopHysterese                     @"LoopHysterese"
//   unsigned char AchsKopplung1;          // Wert: 0-250  Faktor, mit dem Gier die Achsen Roll und Nick koppelt (NickRollMitkopplung)
#define kKeyAchsKopplung1                     @"AchsKopplung1"
//   unsigned char AchsKopplung2;          // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
#define kKeyAchsKopplung2                     @"AchsKopplung2"
//   unsigned char CouplingYawCorrection;  // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
#define kKeyCouplingYawCorrection             @"CouplingYawCorrection"
//   unsigned char WinkelUmschlagNick;     // Wert: 0-250  180?-Punkt
#define kKeyWinkelUmschlagNick                @"WinkelUmschlagNick"
//   unsigned char WinkelUmschlagRoll;     // Wert: 0-250  180?-Punkt
#define kKeyWinkelUmschlagRoll                @"WinkelUmschlagRoll"
//   unsigned char GyroAccAbgleich;        // 1/k  (Koppel_ACC_Wirkung)
#define kKeyGyroAccAbgleich                   @"GyroAccAbgleich"
//   unsigned char Driftkomp;
#define kKeyDriftkomp                         @"Driftkomp"
//   unsigned char DynamicStability;
#define kKeyDynamicStability                  @"DynamicStability"
//   unsigned char UserParam5;             // Wert : 0-250
#define kKeyUserParam5                        @"UserParam5"
//   unsigned char UserParam6;             // Wert : 0-250
#define kKeyUserParam6                        @"UserParam6"
//   unsigned char UserParam7;             // Wert : 0-250
#define kKeyUserParam7                        @"UserParam7"
//   unsigned char UserParam8;             // Wert : 0-250
#define kKeyUserParam8                        @"UserParam8"
// //---Output ---------------------------------------------
//   unsigned char J16Bitmask;             // for the J16 Output
#define kKeyJ16Bitmask                        @"J16Bitmask"
//   unsigned char J16Timing;              // for the J16 Output
#define kKeyJ16Timing                         @"J16Timing"
//   unsigned char J17Bitmask;             // for the J17 Output
#define kKeyJ17Bitmask                        @"J17Bitmask"
//   unsigned char J17Timing;              // for the J17 Output
#define kKeyJ17Timing                         @"J17Timing"
// // seit version V0.75c
//   unsigned char WARN_J16_Bitmask;       // for the J16 Output
#define kKeyWARN_J16_Bitmask                  @"WARN_J16_Bitmask"
//   unsigned char WARN_J17_Bitmask;       // for the J17 Output
#define kKeyWARN_J17_Bitmask                  @"WARN_J17_Bitmask"
// //---NaviCtrl---------------------------------------------
//   unsigned char NaviGpsModeControl;     // Parameters for the Naviboard
#define kKeyNaviGpsModeControl                @"NaviGpsModeControl"
//   unsigned char NaviGpsGain;
#define kKeyNaviGpsGain                       @"NaviGpsGain"
//   unsigned char NaviGpsP;
#define kKeyNaviGpsP                          @"NaviGpsP"
//   unsigned char NaviGpsI;
#define kKeyNaviGpsI                          @"NaviGpsI"
//   unsigned char NaviGpsD;
#define kKeyNaviGpsD                          @"NaviGpsD"
//   unsigned char NaviGpsPLimit;
#define kKeyNaviGpsPLimit                     @"NaviGpsPLimit"
//   unsigned char NaviGpsILimit;
#define kKeyNaviGpsILimit                     @"NaviGpsILimit"
//   unsigned char NaviGpsDLimit;
#define kKeyNaviGpsDLimit                     @"NaviGpsDLimit"
//   unsigned char NaviGpsACC;
#define kKeyNaviGpsACC                        @"NaviGpsACC"
//   unsigned char NaviGpsMinSat;
#define kKeyNaviGpsMinSat                     @"NaviGpsMinSat"
//   unsigned char NaviStickThreshold;
#define kKeyNaviStickThreshold                @"NaviStickThreshold"
//   unsigned char NaviWindCorrection;
#define kKeyNaviWindCorrection                @"NaviWindCorrection"
//   unsigned char NaviSpeedCompensation;
#define kKeyNaviSpeedCompensation             @"NaviSpeedCompensation"
//   unsigned char NaviOperatingRadius;
#define kKeyNaviOperatingRadius               @"NaviOperatingRadius"
//   unsigned char NaviAngleLimitation;
#define kKeyNaviAngleLimitation               @"NaviAngleLimitation"
//   unsigned char NaviPH_LoginTime;
#define kKeyNaviPH_LoginTime                  @"NaviPH_LoginTime"
// //---Ext.Ctrl---------------------------------------------
//   unsigned char ExternalControl;        // for serial Control
#define kKeyExternalControl                   @"ExternalControl"
// //------------------------------------------------

#define kKeyBitConfig                @"BitConfig"
//   unsigned char BitConfig;          // (war Loop-Cfg) Bitcodiert: 0x01=oben, 0x02=unten, 0x04=links, 0x08=rechts / wird getrennt behandelt
// #define CFG1_LOOP_UP				0x01
// #define CFG1_LOOP_DOWN				0x02
// #define CFG1_LOOP_LEFT				0x04
// #define CFG1_LOOP_RIGHT				0x08
// #define CFG1_MOTOR_BLINK	      0x10
// #define CFG1_MOTOR_OFF_LED1        0x20
// #define CFG1_MOTOR_OFF_LED2        0x40
#define kKeyBitConfig_LOOP_UP        @"BitConfig_LOOP_UP"
#define kKeyBitConfig_LOOP_DOWN      @"BitConfig_LOOP_DOWN"
#define kKeyBitConfig_LOOP_LEFT      @"BitConfig_LOOP_LEFT"
#define kKeyBitConfig_LOOP_RIGHT     @"BitConfig_LOOP_RIGHT"
#define kKeyBitConfig_MOTOR_BLINK    @"BitConfig_MOTOR_BLINK"
#define kKeyBitConfig_MOTOR_OFF_LED1 @"BitConfig_MOTOR_OFF_LED1"
#define kKeyBitConfig_MOTOR_OFF_LED2 @"BitConfig_MOTOR_OFF_LED2"
//   unsigned char ServoCompInvert;    // //  0x01 = Nick, 0x02 = Roll   0 oder 1  // WICHTIG!!! am Ende lassen
#define kKeyServoCompInvert_Nick     @"ServoCompInvert_Nick"
#define kKeyServoCompInvert_ROLL     @"ServoCompInvert_ROLL"
//   unsigned char ExtraConfig;        // bitcodiert
// #define CFG2_HEIGHT_LIMIT			0x01
// #define CFG2_VARIO_BEEP				0x02
// #define CFG2_SENSITIVE_RC			0x04
#define kKeyExtraConfig @"ExtraConfig"
#define kKeyExtraConfig_HEIGHT_LIMIT @"ExtraConfig_HEIGHT_LIMIT"
#define kKeyExtraConfig_VARIO_BEEP   @"ExtraConfig_VARIO_BEEP"
#define kKeyExtraConfig_SENSITIVE_RC @"ExtraConfig_SENSITIVE_RC"
//   char Name[12];
#define kKeyName                     @"Name"


