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

#import "NSData+MKPayloadEncode.h"
#import "MKDatatypes.h"
#import "MKDataConstants.h"

@implementation NSData (MKPayloadEncodeSetting)

+ (NSData *) payloadForWriteSettingRequest:(NSDictionary *)theDictionary;
{
  MKSetting  setting;
  setting.Kanalbelegung[ 0]=[[theDictionary objectForKey:kKeyKanalbelegung00] unsignedCharValue];
  setting.Kanalbelegung[ 1]=[[theDictionary objectForKey:kKeyKanalbelegung01] unsignedCharValue];
  setting.Kanalbelegung[ 2]=[[theDictionary objectForKey:kKeyKanalbelegung02] unsignedCharValue];
  setting.Kanalbelegung[ 3]=[[theDictionary objectForKey:kKeyKanalbelegung03] unsignedCharValue];
  setting.Kanalbelegung[ 4]=[[theDictionary objectForKey:kKeyKanalbelegung04] unsignedCharValue];
  setting.Kanalbelegung[ 5]=[[theDictionary objectForKey:kKeyKanalbelegung05] unsignedCharValue];
  setting.Kanalbelegung[ 6]=[[theDictionary objectForKey:kKeyKanalbelegung06] unsignedCharValue];
  setting.Kanalbelegung[ 7]=[[theDictionary objectForKey:kKeyKanalbelegung07] unsignedCharValue];
  setting.Kanalbelegung[ 8]=[[theDictionary objectForKey:kKeyKanalbelegung08] unsignedCharValue];
  setting.Kanalbelegung[ 9]=[[theDictionary objectForKey:kKeyKanalbelegung09] unsignedCharValue];
  setting.Kanalbelegung[10]=[[theDictionary objectForKey:kKeyKanalbelegung10] unsignedCharValue];
  setting.Kanalbelegung[11]=[[theDictionary objectForKey:kKeyKanalbelegung11] unsignedCharValue];
  
  setting.GlobalConfig=0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_HOEHENREGELUNG      ] boolValue]?CFG_HOEHENREGELUNG      :0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_HOEHEN_SCHALTER     ] boolValue]?CFG_HOEHEN_SCHALTER     :0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_HEADING_HOLD        ] boolValue]?CFG_HEADING_HOLD        :0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_KOMPASS_AKTIV       ] boolValue]?CFG_KOMPASS_AKTIV       :0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_KOMPASS_FIX         ] boolValue]?CFG_KOMPASS_FIX         :0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_GPS_AKTIV           ] boolValue]?CFG_GPS_AKTIV           :0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_ACHSENKOPPLUNG_AKTIV] boolValue]?CFG_ACHSENKOPPLUNG_AKTIV:0;
  setting.GlobalConfig|= [[theDictionary objectForKey:kKeyGlobalConfig_DREHRATEN_BEGRENZER ] boolValue]?CFG_DREHRATEN_BEGRENZER :0;
  
  setting.Hoehe_MinGas=[[theDictionary objectForKey:kKeyHoehe_MinGas ] unsignedCharValue];
  setting.Luftdruck_D=[[theDictionary objectForKey:kKeyLuftdruck_D ] unsignedCharValue];
  setting.MaxHoehe=[[theDictionary objectForKey:kKeyMaxHoehe ] unsignedCharValue];
  setting.Hoehe_P=[[theDictionary objectForKey:kKeyHoehe_P ] unsignedCharValue];
  setting.Hoehe_Verstaerkung=[[theDictionary objectForKey:kKeyHoehe_Verstaerkung ] unsignedCharValue];
  setting.Hoehe_ACC_Wirkung=[[theDictionary objectForKey:kKeyHoehe_ACC_Wirkung ] unsignedCharValue];
  setting.Hoehe_HoverBand=[[theDictionary objectForKey:kKeyHoehe_HoverBand ] unsignedCharValue];
  setting.Hoehe_GPS_Z=[[theDictionary objectForKey:kKeyHoehe_GPS_Z ] unsignedCharValue];
  setting.Hoehe_StickNeutralPoint=[[theDictionary objectForKey:kKeyHoehe_StickNeutralPoint ] unsignedCharValue];
  setting.Stick_P=[[theDictionary objectForKey:kKeyStick_P ] unsignedCharValue];
  setting.Stick_D=[[theDictionary objectForKey:kKeyStick_D ] unsignedCharValue];
  setting.Gier_P=[[theDictionary objectForKey:kKeyGier_P ] unsignedCharValue];
  setting.Gas_Min=[[theDictionary objectForKey:kKeyGas_Min ] unsignedCharValue];
  setting.Gas_Max=[[theDictionary objectForKey:kKeyGas_Max ] unsignedCharValue];
  setting.GyroAccFaktor=[[theDictionary objectForKey:kKeyGyroAccFaktor ] unsignedCharValue];
  setting.KompassWirkung=[[theDictionary objectForKey:kKeyKompassWirkung ] unsignedCharValue];
  setting.Gyro_P=[[theDictionary objectForKey:kKeyGyro_P ] unsignedCharValue];
  setting.Gyro_I=[[theDictionary objectForKey:kKeyGyro_I ] unsignedCharValue];
  setting.Gyro_D=[[theDictionary objectForKey:kKeyGyro_D ] unsignedCharValue];
  setting.Gyro_Gier_P=[[theDictionary objectForKey:kKeyGyro_Gier_P ] unsignedCharValue];
  setting.Gyro_Gier_I=[[theDictionary objectForKey:kKeyGyro_Gier_I ] unsignedCharValue];
  setting.UnterspannungsWarnung=[[theDictionary objectForKey:kKeyUnterspannungsWarnung ] unsignedCharValue];
  setting.NotGas=[[theDictionary objectForKey:kKeyNotGas ] unsignedCharValue];
  setting.NotGasZeit=[[theDictionary objectForKey:kKeyNotGasZeit ] unsignedCharValue];
  setting.Receiver=[[theDictionary objectForKey:kKeyReceiver ] unsignedCharValue];
  setting.I_Faktor=[[theDictionary objectForKey:kKeyI_Faktor ] unsignedCharValue];
  setting.UserParam1=[[theDictionary objectForKey:kKeyUserParam1 ] unsignedCharValue];
  setting.UserParam2=[[theDictionary objectForKey:kKeyUserParam2 ] unsignedCharValue];
  setting.UserParam3=[[theDictionary objectForKey:kKeyUserParam3 ] unsignedCharValue];
  setting.UserParam4=[[theDictionary objectForKey:kKeyUserParam4 ] unsignedCharValue];
  setting.ServoNickControl=[[theDictionary objectForKey:kKeyServoNickControl ] unsignedCharValue];
  setting.ServoNickComp=[[theDictionary objectForKey:kKeyServoNickComp ] unsignedCharValue];
  setting.ServoNickMin=[[theDictionary objectForKey:kKeyServoNickMin ] unsignedCharValue];
  setting.ServoNickMax=[[theDictionary objectForKey:kKeyServoNickMax ] unsignedCharValue];
  setting.ServoRollControl=[[theDictionary objectForKey:kKeyServoRollControl ] unsignedCharValue];
  setting.ServoRollComp=[[theDictionary objectForKey:kKeyServoRollComp ] unsignedCharValue];
  setting.ServoRollMin=[[theDictionary objectForKey:kKeyServoRollMin ] unsignedCharValue];
  setting.ServoRollMax=[[theDictionary objectForKey:kKeyServoRollMax ] unsignedCharValue];
  setting.ServoNickRefresh=[[theDictionary objectForKey:kKeyServoNickRefresh ] unsignedCharValue];
  setting.Servo3=[[theDictionary objectForKey:kKeyServo3 ] unsignedCharValue];
  setting.Servo4=[[theDictionary objectForKey:kKeyServo4 ] unsignedCharValue];
  setting.Servo5=[[theDictionary objectForKey:kKeyServo5 ] unsignedCharValue];
  setting.LoopGasLimit=[[theDictionary objectForKey:kKeyLoopGasLimit ] unsignedCharValue];
  setting.LoopThreshold=[[theDictionary objectForKey:kKeyLoopThreshold ] unsignedCharValue];
  setting.LoopHysterese=[[theDictionary objectForKey:kKeyLoopHysterese ] unsignedCharValue];
  setting.AchsKopplung1=[[theDictionary objectForKey:kKeyAchsKopplung1 ] unsignedCharValue];
  setting.AchsKopplung2=[[theDictionary objectForKey:kKeyAchsKopplung2 ] unsignedCharValue];
  setting.CouplingYawCorrection=[[theDictionary objectForKey:kKeyCouplingYawCorrection ] unsignedCharValue];
  setting.WinkelUmschlagNick=[[theDictionary objectForKey:kKeyWinkelUmschlagNick ] unsignedCharValue];
  setting.WinkelUmschlagRoll=[[theDictionary objectForKey:kKeyWinkelUmschlagRoll ] unsignedCharValue];
  setting.GyroAccAbgleich=[[theDictionary objectForKey:kKeyGyroAccAbgleich ] unsignedCharValue];
  setting.Driftkomp=[[theDictionary objectForKey:kKeyDriftkomp ] unsignedCharValue];
  setting.DynamicStability=[[theDictionary objectForKey:kKeyDynamicStability ] unsignedCharValue];
  setting.UserParam5=[[theDictionary objectForKey:kKeyUserParam5 ] unsignedCharValue];
  setting.UserParam6=[[theDictionary objectForKey:kKeyUserParam6 ] unsignedCharValue];
  setting.UserParam7=[[theDictionary objectForKey:kKeyUserParam7 ] unsignedCharValue];
  setting.UserParam8=[[theDictionary objectForKey:kKeyUserParam8 ] unsignedCharValue];
  setting.J16Bitmask=[[theDictionary objectForKey:kKeyJ16Bitmask ] unsignedCharValue];
  setting.J16Timing=[[theDictionary objectForKey:kKeyJ16Timing ] unsignedCharValue];
  setting.J17Bitmask=[[theDictionary objectForKey:kKeyJ17Bitmask ] unsignedCharValue];
  setting.J17Timing=[[theDictionary objectForKey:kKeyJ17Timing ] unsignedCharValue];
  setting.WARN_J16_Bitmask=[[theDictionary objectForKey:kKeyWARN_J16_Bitmask ] unsignedCharValue];
  setting.WARN_J17_Bitmask=[[theDictionary objectForKey:kKeyWARN_J17_Bitmask ] unsignedCharValue];
  setting.NaviGpsModeControl=[[theDictionary objectForKey:kKeyNaviGpsModeControl ] unsignedCharValue];
  setting.NaviGpsGain=[[theDictionary objectForKey:kKeyNaviGpsGain ] unsignedCharValue];
  setting.NaviGpsP=[[theDictionary objectForKey:kKeyNaviGpsP ] unsignedCharValue];
  setting.NaviGpsI=[[theDictionary objectForKey:kKeyNaviGpsI ] unsignedCharValue];
  setting.NaviGpsD=[[theDictionary objectForKey:kKeyNaviGpsD ] unsignedCharValue];
  setting.NaviGpsPLimit=[[theDictionary objectForKey:kKeyNaviGpsPLimit ] unsignedCharValue];
  setting.NaviGpsILimit=[[theDictionary objectForKey:kKeyNaviGpsILimit ] unsignedCharValue];
  setting.NaviGpsDLimit=[[theDictionary objectForKey:kKeyNaviGpsDLimit ] unsignedCharValue];
  setting.NaviGpsACC=[[theDictionary objectForKey:kKeyNaviGpsACC ] unsignedCharValue];
  setting.NaviGpsMinSat=[[theDictionary objectForKey:kKeyNaviGpsMinSat ] unsignedCharValue];
  setting.NaviStickThreshold=[[theDictionary objectForKey:kKeyNaviStickThreshold ] unsignedCharValue];
  setting.NaviWindCorrection=[[theDictionary objectForKey:kKeyNaviWindCorrection ] unsignedCharValue];
  setting.NaviSpeedCompensation=[[theDictionary objectForKey:kKeyNaviSpeedCompensation ] unsignedCharValue];
  setting.NaviOperatingRadius=[[theDictionary objectForKey:kKeyNaviOperatingRadius ] unsignedCharValue];
  setting.NaviAngleLimitation=[[theDictionary objectForKey:kKeyNaviAngleLimitation ] unsignedCharValue];
  setting.NaviPH_LoginTime=[[theDictionary objectForKey:kKeyNaviPH_LoginTime ] unsignedCharValue];
  setting.ExternalControl=[[theDictionary objectForKey:kKeyExternalControl ] unsignedCharValue];
  
  setting.BitConfig=0;
  setting.BitConfig|= [[theDictionary objectForKey:kKeyBitConfig_LOOP_UP       ] boolValue]?CFG_LOOP_OBEN     :0;
  setting.BitConfig|= [[theDictionary objectForKey:kKeyBitConfig_LOOP_DOWN     ] boolValue]?CFG_LOOP_UNTEN    :0;
  setting.BitConfig|= [[theDictionary objectForKey:kKeyBitConfig_LOOP_LEFT     ] boolValue]?CFG_LOOP_LINKS    :0;
  setting.BitConfig|= [[theDictionary objectForKey:kKeyBitConfig_LOOP_RIGHT    ] boolValue]?CFG_LOOP_RECHTS   :0;
  setting.BitConfig|= [[theDictionary objectForKey:kKeyBitConfig_MOTOR_BLINK   ] boolValue]?CFG_MOTOR_BLINK	   :0;
  setting.BitConfig|= [[theDictionary objectForKey:kKeyBitConfig_MOTOR_OFF_LED1] boolValue]?CFG_MOTOR_OFF_LED1:0;
  setting.BitConfig|= [[theDictionary objectForKey:kKeyBitConfig_MOTOR_OFF_LED2] boolValue]?CFG_MOTOR_OFF_LED2:0;
  
  setting.ServoCompInvert=0;
  setting.ServoCompInvert|= [[theDictionary objectForKey:kKeyServoCompInvert_Nick] boolValue]?CFG2_INVERT_NICK:0;
  setting.ServoCompInvert|= [[theDictionary objectForKey:kKeyServoCompInvert_ROLL] boolValue]?CFG2_INVERT_ROLL:0;
  
  setting.ExtraConfig=0;
  setting.ExtraConfig|= [[theDictionary objectForKey:kKeyExtraConfig_HEIGHT_LIMIT] boolValue]?CFG2_HEIGHT_LIMIT:0;
  setting.ExtraConfig|= [[theDictionary objectForKey:kKeyExtraConfig_VARIO_BEEP  ] boolValue]?CFG2_VARIO_BEEP  :0;
  setting.ExtraConfig|= [[theDictionary objectForKey:kKeyExtraConfig_SENSITIVE_RC] boolValue]?CFG_SENSITIVE_RC :0;
  
  NSString* name=[theDictionary objectForKey:kKeyName];
  
  memset(setting.Name, 0, 12);
  
  [name getBytes:(void*)setting.Name 
       maxLength:12 
      usedLength:NULL 
        encoding:NSASCIIStringEncoding 
         options:0 
           range:NSMakeRange(0,[name length]) 
  remainingRange:NULL];
  
  
  unsigned char payloadData[sizeof(MKSetting)+2];
  
  payloadData[0]=[[theDictionary objectForKey:kMKDataKeyIndex] unsignedCharValue];
  payloadData[1]=[[theDictionary objectForKey:kMKDataKeyVersion] unsignedCharValue];
  
  memcpy((unsigned char *)(payloadData + 2),(unsigned char *)&setting,sizeof(MKSetting));
  
  return [NSData dataWithBytes:payloadData length:sizeof(payloadData)];  
}

@end
