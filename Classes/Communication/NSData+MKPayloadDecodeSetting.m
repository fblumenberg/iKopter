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

#import "NSData+MKPayloadDecode.h"
#import "MKDataConstants.h"

@implementation NSData (MKPayloadDecodeSetting)

- (NSDictionary *) decodeReadSettingResponse {
  
  const char * bytes = [self bytes];
  NSNumber * index = [NSNumber numberWithChar:bytes[0]];
  NSNumber * version = [NSNumber numberWithChar:bytes[1]];
  
  MKSetting settings;
  memcpy((unsigned char *)&settings, (unsigned char *)(bytes + 2), sizeof(settings));
  
  NSMutableDictionary* d = [[[NSMutableDictionary alloc] initWithCapacity:112] autorelease];
  
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  [d setObject:index forKey:kMKDataKeyIndex];
  [d setObject:version forKey:kMKDataKeyVersion];
  
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[0]] forKey:kKeyKanalbelegung00];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[1]] forKey:kKeyKanalbelegung01];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[2]] forKey:kKeyKanalbelegung02];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[3]] forKey:kKeyKanalbelegung03];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[4]] forKey:kKeyKanalbelegung04];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[5]] forKey:kKeyKanalbelegung05];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[6]] forKey:kKeyKanalbelegung06];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[7]] forKey:kKeyKanalbelegung07];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[8]] forKey:kKeyKanalbelegung08];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[9]] forKey:kKeyKanalbelegung09];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[10]] forKey:kKeyKanalbelegung10];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Kanalbelegung[11]] forKey:kKeyKanalbelegung11];
  
  [d setObject:[NSNumber numberWithUnsignedChar:settings.GlobalConfig] forKey:kKeyGlobalConfig];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_HOEHENREGELUNG       ) != 0] forKey:kKeyGlobalConfig_HOEHENREGELUNG       ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_HOEHEN_SCHALTER      ) != 0] forKey:kKeyGlobalConfig_HOEHEN_SCHALTER      ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_HEADING_HOLD         ) != 0] forKey:kKeyGlobalConfig_HEADING_HOLD         ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_KOMPASS_AKTIV        ) != 0] forKey:kKeyGlobalConfig_KOMPASS_AKTIV        ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_KOMPASS_FIX          ) != 0] forKey:kKeyGlobalConfig_KOMPASS_FIX          ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_GPS_AKTIV            ) != 0] forKey:kKeyGlobalConfig_GPS_AKTIV            ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_ACHSENKOPPLUNG_AKTIV ) != 0] forKey:kKeyGlobalConfig_ACHSENKOPPLUNG_AKTIV ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.GlobalConfig & CFG_DREHRATEN_BEGRENZER  ) != 0] forKey:kKeyGlobalConfig_DREHRATEN_BEGRENZER  ];
  
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Hoehe_MinGas] forKey:kKeyHoehe_MinGas ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Luftdruck_D] forKey:kKeyLuftdruck_D ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.MaxHoehe] forKey:kKeyMaxHoehe ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Hoehe_P] forKey:kKeyHoehe_P ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Hoehe_Verstaerkung] forKey:kKeyHoehe_Verstaerkung ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Hoehe_ACC_Wirkung] forKey:kKeyHoehe_ACC_Wirkung ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Hoehe_HoverBand] forKey:kKeyHoehe_HoverBand ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Hoehe_GPS_Z] forKey:kKeyHoehe_GPS_Z ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Hoehe_StickNeutralPoint] forKey:kKeyHoehe_StickNeutralPoint ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Stick_P] forKey:kKeyStick_P ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Stick_D] forKey:kKeyStick_D ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gier_P] forKey:kKeyGier_P ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gas_Min] forKey:kKeyGas_Min ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gas_Max] forKey:kKeyGas_Max ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.GyroAccFaktor] forKey:kKeyGyroAccFaktor ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.KompassWirkung] forKey:kKeyKompassWirkung ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gyro_P] forKey:kKeyGyro_P ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gyro_I] forKey:kKeyGyro_I ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gyro_D] forKey:kKeyGyro_D ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gyro_Gier_P] forKey:kKeyGyro_Gier_P ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Gyro_Gier_I] forKey:kKeyGyro_Gier_I ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UnterspannungsWarnung] forKey:kKeyUnterspannungsWarnung ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NotGas] forKey:kKeyNotGas ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NotGasZeit] forKey:kKeyNotGasZeit ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Receiver] forKey:kKeyReceiver ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.I_Faktor] forKey:kKeyI_Faktor ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam1] forKey:kKeyUserParam1 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam2] forKey:kKeyUserParam2 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam3] forKey:kKeyUserParam3 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam4] forKey:kKeyUserParam4 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoNickControl] forKey:kKeyServoNickControl ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoNickComp] forKey:kKeyServoNickComp ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoNickMin] forKey:kKeyServoNickMin ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoNickMax] forKey:kKeyServoNickMax ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoRollControl] forKey:kKeyServoRollControl ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoRollComp] forKey:kKeyServoRollComp ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoRollMin] forKey:kKeyServoRollMin ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoRollMax] forKey:kKeyServoRollMax ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ServoNickRefresh] forKey:kKeyServoNickRefresh ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Servo3] forKey:kKeyServo3 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Servo4] forKey:kKeyServo4 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Servo5] forKey:kKeyServo5 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.LoopGasLimit] forKey:kKeyLoopGasLimit ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.LoopThreshold] forKey:kKeyLoopThreshold ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.LoopHysterese] forKey:kKeyLoopHysterese ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.AchsKopplung1] forKey:kKeyAchsKopplung1 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.AchsKopplung2] forKey:kKeyAchsKopplung2 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.CouplingYawCorrection] forKey:kKeyCouplingYawCorrection ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.WinkelUmschlagNick] forKey:kKeyWinkelUmschlagNick ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.WinkelUmschlagRoll] forKey:kKeyWinkelUmschlagRoll ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.GyroAccAbgleich] forKey:kKeyGyroAccAbgleich ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.Driftkomp] forKey:kKeyDriftkomp ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.DynamicStability] forKey:kKeyDynamicStability ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam5] forKey:kKeyUserParam5 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam6] forKey:kKeyUserParam6 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam7] forKey:kKeyUserParam7 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.UserParam8] forKey:kKeyUserParam8 ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.J16Bitmask] forKey:kKeyJ16Bitmask ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.J16Timing] forKey:kKeyJ16Timing ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.J17Bitmask] forKey:kKeyJ17Bitmask ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.J17Timing] forKey:kKeyJ17Timing ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.WARN_J16_Bitmask] forKey:kKeyWARN_J16_Bitmask ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.WARN_J17_Bitmask] forKey:kKeyWARN_J17_Bitmask ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsModeControl] forKey:kKeyNaviGpsModeControl ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsGain] forKey:kKeyNaviGpsGain ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsP] forKey:kKeyNaviGpsP ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsI] forKey:kKeyNaviGpsI ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsD] forKey:kKeyNaviGpsD ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsPLimit] forKey:kKeyNaviGpsPLimit ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsILimit] forKey:kKeyNaviGpsILimit ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsDLimit] forKey:kKeyNaviGpsDLimit ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsACC] forKey:kKeyNaviGpsACC ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviGpsMinSat] forKey:kKeyNaviGpsMinSat ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviStickThreshold] forKey:kKeyNaviStickThreshold ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviWindCorrection] forKey:kKeyNaviWindCorrection ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviSpeedCompensation] forKey:kKeyNaviSpeedCompensation ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviOperatingRadius] forKey:kKeyNaviOperatingRadius ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviAngleLimitation] forKey:kKeyNaviAngleLimitation ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.NaviPH_LoginTime] forKey:kKeyNaviPH_LoginTime ];
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ExternalControl] forKey:kKeyExternalControl ];
  
  [d setObject:[NSNumber numberWithUnsignedChar:settings.BitConfig] forKey:kKeyBitConfig];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG_LOOP_OBEN     ) != 0] forKey:kKeyBitConfig_LOOP_UP       ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG_LOOP_UNTEN    ) != 0] forKey:kKeyBitConfig_LOOP_DOWN     ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG_LOOP_LINKS    ) != 0] forKey:kKeyBitConfig_LOOP_LEFT     ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG_LOOP_RECHTS   ) != 0] forKey:kKeyBitConfig_LOOP_RIGHT    ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG_MOTOR_BLINK       ) != 0] forKey:kKeyBitConfig_MOTOR_BLINK   ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG_MOTOR_OFF_LED1) != 0] forKey:kKeyBitConfig_MOTOR_OFF_LED1];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG_MOTOR_OFF_LED2) != 0] forKey:kKeyBitConfig_MOTOR_OFF_LED2];
  
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG2_INVERT_NICK) != 0] forKey:kKeyServoCompInvert_Nick];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.BitConfig & CFG2_INVERT_ROLL) != 0] forKey:kKeyServoCompInvert_ROLL];
  
  [d setObject:[NSNumber numberWithUnsignedChar:settings.ExtraConfig & CFG2_HEIGHT_LIMIT] forKey:kKeyExtraConfig];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.ExtraConfig & CFG2_HEIGHT_LIMIT) != 0] forKey:kKeyExtraConfig_HEIGHT_LIMIT];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.ExtraConfig & CFG2_VARIO_BEEP  ) != 0] forKey:kKeyExtraConfig_VARIO_BEEP  ];
  [d setObject:[NSNumber numberWithUnsignedChar:(settings.ExtraConfig & CFG_SENSITIVE_RC ) != 0] forKey:kKeyExtraConfig_SENSITIVE_RC];
  
  NSString* name=[NSString stringWithCString:settings.Name encoding:NSASCIIStringEncoding];
  [d setObject:name forKey:kKeyName];
  
  [pool drain];
  
  return d;
}

- (NSDictionary *) decodeWriteSettingResponse {
  const char * bytes = [self bytes];
  NSNumber * theIndex = [NSNumber numberWithChar:bytes[0]];
  return [NSDictionary dictionaryWithObjectsAndKeys:theIndex, kMKDataKeyIndex, nil];
}

- (NSDictionary *) decodeChangeSettingResponse {
  const char * bytes = [self bytes];
  NSNumber * theIndex = [NSNumber numberWithChar:bytes[0]];
  return [NSDictionary dictionaryWithObjectsAndKeys:theIndex, kMKDataKeyIndex, nil];
}

@end
