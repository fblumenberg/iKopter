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

typedef enum {
  kIKMkAddressAll   =0,
  kIKMkAddressFC    =1,
  kIKMkAddressNC    =2,
  kIKMkAddressMK3MAg=3,
  kIKMkAddressMKGPS =0XFE
} IKMkAddress;

//////////////////////////////////////////////////////////////////////////////////
typedef enum {
  MKCommandDebugValueRequest='d',
  MKCommandDebugValueResponse='D',
  MKCommandDebugLabelRequest='a',
  MKCommandDebugLabelResponse='A',
  MKCommandVersionRequest='v',
  MKCommandVersionResponse='V',
  MKCommandLcdMenuRequest='l',
  MKCommandLcdMenuResponse='L',
  MKCommandLcdRequest='h',
  MKCommandLcdResponse='H',
  MKCommandReadSettingsRequest='q',
  MKCommandReadSettingsResponse='Q',
  MKCommandWriteSettingsRequest='s',
  MKCommandWriteSettingsResponse='S',
  MKCommandChangeSettingsRequest='f',
  MKCommandChangeSettingsResponse='F',
  MKCommandChannelsValueRequest='p',
  MKCommandChannelsValueResponse='P',
  MKCommandMixerReadRequest='n',
  MKCommandMixerReadResponse='N',
  MKCommandMixerWriteRequest='m',
  MKCommandMixerWriteResponse='M',
  MKCommandRedirectRequest='u',
  MKCommandEngineTestRequest='t',
  MKCommandOsdRequest='o',
  MKCommandOsdResponse='O',
  MKCommandData3DRequest='c',
  MKCommandData3DResponse='C',
  MKCommandReadPointRequest='x',
  MKCommandReadPointResponse='X',
  MKCommandWritePointRequest='w',
  MKCommandWritePointResponse='W',
  MKCommandSendPointRequest='s',
  MKCommandMotorDataRequest='k',
  MKCommandMotorDataResponse='K',
  
} MKCommandId;

//////////////////////////////////////////////////////////////////////////////////

// FC hardware errors

// bitmask for UART_VersionInfo_t.HardwareError[0]
#define FC_ERROR0_GYRO_NICK     0x01
#define FC_ERROR0_GYRO_ROLL     0x02
#define FC_ERROR0_GYRO_YAW              0x04
#define FC_ERROR0_ACC_NICK              0x08
#define FC_ERROR0_ACC_ROLL              0x10
#define FC_ERROR0_ACC_TOP               0x20
#define FC_ERROR0_PRESSURE              0x40
#define FC_ERROR0_CAREFREE              0x80
// bitmask for UART_VersionInfo_t.HardwareError[1]
#define FC_ERROR1_I2C                   0x01
#define FC_ERROR1_BL_MISSING    0x02
#define FC_ERROR1_SPI_RX                0x04
#define FC_ERROR1_PPM                   0x08
#define FC_ERROR1_MIXER                 0x10
#define FC_ERROR1_RES1                  0x20
#define FC_ERROR1_RES2                  0x40
#define FC_ERROR1_RES3                  0x80

// NC hardware errors
#define NC_ERROR0_SPI_RX                                0x01
#define NC_ERROR0_COMPASS_RX                    0x02
#define NC_ERROR0_FC_INCOMPATIBLE               0x04
#define NC_ERROR0_COMPASS_INCOMPATIBLE  0x08
#define NC_ERROR0_GPS_RX                                0x10
#define NC_ERROR0_COMPASS_VALUE                 0x20

typedef struct
{
  uint8_t SWMajor;
  uint8_t SWMinor;
  uint8_t ProtoMajor;
  uint8_t ProtoMinor;
  uint8_t SWPatch;
  uint8_t HardwareError[5];
} IKMkVersionInfo;

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
typedef struct
{
  uint8_t Digital[2];
  uint16_t Analog[32];    // Debugvalues
} IKMkDebugOut;

static const int kMaxDebugDataDigital = 2;
static const int kMaxDebugDataAnalog = 32;

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

#define MIX_GAS     0
#define MIX_NICK    1
#define MIX_ROLL    2
#define MIX_YAW     3

typedef struct
{
    uint8_t Revision;
    int8_t Name[12];
    int8_t Motor[16][4];
    uint8_t crc;
} IKMkMixerTable;

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//GlobalConfig3
#define CFG3_NO_SDCARD_NO_START  0x01
#define CFG3_DPH_MAX_RADIUS      0x02
#define CFG3_VARIO_FAILSAFE      0x04

#define CFG_HOEHENREGELUNG       0x01
#define CFG_HOEHEN_SCHALTER      0x02
#define CFG_HEADING_HOLD         0x04
#define CFG_KOMPASS_AKTIV        0x08
#define CFG_KOMPASS_FIX          0x10
#define CFG_GPS_AKTIV            0x20
#define CFG_ACHSENKOPPLUNG_AKTIV 0x40
#define CFG_DREHRATEN_BEGRENZER  0x80

#define CFG_LOOP_OBEN            0x01
#define CFG_LOOP_UNTEN           0x02
#define CFG_LOOP_LINKS           0x04
#define CFG_LOOP_RECHTS          0x08
#define CFG_MOTOR_BLINK1         0x10
#define CFG_MOTOR_OFF_LED1       0x20
#define CFG_MOTOR_OFF_LED2       0x40
#define CFG_MOTOR_BLINK2         0x80

#define CFG2_HEIGHT_LIMIT        0x01
#define CFG2_VARIO_BEEP          0x02
#define CFG_SENSITIVE_RC         0x04
#define CFG_3_3V_REFERENCE       0x08
#define CFG_NO_RCOFF_BEEPING     0x10
#define CFG_GPS_AID   		     	 0x20
#define CFG_LEARNABLE_CAREFREE   0x40
#define CFG_IGNORE_MAG_ERR_AT_STARTUP   0x80

#define CFG_SERVOCOMPINVERT_NICK 0x01
#define CFG_SERVOCOMPINVERT_ROLL 0x02


// bit mask for ParamSet.Config0
#define CFG0_AIRPRESS_SENSOR        0x01
#define CFG0_HEIGHT_SWITCH          0x02
#define CFG0_HEADING_HOLD           0x04
#define CFG0_COMPASS_ACTIVE         0x08
#define CFG0_COMPASS_FIX            0x10
#define CFG0_GPS_ACTIVE             0x20
#define CFG0_AXIS_COUPLING_ACTIVE   0x40
#define CFG0_ROTARY_RATE_LIMITER    0x80

// defines for the receiver selection
#define RECEIVER_PPM                0
#define RECEIVER_SPEKTRUM           1
#define RECEIVER_SPEKTRUM_HI_RES    2
#define RECEIVER_SPEKTRUM_LOW_RES   3
#define RECEIVER_JETI               4
#define RECEIVER_ACT_DSL            5
#define RECEIVER_HOTT               6
#define RECEIVER_SBUS               7
#define RECEIVER_USER               8
#define RECEIVER_UNKNOWN            0xFF

// defines for lookup ParamSet.ChannelAssignment
#define K_NICK    0
#define K_ROLL    1
#define K_GAS     2
#define K_GIER    3
#define K_POTI1   4
#define K_POTI2   5
#define K_POTI3   6
#define K_POTI4   7
#define K_POTI5   8
#define K_POTI6   9
#define K_POTI7   10
#define K_POTI8   11


// values above 247 representing poti1 to poti8
// poti1 = 255
// poti2 = 254
// poti3 = 253
// poti4 = 252
// poti5 = 251
// poti6 = 250
// poti7 = 249
// poti8 = 248


typedef struct
{
    unsigned char Index;
    unsigned char Revision;
    unsigned char Kanalbelegung[12];       // GAS[0], GIER[1],NICK[2], ROLL[3], POTI1, POTI2, POTI3
    unsigned char GlobalConfig;           // 0x01=H�henregler aktiv,0x02=Kompass aktiv, 0x04=GPS aktiv, 0x08=Heading Hold aktiv
    unsigned char Hoehe_MinGas;           // Wert : 0-100
    unsigned char Luftdruck_D;            // Wert : 0-250
    unsigned char MaxHoehe;               // Wert : 0-32
    unsigned char Hoehe_P;                // Wert : 0-32
    unsigned char Hoehe_Verstaerkung;     // Wert : 0-50
    unsigned char Hoehe_ACC_Wirkung;      // Wert : 0-250
    unsigned char Hoehe_HoverBand;        // Wert : 0-250
    unsigned char Hoehe_GPS_Z;            // Wert : 0-250
    unsigned char Hoehe_StickNeutralPoint;// Wert : 0-250
    unsigned char Stick_P;                // Wert : 1-6
    unsigned char Stick_D;                // Wert : 0-64
    unsigned char Gier_P;                 // Wert : 1-20
    unsigned char Gas_Min;                // Wert : 0-32
    unsigned char Gas_Max;                // Wert : 33-250
    unsigned char GyroAccFaktor;          // Wert : 1-64
    unsigned char KompassWirkung;         // Wert : 0-32
    unsigned char Gyro_P;                 // Wert : 10-250
    unsigned char Gyro_I;                 // Wert : 0-250
    unsigned char Gyro_D;                 // Wert : 0-250
    unsigned char Gyro_Gier_P;            // Wert : 10-250
    unsigned char Gyro_Gier_I;            // Wert : 0-250
    unsigned char Gyro_Stability;         // Wert : 0-16
    unsigned char UnterspannungsWarnung;  // Wert : 0-250
    unsigned char NotGas;                 // Wert : 0-250     //Gaswert bei Emp�ngsverlust
    unsigned char NotGasZeit;             // Wert : 0-250     // Zeitbis auf NotGas geschaltet wird, wg. Rx-Problemen
    unsigned char Receiver;               // 0= Summensignal, 1= Spektrum, 2 =Jeti, 3=ACT DSL, 4=ACT S3D
    unsigned char I_Faktor;               // Wert : 0-250
    unsigned char UserParam1;             // Wert : 0-250
    unsigned char UserParam2;             // Wert : 0-250
    unsigned char UserParam3;             // Wert : 0-250
    unsigned char UserParam4;             // Wert : 0-250
    unsigned char ServoNickControl;       // Wert : 0-250     // Stellung des Servos
    unsigned char ServoNickComp;          // Wert : 0-250     // Einfluss Gyro/Servo
    unsigned char ServoNickMin;           // Wert : 0-250     // Anschlag
    unsigned char ServoNickMax;           // Wert : 0-250     // Anschlag
    //--- Seit V0.75
    unsigned char ServoRollControl;       // Wert : 0-250     // Stellung des Servos
    unsigned char ServoRollComp;          // Wert : 0-250
    unsigned char ServoRollMin;           // Wert : 0-250
    unsigned char ServoRollMax;           // Wert : 0-250
    //---
    unsigned char ServoNickRefresh;       // Speed of the Servo
    unsigned char ServoManualControlSpeed;//
    unsigned char CamOrientation;         //
    unsigned char Servo3;                // Value or mapping of the Servo Output
    unsigned char Servo4;                    // Value or mapping of the Servo Output
    unsigned char Servo5;                    // Value or mapping of the Servo Output
    unsigned char LoopGasLimit;           // Wert: 0-250  max. Gas w�hrend Looping
    unsigned char LoopThreshold;          // Wert: 0-250  Schwelle f�r Stickausschlag
    unsigned char LoopHysterese;          // Wert: 0-250  Hysterese f�r Stickausschlag
    unsigned char AchsKopplung1;          // Wert: 0-250  Faktor, mit dem Gier die Achsen Roll und Nick koppelt (NickRollMitkopplung)
    unsigned char AchsKopplung2;          // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
    unsigned char CouplingYawCorrection;  // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
    unsigned char WinkelUmschlagNick;     // Wert: 0-250  180�-Punkt
    unsigned char WinkelUmschlagRoll;     // Wert: 0-250  180�-Punkt
    unsigned char GyroAccAbgleich;        // 1/k  (Koppel_ACC_Wirkung)
    unsigned char Driftkomp;
    unsigned char DynamicStability;
    unsigned char UserParam5;             // Wert : 0-250
    unsigned char UserParam6;             // Wert : 0-250   
    unsigned char UserParam7;             // Wert : 0-250
    unsigned char UserParam8;             // Wert : 0-250
    //---Output ---------------------------------------------
    unsigned char J16Bitmask;             // for the J16 Output
    unsigned char J16Timing;              // for the J16 Output
    unsigned char J17Bitmask;             // for the J17 Output
    unsigned char J17Timing;              // for the J17 Output
    // seit version V0.75c
    unsigned char WARN_J16_Bitmask;       // for the J16 Output
    unsigned char WARN_J17_Bitmask;       // for the J17 Output
    //---NaviCtrl---------------------------------------------
    unsigned char NaviGpsModeControl;     // Parameters for the Naviboard
    unsigned char NaviGpsGain;
    unsigned char NaviGpsP;
    unsigned char NaviGpsI;
    unsigned char NaviGpsD;
    unsigned char NaviGpsPLimit;
    unsigned char NaviGpsILimit;
    unsigned char NaviGpsDLimit;
    unsigned char NaviGpsACC;
    unsigned char NaviGpsMinSat;
    unsigned char NaviStickThreshold;
    unsigned char NaviWindCorrection;
    unsigned char NaviSpeedCompensation;
    unsigned char NaviOperatingRadius;
    unsigned char NaviAngleLimitation;
    unsigned char NaviPH_LoginTime;
    //---Ext.Ctrl---------------------------------------------
    unsigned char ExternalControl;         // for serial Control
    //---CareFree---------------------------------------------
    unsigned char OrientationAngle;        // Where is the front-direction?
    unsigned char OrientationModeControl;  // switch for CareFree
    unsigned char MotorSafetySwitch;
    //------------------------------------------------
    unsigned char BitConfig;          // (war Loop-Cfg) Bitcodiert: 0x01=oben, 0x02=unten, 0x04=links, 0x08=rechts / wird getrennt behandelt
    unsigned char ServoCompInvert;    // //  0x01 = Nick, 0x02 = Roll   0 oder 1  // WICHTIG!!! am Ende lassen
    unsigned char ExtraConfig;        // bitcodiert
    char Name[12];
//    unsigned char crc;                // must be the last byte!
} IKMkParamset85;

typedef struct
{
  unsigned char Index;
	unsigned char Revision;
	unsigned char Kanalbelegung[12];       // GAS[0], GIER[1],NICK[2], ROLL[3], POTI1, POTI2, POTI3
	unsigned char GlobalConfig;           // 0x01=Hˆhenregler aktiv,0x02=Kompass aktiv, 0x04=GPS aktiv, 0x08=Heading Hold aktiv
	unsigned char Hoehe_MinGas;           // Wert : 0-100
	unsigned char Luftdruck_D;            // Wert : 0-250
	unsigned char MaxHoehe;               // Wert : 0-32
	unsigned char Hoehe_P;                // Wert : 0-32
	unsigned char Hoehe_Verstaerkung;     // Wert : 0-50
	unsigned char Hoehe_ACC_Wirkung;      // Wert : 0-250
	unsigned char Hoehe_HoverBand;        // Wert : 0-250
	unsigned char Hoehe_GPS_Z;            // Wert : 0-250
	unsigned char Hoehe_StickNeutralPoint;// Wert : 0-250
	unsigned char Stick_P;                // Wert : 1-6
	unsigned char Stick_D;                // Wert : 0-64
	unsigned char StickGier_P;            // Wert : 1-20
	unsigned char Gas_Min;                // Wert : 0-32
	unsigned char Gas_Max;                // Wert : 33-250
	unsigned char GyroAccFaktor;          // Wert : 1-64
	unsigned char KompassWirkung;         // Wert : 0-32
	unsigned char Gyro_P;                 // Wert : 10-250
	unsigned char Gyro_I;                 // Wert : 0-250
	unsigned char Gyro_D;                 // Wert : 0-250
	unsigned char Gyro_Gier_P;            // Wert : 10-250
	unsigned char Gyro_Gier_I;            // Wert : 0-250
	unsigned char Gyro_Stability;         // Wert : 0-16
	unsigned char UnterspannungsWarnung;  // Wert : 0-250
	unsigned char NotGas;                 // Wert : 0-250     //Gaswert bei Emp‰ngsverlust
	unsigned char NotGasZeit;             // Wert : 0-250     // Zeitbis auf NotGas geschaltet wird, wg. Rx-Problemen
	unsigned char Receiver;         	  // 0= Summensignal, 1= Spektrum, 2 =Jeti, 3=ACT DSL, 4=ACT S3D
	unsigned char I_Faktor;               // Wert : 0-250
	unsigned char UserParam1;             // Wert : 0-250
	unsigned char UserParam2;             // Wert : 0-250
	unsigned char UserParam3;             // Wert : 0-250
	unsigned char UserParam4;             // Wert : 0-250
	unsigned char ServoNickControl;       // Wert : 0-250     // Stellung des Servos
	unsigned char ServoNickComp;          // Wert : 0-250     // Einfluss Gyro/Servo
	unsigned char ServoNickMin;           // Wert : 0-250     // Anschlag
	unsigned char ServoNickMax;           // Wert : 0-250     // Anschlag
	//--- Seit V0.75
	unsigned char ServoRollControl;       // Wert : 0-250     // Stellung des Servos
	unsigned char ServoRollComp;          // Wert : 0-250
	unsigned char ServoRollMin;           // Wert : 0-250
	unsigned char ServoRollMax;           // Wert : 0-250
	//---
	unsigned char ServoNickRefresh;       // Speed of the Servo
  unsigned char ServoManualControlSpeed;//
  unsigned char CamOrientation;         //
	unsigned char Servo3;        		 // Value or mapping of the Servo Output
	unsigned char Servo4;       			 // Value or mapping of the Servo Output
	unsigned char Servo5;       			 // Value or mapping of the Servo Output
	unsigned char LoopGasLimit;           // Wert: 0-250  max. Gas w‰hrend Looping
	unsigned char LoopThreshold;          // Wert: 0-250  Schwelle f¸r Stickausschlag
	unsigned char LoopHysterese;          // Wert: 0-250  Hysterese f¸r Stickausschlag
	unsigned char AchsKopplung1;          // Wert: 0-250  Faktor, mit dem Gier die Achsen Roll und Nick koppelt (NickRollMitkopplung)
	unsigned char AchsKopplung2;          // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
	unsigned char CouplingYawCorrection;  // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
	unsigned char WinkelUmschlagNick;     // Wert: 0-250  180∞-Punkt
	unsigned char WinkelUmschlagRoll;     // Wert: 0-250  180∞-Punkt
	unsigned char GyroAccAbgleich;        // 1/k  (Koppel_ACC_Wirkung)
	unsigned char Driftkomp;
	unsigned char DynamicStability;
	unsigned char UserParam5;             // Wert : 0-250
	unsigned char UserParam6;             // Wert : 0-250
	unsigned char UserParam7;             // Wert : 0-250
	unsigned char UserParam8;             // Wert : 0-250
	//---Output ---------------------------------------------
	unsigned char J16Bitmask;             // for the J16 Output
	unsigned char J16Timing;              // for the J16 Output
	unsigned char J17Bitmask;             // for the J17 Output
	unsigned char J17Timing;              // for the J17 Output
	// seit version V0.75c
	unsigned char WARN_J16_Bitmask;       // for the J16 Output
	unsigned char WARN_J17_Bitmask;       // for the J17 Output
	//---NaviCtrl---------------------------------------------
	unsigned char NaviGpsModeControl;     // Parameters for the Naviboard
	unsigned char NaviGpsGain;
	unsigned char NaviGpsP;
	unsigned char NaviGpsI;
	unsigned char NaviGpsD;
	unsigned char NaviGpsPLimit;
	unsigned char NaviGpsILimit;
	unsigned char NaviGpsDLimit;
	unsigned char NaviGpsACC;
	unsigned char NaviGpsMinSat;
	unsigned char NaviStickThreshold;
	unsigned char NaviWindCorrection;
	unsigned char NaviAccCompensation;    // New since 0.86 -> was: SpeedCompensation
	unsigned char NaviOperatingRadius;
	unsigned char NaviAngleLimitation;
	unsigned char NaviPH_LoginTime;
	//---Ext.Ctrl---------------------------------------------
	unsigned char ExternalControl;         // for serial Control
	//---CareFree---------------------------------------------
	unsigned char OrientationAngle;        // Where is the front-direction?
	unsigned char CareFreeModeControl;	   // switch for CareFree
  unsigned char MotorSafetySwitch;
  unsigned char MotorSmooth;
  unsigned char ComingHomeAltitude;
  unsigned char FailSafeTime;
  unsigned char MaxAltitude;
	//------------------------------------------------
	unsigned char BitConfig;          // (war Loop-Cfg) Bitcodiert: 0x01=oben, 0x02=unten, 0x04=links, 0x08=rechts / wird getrennt behandelt
	unsigned char ServoCompInvert;    // //  0x01 = Nick, 0x02 = Roll   0 oder 1  // WICHTIG!!! am Ende lassen
	unsigned char ExtraConfig;        // bitcodiert
	char Name[12];
//	unsigned char crc;				  // must be the last byte!
} IKMkParamset88;


typedef struct
{
  unsigned char Index;
	unsigned char Revision;
	unsigned char Kanalbelegung[12];       // GAS[0], GIER[1],NICK[2], ROLL[3], POTI1, POTI2, POTI3
	unsigned char GlobalConfig;           // 0x01=Hˆhenregler aktiv,0x02=Kompass aktiv, 0x04=GPS aktiv, 0x08=Heading Hold aktiv
	unsigned char Hoehe_MinGas;           // Wert : 0-100
	unsigned char Luftdruck_D;            // Wert : 0-250
	unsigned char MaxHoehe;               // Wert : 0-32
	unsigned char Hoehe_P;                // Wert : 0-32
	unsigned char Hoehe_Verstaerkung;     // Wert : 0-50
	unsigned char Hoehe_ACC_Wirkung;      // Wert : 0-250
	unsigned char Hoehe_HoverBand;        // Wert : 0-250
	unsigned char Hoehe_GPS_Z;            // Wert : 0-250
	unsigned char Hoehe_StickNeutralPoint;// Wert : 0-250
	unsigned char Stick_P;                // Wert : 1-6
	unsigned char Stick_D;                // Wert : 0-64
	unsigned char StickGier_P;            // Wert : 1-20
	unsigned char Gas_Min;                // Wert : 0-32
	unsigned char Gas_Max;                // Wert : 33-250
	unsigned char GyroAccFaktor;          // Wert : 1-64
	unsigned char KompassWirkung;         // Wert : 0-32
	unsigned char Gyro_P;                 // Wert : 10-250
	unsigned char Gyro_I;                 // Wert : 0-250
	unsigned char Gyro_D;                 // Wert : 0-250
	unsigned char Gyro_Gier_P;            // Wert : 10-250
	unsigned char Gyro_Gier_I;            // Wert : 0-250
	unsigned char Gyro_Stability;         // Wert : 0-16
	unsigned char UnterspannungsWarnung;  // Wert : 0-250
	unsigned char NotGas;                 // Wert : 0-250     //Gaswert bei Emp‰ngsverlust
	unsigned char NotGasZeit;             // Wert : 0-250     // Zeitbis auf NotGas geschaltet wird, wg. Rx-Problemen
	unsigned char Receiver;         	  // 0= Summensignal, 1= Spektrum, 2 =Jeti, 3=ACT DSL, 4=ACT S3D
	unsigned char I_Faktor;               // Wert : 0-250
	unsigned char UserParam1;             // Wert : 0-250
	unsigned char UserParam2;             // Wert : 0-250
	unsigned char UserParam3;             // Wert : 0-250
	unsigned char UserParam4;             // Wert : 0-250
	unsigned char ServoNickControl;       // Wert : 0-250     // Stellung des Servos
	unsigned char ServoNickComp;          // Wert : 0-250     // Einfluss Gyro/Servo
	unsigned char ServoNickMin;           // Wert : 0-250     // Anschlag
	unsigned char ServoNickMax;           // Wert : 0-250     // Anschlag
	//--- Seit V0.75
	unsigned char ServoRollControl;       // Wert : 0-250     // Stellung des Servos
	unsigned char ServoRollComp;          // Wert : 0-250
	unsigned char ServoRollMin;           // Wert : 0-250
	unsigned char ServoRollMax;           // Wert : 0-250
	//---
	unsigned char ServoNickRefresh;       // Speed of the Servo
  unsigned char ServoManualControlSpeed;//
  unsigned char CamOrientation;         //
	unsigned char Servo3;        		 // Value or mapping of the Servo Output
	unsigned char Servo4;       			 // Value or mapping of the Servo Output
	unsigned char Servo5;       			 // Value or mapping of the Servo Output
	unsigned char LoopGasLimit;           // Wert: 0-250  max. Gas w‰hrend Looping
	unsigned char LoopThreshold;          // Wert: 0-250  Schwelle f¸r Stickausschlag
	unsigned char LoopHysterese;          // Wert: 0-250  Hysterese f¸r Stickausschlag
	unsigned char AchsKopplung1;          // Wert: 0-250  Faktor, mit dem Gier die Achsen Roll und Nick koppelt (NickRollMitkopplung)
	unsigned char AchsKopplung2;          // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
	unsigned char CouplingYawCorrection;  // Wert: 0-250  Faktor, mit dem Nick und Roll verkoppelt werden
	unsigned char WinkelUmschlagNick;     // Wert: 0-250  180∞-Punkt
	unsigned char WinkelUmschlagRoll;     // Wert: 0-250  180∞-Punkt
	unsigned char GyroAccAbgleich;        // 1/k  (Koppel_ACC_Wirkung)
	unsigned char Driftkomp;
	unsigned char DynamicStability;
	unsigned char UserParam5;             // Wert : 0-250
	unsigned char UserParam6;             // Wert : 0-250
	unsigned char UserParam7;             // Wert : 0-250
	unsigned char UserParam8;             // Wert : 0-250
	//---Output ---------------------------------------------
	unsigned char J16Bitmask;             // for the J16 Output
	unsigned char J16Timing;              // for the J16 Output
	unsigned char J17Bitmask;             // for the J17 Output
	unsigned char J17Timing;              // for the J17 Output
	// seit version V0.75c
	unsigned char WARN_J16_Bitmask;       // for the J16 Output
	unsigned char WARN_J17_Bitmask;       // for the J17 Output
	//---NaviCtrl---------------------------------------------
	unsigned char NaviGpsModeControl;     // Parameters for the Naviboard
	unsigned char NaviGpsGain;
	unsigned char NaviGpsP;
	unsigned char NaviGpsI;
	unsigned char NaviGpsD;
	unsigned char NaviGpsPLimit;
	unsigned char NaviGpsILimit;
	unsigned char NaviGpsDLimit;
	unsigned char NaviGpsACC;
	unsigned char NaviGpsMinSat;
	unsigned char NaviStickThreshold;
	unsigned char NaviWindCorrection;
	unsigned char NaviAccCompensation;    // New since 0.86 -> was: SpeedCompensation
	unsigned char NaviOperatingRadius;
	unsigned char NaviAngleLimitation;
	unsigned char NaviPH_LoginTime;
	//---Ext.Ctrl---------------------------------------------
	unsigned char ExternalControl;         // for serial Control
	//---CareFree---------------------------------------------
	unsigned char OrientationAngle;        // Where is the front-direction?
	unsigned char CareFreeModeControl;	   // switch for CareFree
  unsigned char MotorSafetySwitch;
  unsigned char MotorSmooth;
  unsigned char ComingHomeAltitude;
  unsigned char FailSafeTime;
  unsigned char MaxAltitude;
	unsigned char FailsafeChannel;         // if the value of this channel is > 100, the MK reports "RC-Lost"
	unsigned char ServoFilterNick;  
	unsigned char ServoFilterRoll;  
	//------------------------------------------------
	unsigned char BitConfig;          // (war Loop-Cfg) Bitcodiert: 0x01=oben, 0x02=unten, 0x04=links, 0x08=rechts / wird getrennt behandelt
	unsigned char ServoCompInvert;    // //  0x01 = Nick, 0x02 = Roll   0 oder 1  // WICHTIG!!! am Ende lassen
	unsigned char ExtraConfig;        // bitcodiert
	unsigned char GlobalConfig3;      // bitcodiert
	char Name[12];
//	unsigned char crc;				  // must be the last byte!
} IKMkParamset90;


#define EEPARAM_REVISION	88 // is count up, if paramater stucture has changed (compatibility)

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

typedef struct 
{
  int16_t  Winkel[3]; // nick, roll, compass in 0,1�
  int8_t   Centroid[3];
  int8_t   reserve[5];
} IKMkData3D;

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

typedef struct
{
  uint8_t Digital[2];
  uint8_t RemoteButtons;
  int8_t  Nick;
  int8_t  Roll;
  int8_t  Yaw;
  uint8_t Gas;
  int8_t  Height;
  uint8_t free;
  uint8_t Frame;
  uint8_t Config;
} __attribute__((packed)) IKMkExternControl;

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

typedef struct
{
  int16_t Nick;
  int16_t Roll;
  int16_t Compass;          // angle between north and head of the MK
} __attribute__((packed)) Attitude_t;


#define	INVALID		0x00
#define NEWDATA		0x01
#define PROCESSED	0x02

typedef struct
{
  int32_t Longitude;      // in 1E-7 deg
  int32_t Latitude;       // in 1E-7 deg
  int32_t Altitude;       // in mm
  uint8_t Status;         // validity of data
} __attribute__((packed)) IKMkGPSPos;


typedef struct
{
  uint16_t Distance;      // distance to target in dm
  int16_t Bearing;        // course to target in deg
} __attribute__((packed)) IKMkGPSPosDev;

#define NAVIDATA_VERSION 5

typedef struct
{
  uint8_t       Version;            // version of the data structure
  IKMkGPSPos    CurrentPosition;    // see ubx.h for details
  IKMkGPSPos    TargetPosition;
  IKMkGPSPosDev TargetPositionDeviation;
  IKMkGPSPos    HomePosition;
  IKMkGPSPosDev HomePositionDeviation;
  uint8_t       WaypointIndex;        // index of current waypoints running from 0 to WaypointNumber-1
  uint8_t       WaypointNumber;       // number of stored waypoints
  uint8_t       SatsInUse;          // number of satellites used for position solution
  int16_t       Altimeter;          // hight according to air pressure
  int16_t       Variometer;         // climb(+) and sink(-) rate
  uint16_t      FlyingTime;         // in seconds
  uint8_t       UBat;           // Battery Voltage in 0.1 Volts
  uint16_t      GroundSpeed;        // speed over ground in cm/s (2D)
  int16_t       Heading;          // current flight direction in � as angle to north
  int16_t       CompassHeading;       // current compass value in �
  int8_t        AngleNick;          // current Nick angle in 1�
  int8_t        AngleRoll;          // current Rick angle in 1�
  uint8_t       RC_Quality;         // RC_Quality
  uint8_t       FCStatusFlags;        // Flags from FC
  uint8_t       NCFlags;          // Flags from NC
  uint8_t       Errorcode;          // 0 --> okay
  uint8_t       OperatingRadius;      // current operation radius around the Home Position in m
  int16_t       TopSpeed;         // velocity in vertical direction in cm/s
  uint8_t       TargetHoldTime;       // time in s to stay at the given target, counts down to 0 if target has been reached
  uint8_t       FCStatusFlags2;				// StatusFlags2 (since version 5 added)
  int16_t       SetpointAltitude;     // setpoint for altitude
  uint8_t       Gas;            // for future use
  uint16_t      Current;          // actual current in 0.1A steps
  uint16_t      UsedCapacity;       // used capacity in mAh
} __attribute__((packed)) IKMkNaviData;

#define NC_FLAG_FREE            0x01
#define NC_FLAG_PH              0x02
#define NC_FLAG_CH              0x04
#define NC_FLAG_RANGE_LIMIT     0x08
#define NC_FLAG_NOSERIALLINK    0x10
#define NC_FLAG_TARGET_REACHED  0x20
#define NC_FLAG_MANUAL_CONTROL  0x40
#define NC_FLAG_GPS_OK          0x80

// FC STATUS FLAGS
#define FC_STATUS_MOTOR_RUN           0x01
#define FC_STATUS_FLY                 0x02
#define FC_STATUS_CALIBRATE           0x04
#define FC_STATUS_START               0x08
#define FC_STATUS_EMERGENCY_LANDING   0x10
#define FC_STATUS_LOWBAT              0x20
#define FC_STATUS_VARIO_TRIM_UP       0x40
#define FC_STATUS_VARIO_TRIM_DOWN     0x80

#define POINT_TYPE_INVALID 255
#define POINT_TYPE_WP	0
#define POINT_TYPE_POI	1

#define WP_EVFLAG_CAMERA_NICK_CONTROL 0x01

typedef struct
{
 	IKMkGPSPos  Position;         // the gps position of the waypoint, see ubx.h for details
	int16_t     Heading;          // orientation, 0 no action, 1...360 fix heading, neg. = Index to POI in WP List
	uint8_t     ToleranceRadius;	// in meters, if the MK is within that range around the target, then the next target is triggered
	uint8_t     HoldTime;         // in seconds, if the was once in the tolerance area around a WP, this time defines the delay before the next WP is triggered
	uint8_t     Event_Flag;       // future implementation
	uint8_t     Index;            // to indentify different waypoints, workaround for bad communications PC <-> NC
	uint8_t     Type;             // typeof Waypoint
	uint8_t     WP_EventChannelValue;  //
	uint8_t     AltitudeRate;     // rate to change the setpoint
	uint8_t     Speed;            // rate to change the Position
	uint8_t     CamAngle;		      // Camera servo angle
	uint8_t     Name[4];		      // Name of that point (ASCII)
	uint8_t     reserve[2];		    // reserve
} __attribute__((packed)) IKMkPoint;

// FC STATUS FLAGS2
#define FC_STATUS2_CAREFREE             0x01
#define FC_STATUS2_ALTITUDE_CONTROL     0x02
#define FC_STATUS2_RC_FAILSAVE_ACTIVE   0x04
#define FC_STATUS2_OUT1_ACTIVE       		0x08
#define FC_STATUS2_OUT2_ACTIVE       		0x10


typedef struct
{
  uint8_t Index;
  uint8_t Current;
  uint8_t Temperature;
  uint8_t MaxPWM;
  uint8_t State;
} __attribute__((packed)) IKMkMotor;
