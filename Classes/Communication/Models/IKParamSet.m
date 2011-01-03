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


#import "IKParamSet.h"

@implementation IKParamSet

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)settingWithData:(NSData *)data{
  return [[[IKParamSet alloc] initWithData:data] autorelease];
}

- (id)initWithData:(NSData*)data{
  self = [super init];
  if (self != nil) {
    memcpy(&_parameter,[data bytes],sizeof(_parameter));
  }
  return self;
}

- (NSData*) data{
  unsigned char payloadData[sizeof(_parameter)];
  
  memcpy((unsigned char *)(payloadData),(unsigned char *)&_parameter,sizeof(_parameter));
  
  return [NSData dataWithBytes:payloadData length:sizeof(payloadData)];  
}


//---------------------------------------------------
#pragma mark -
#pragma mark Properties
//---------------------------------------------------

- (NSNumber*) Index{
  
  return [NSNumber numberWithUnsignedChar:_parameter.Index];
}
- (void) setIndex:(NSNumber*) value {
  
  _parameter.Index = [value unsignedCharValue];
}

- (NSNumber*) Revision{
  return [NSNumber numberWithUnsignedChar:_parameter.Revision];
}
- (void) setRevision:(NSNumber*) value {
  _parameter.Revision = [value unsignedCharValue];
}
//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSNumber*) Kanalbelegung_00{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[0]];
}
- (void) setKanalbelegung_00:(NSNumber*) value {
  _parameter.Kanalbelegung[0] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_01{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[1]];
}
- (void) setKanalbelegung_01:(NSNumber*) value {
  _parameter.Kanalbelegung[1] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_02{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[2]];
}
- (void) setKanalbelegung_02:(NSNumber*) value {
  _parameter.Kanalbelegung[2] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_03{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[3]];
}
- (void) setKanalbelegung_03:(NSNumber*) value {
  _parameter.Kanalbelegung[3] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_04{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[4]];
}
- (void) setKanalbelegung_04:(NSNumber*) value {
  _parameter.Kanalbelegung[4] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_05{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[5]];
}
- (void) setKanalbelegung_05:(NSNumber*) value {
  _parameter.Kanalbelegung[5] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_06{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[6]];
}
- (void) setKanalbelegung_06:(NSNumber*) value {
  _parameter.Kanalbelegung[6] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_07{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[7]];
}
- (void) setKanalbelegung_07:(NSNumber*) value {
  _parameter.Kanalbelegung[7] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_08{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[8]];
}
- (void) setKanalbelegung_08:(NSNumber*) value {
  _parameter.Kanalbelegung[8] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_09{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[9]];
}
- (void) setKanalbelegung_09:(NSNumber*) value {
  _parameter.Kanalbelegung[9] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_10{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[10]];
}
- (void) setKanalbelegung_10:(NSNumber*) value {
  _parameter.Kanalbelegung[10] = [value unsignedCharValue];
}
- (NSNumber*) Kanalbelegung_11{
  return [NSNumber numberWithUnsignedChar:_parameter.Kanalbelegung[11]];
}
- (void) setKanalbelegung_11:(NSNumber*) value {
  _parameter.Kanalbelegung[11] = [value unsignedCharValue];
}
//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSNumber*) GlobalConfig_HOEHENREGELUNG{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_HOEHENREGELUNG)==CFG_HOEHENREGELUNG)];
}
- (void) setGlobalConfig_HOEHENREGELUNG:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_HOEHENREGELUNG;
  else
     _parameter.BitConfig &= ~CFG_HOEHENREGELUNG;
}
- (NSNumber*) GlobalConfig_HOEHEN_SCHALTER{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_HOEHEN_SCHALTER)==CFG_HOEHEN_SCHALTER)];
}
- (void) setGlobalConfig_HOEHEN_SCHALTER:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_HOEHEN_SCHALTER;
  else
     _parameter.BitConfig &= ~CFG_HOEHEN_SCHALTER;
}
- (NSNumber*) GlobalConfig_HEADING_HOLD{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_HEADING_HOLD)==CFG_HEADING_HOLD)];
}
- (void) setGlobalConfig_HEADING_HOLD:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_HEADING_HOLD;
  else
     _parameter.BitConfig &= ~CFG_HEADING_HOLD;
}
- (NSNumber*) GlobalConfig_KOMPASS_AKTIV{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_KOMPASS_AKTIV)==CFG_KOMPASS_AKTIV)];
}
- (void) setGlobalConfig_KOMPASS_AKTIV:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_KOMPASS_AKTIV;
  else
     _parameter.BitConfig &= ~CFG_KOMPASS_AKTIV;
}
- (NSNumber*) GlobalConfig_KOMPASS_FIX{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_KOMPASS_FIX)==CFG_KOMPASS_FIX)];
}
- (void) setGlobalConfig_KOMPASS_FIX:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_KOMPASS_FIX;
  else
     _parameter.BitConfig &= ~CFG_KOMPASS_FIX;
}
- (NSNumber*) GlobalConfig_GPS_AKTIV{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_GPS_AKTIV)==CFG_GPS_AKTIV)];
}
- (void) setGlobalConfig_GPS_AKTIV:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_GPS_AKTIV;
  else
     _parameter.BitConfig &= ~CFG_GPS_AKTIV;
}
- (NSNumber*) GlobalConfig_ACHSENKOPPLUNG_AKTIV{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_ACHSENKOPPLUNG_AKTIV)==CFG_ACHSENKOPPLUNG_AKTIV)];
}
- (void) setGlobalConfig_ACHSENKOPPLUNG_AKTIV:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_ACHSENKOPPLUNG_AKTIV;
  else
     _parameter.BitConfig &= ~CFG_ACHSENKOPPLUNG_AKTIV;
}
- (NSNumber*) GlobalConfig_DREHRATEN_BEGRENZER{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_DREHRATEN_BEGRENZER)==CFG_DREHRATEN_BEGRENZER)];
}
- (void) setGlobalConfig_DREHRATEN_BEGRENZER:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_DREHRATEN_BEGRENZER;
  else
     _parameter.BitConfig &= ~CFG_DREHRATEN_BEGRENZER;
}

//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSNumber*) Hoehe_MinGas{
  return [NSNumber numberWithUnsignedChar:_parameter.Hoehe_MinGas];
}
- (void) setHoehe_MinGas:(NSNumber*) value {
  _parameter.Hoehe_MinGas = [value unsignedCharValue];
}
- (NSNumber*) Luftdruck_D{
  return [NSNumber numberWithUnsignedChar:_parameter.Luftdruck_D];
}
- (void) setLuftdruck_D:(NSNumber*) value {
  _parameter.Luftdruck_D = [value unsignedCharValue];
}
- (NSNumber*) MaxHoehe{
  return [NSNumber numberWithUnsignedChar:_parameter.MaxHoehe];
}
- (void) setMaxHoehe:(NSNumber*) value {
  _parameter.MaxHoehe = [value unsignedCharValue];
}
- (NSNumber*) Hoehe_P{
  return [NSNumber numberWithUnsignedChar:_parameter.Hoehe_P];
}
- (void) setHoehe_P:(NSNumber*) value {
  _parameter.Hoehe_P = [value unsignedCharValue];
}
- (NSNumber*) Hoehe_Verstaerkung{
  return [NSNumber numberWithUnsignedChar:_parameter.Hoehe_Verstaerkung];
}
- (void) setHoehe_Verstaerkung:(NSNumber*) value {
  _parameter.Hoehe_Verstaerkung = [value unsignedCharValue];
}
- (NSNumber*) Hoehe_ACC_Wirkung{
  return [NSNumber numberWithUnsignedChar:_parameter.Hoehe_ACC_Wirkung];
}
- (void) setHoehe_ACC_Wirkung:(NSNumber*) value {
  _parameter.Hoehe_ACC_Wirkung = [value unsignedCharValue];
}
- (NSNumber*) Hoehe_HoverBand{
  return [NSNumber numberWithUnsignedChar:_parameter.Hoehe_HoverBand];
}
- (void) setHoehe_HoverBand:(NSNumber*) value {
  _parameter.Hoehe_HoverBand = [value unsignedCharValue];
}
- (NSNumber*) Hoehe_GPS_Z{
  return [NSNumber numberWithUnsignedChar:_parameter.Hoehe_GPS_Z];
}
- (void) setHoehe_GPS_Z:(NSNumber*) value {
  _parameter.Hoehe_GPS_Z = [value unsignedCharValue];
}
//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSNumber*) Hoehe_StickNeutralPoint{
  return [NSNumber numberWithUnsignedChar:_parameter.Hoehe_StickNeutralPoint];
}
- (void) setHoehe_StickNeutralPoint:(NSNumber*) value {
  _parameter.Hoehe_StickNeutralPoint = [value unsignedCharValue];
}
- (NSNumber*) Stick_P{
  return [NSNumber numberWithUnsignedChar:_parameter.Stick_P];
}
- (void) setStick_P:(NSNumber*) value {
  _parameter.Stick_P = [value unsignedCharValue];
}
- (NSNumber*) Stick_D{
  return [NSNumber numberWithUnsignedChar:_parameter.Stick_D];
}
- (void) setStick_D:(NSNumber*) value {
  _parameter.Stick_D = [value unsignedCharValue];
}
- (NSNumber*) Gier_P{
  return [NSNumber numberWithUnsignedChar:_parameter.Gier_P];
}
- (void) setGier_P:(NSNumber*) value {
  _parameter.Gier_P = [value unsignedCharValue];
}
- (NSNumber*) Gas_Min{
  return [NSNumber numberWithUnsignedChar:_parameter.Gas_Min];
}
- (void) setGas_Min:(NSNumber*) value {
  _parameter.Gas_Min = [value unsignedCharValue];
}
- (NSNumber*) Gas_Max{
  return [NSNumber numberWithUnsignedChar:_parameter.Gas_Max];
}
- (void) setGas_Max:(NSNumber*) value {
  _parameter.Gas_Max = [value unsignedCharValue];
}
- (NSNumber*) GyroAccFaktor{
  return [NSNumber numberWithUnsignedChar:_parameter.GyroAccFaktor];
}
- (void) setGyroAccFaktor:(NSNumber*) value {
  _parameter.GyroAccFaktor = [value unsignedCharValue];
}
- (NSNumber*) KompassWirkung{
  return [NSNumber numberWithUnsignedChar:_parameter.KompassWirkung];
}
- (void) setKompassWirkung:(NSNumber*) value {
  _parameter.KompassWirkung = [value unsignedCharValue];
}
- (NSNumber*) Gyro_P{
  return [NSNumber numberWithUnsignedChar:_parameter.Gyro_P];
}
- (void) setGyro_P:(NSNumber*) value {
  _parameter.Gyro_P = [value unsignedCharValue];
}
- (NSNumber*) Gyro_I{
  return [NSNumber numberWithUnsignedChar:_parameter.Gyro_I];
}
- (void) setGyro_I:(NSNumber*) value {
  _parameter.Gyro_I = [value unsignedCharValue];
}
- (NSNumber*) Gyro_D{
  return [NSNumber numberWithUnsignedChar:_parameter.Gyro_D];
}
- (void) setGyro_D:(NSNumber*) value {
  _parameter.Gyro_D = [value unsignedCharValue];
}
- (NSNumber*) Gyro_Gier_P{
  return [NSNumber numberWithUnsignedChar:_parameter.Gyro_Gier_P];
}
- (void) setGyro_Gier_P:(NSNumber*) value {
  _parameter.Gyro_Gier_P = [value unsignedCharValue];
}
- (NSNumber*) Gyro_Gier_I{
  return [NSNumber numberWithUnsignedChar:_parameter.Gyro_Gier_I];
}
- (void) setGyro_Gier_I:(NSNumber*) value {
  _parameter.Gyro_Gier_I = [value unsignedCharValue];
}
- (NSNumber*) Gyro_Stability{
  return [NSNumber numberWithUnsignedChar:_parameter.Gyro_Stability];
}
- (void) setGyro_Stability:(NSNumber*) value {
  _parameter.Gyro_Stability = [value unsignedCharValue];
}
- (NSNumber*) UnterspannungsWarnung{
  return [NSNumber numberWithUnsignedChar:_parameter.UnterspannungsWarnung];
}
- (void) setUnterspannungsWarnung:(NSNumber*) value {
  _parameter.UnterspannungsWarnung = [value unsignedCharValue];
}
- (NSNumber*) NotGas{
  return [NSNumber numberWithUnsignedChar:_parameter.NotGas];
}
- (void) setNotGas:(NSNumber*) value {
  _parameter.NotGas = [value unsignedCharValue];
}
- (NSNumber*) NotGasZeit{
  return [NSNumber numberWithUnsignedChar:_parameter.NotGasZeit];
}
- (void) setNotGasZeit:(NSNumber*) value {
  _parameter.NotGasZeit = [value unsignedCharValue];
}
- (NSNumber*) Receiver{
  return [NSNumber numberWithUnsignedChar:_parameter.Receiver];
}
- (void) setReceiver:(NSNumber*) value {
  _parameter.Receiver = [value unsignedCharValue];
}
- (NSNumber*) I_Faktor{
  return [NSNumber numberWithUnsignedChar:_parameter.I_Faktor];
}
- (void) setI_Faktor:(NSNumber*) value {
  _parameter.I_Faktor = [value unsignedCharValue];
}
- (NSNumber*) UserParam1{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam1];
}
- (void) setUserParam1:(NSNumber*) value {
  _parameter.UserParam1 = [value unsignedCharValue];
}
- (NSNumber*) UserParam2{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam2];
}
- (void) setUserParam2:(NSNumber*) value {
  _parameter.UserParam2 = [value unsignedCharValue];
}
- (NSNumber*) UserParam3{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam3];
}
- (void) setUserParam3:(NSNumber*) value {
  _parameter.UserParam3 = [value unsignedCharValue];
}
- (NSNumber*) UserParam4{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam4];
}
- (void) setUserParam4:(NSNumber*) value {
  _parameter.UserParam4 = [value unsignedCharValue];
}
- (NSNumber*) ServoNickControl{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoNickControl];
}
- (void) setServoNickControl:(NSNumber*) value {
  _parameter.ServoNickControl = [value unsignedCharValue];
}
- (NSNumber*) ServoNickComp{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoNickComp];
}
- (void) setServoNickComp:(NSNumber*) value {
  _parameter.ServoNickComp = [value unsignedCharValue];
}
- (NSNumber*) ServoNickMin{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoNickMin];
}
- (void) setServoNickMin:(NSNumber*) value {
  _parameter.ServoNickMin = [value unsignedCharValue];
}
- (NSNumber*) ServoNickMax{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoNickMax];
}
- (void) setServoNickMax:(NSNumber*) value {
  _parameter.ServoNickMax = [value unsignedCharValue];
}
- (NSNumber*) ServoRollControl{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoRollControl];
}
- (void) setServoRollControl:(NSNumber*) value {
  _parameter.ServoRollControl = [value unsignedCharValue];
}
- (NSNumber*) ServoRollComp{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoRollComp];
}
- (void) setServoRollComp:(NSNumber*) value {
  _parameter.ServoRollComp = [value unsignedCharValue];
}
- (NSNumber*) ServoRollMin{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoRollMin];
}
- (void) setServoRollMin:(NSNumber*) value {
  _parameter.ServoRollMin = [value unsignedCharValue];
}
- (NSNumber*) ServoRollMax{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoRollMax];
}
- (void) setServoRollMax:(NSNumber*) value {
  _parameter.ServoRollMax = [value unsignedCharValue];
}
- (NSNumber*) ServoNickRefresh{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoNickRefresh];
}
- (void) setServoNickRefresh:(NSNumber*) value {
  _parameter.ServoNickRefresh = [value unsignedCharValue];
}
- (NSNumber*) ServoManualControlSpeed{
  return [NSNumber numberWithUnsignedChar:_parameter.ServoManualControlSpeed];
}
- (void) setServoManualControlSpeed:(NSNumber*) value {
  _parameter.ServoManualControlSpeed = [value unsignedCharValue];
}
- (NSNumber*) CamOrientation{
  return [NSNumber numberWithUnsignedChar:_parameter.CamOrientation];
}
- (void) setCamOrientation:(NSNumber*) value {
  _parameter.CamOrientation = [value unsignedCharValue];
}
- (NSNumber*) Servo3{
  return [NSNumber numberWithUnsignedChar:_parameter.Servo3];
}
- (void) setServo3:(NSNumber*) value {
  _parameter.Servo3 = [value unsignedCharValue];
}
- (NSNumber*) Servo4{
  return [NSNumber numberWithUnsignedChar:_parameter.Servo4];
}
- (void) setServo4:(NSNumber*) value {
  _parameter.Servo4 = [value unsignedCharValue];
}
- (NSNumber*) Servo5{
  return [NSNumber numberWithUnsignedChar:_parameter.Servo5];
}
- (void) setServo5:(NSNumber*) value {
  _parameter.Servo5 = [value unsignedCharValue];
}
- (NSNumber*) LoopGasLimit{
  return [NSNumber numberWithUnsignedChar:_parameter.LoopGasLimit];
}
- (void) setLoopGasLimit:(NSNumber*) value {
  _parameter.LoopGasLimit = [value unsignedCharValue];
}
- (NSNumber*) LoopThreshold{
  return [NSNumber numberWithUnsignedChar:_parameter.LoopThreshold];
}
- (void) setLoopThreshold:(NSNumber*) value {
  _parameter.LoopThreshold = [value unsignedCharValue];
}
- (NSNumber*) LoopHysterese{
  return [NSNumber numberWithUnsignedChar:_parameter.LoopHysterese];
}
- (void) setLoopHysterese:(NSNumber*) value {
  _parameter.LoopHysterese = [value unsignedCharValue];
}
- (NSNumber*) AchsKopplung1{
  return [NSNumber numberWithUnsignedChar:_parameter.AchsKopplung1];
}
- (void) setAchsKopplung1:(NSNumber*) value {
  _parameter.AchsKopplung1 = [value unsignedCharValue];
}
- (NSNumber*) AchsKopplung2{
  return [NSNumber numberWithUnsignedChar:_parameter.AchsKopplung2];
}
- (void) setAchsKopplung2:(NSNumber*) value {
  _parameter.AchsKopplung2 = [value unsignedCharValue];
}
- (NSNumber*) CouplingYawCorrection{
  return [NSNumber numberWithUnsignedChar:_parameter.CouplingYawCorrection];
}
- (void) setCouplingYawCorrection:(NSNumber*) value {
  _parameter.CouplingYawCorrection = [value unsignedCharValue];
}
- (NSNumber*) WinkelUmschlagNick{
  return [NSNumber numberWithUnsignedChar:_parameter.WinkelUmschlagNick];
}
- (void) setWinkelUmschlagNick:(NSNumber*) value {
  _parameter.WinkelUmschlagNick = [value unsignedCharValue];
}
- (NSNumber*) WinkelUmschlagRoll{
  return [NSNumber numberWithUnsignedChar:_parameter.WinkelUmschlagRoll];
}
- (void) setWinkelUmschlagRoll:(NSNumber*) value {
  _parameter.WinkelUmschlagRoll = [value unsignedCharValue];
}
- (NSNumber*) GyroAccAbgleich{
  return [NSNumber numberWithUnsignedChar:_parameter.GyroAccAbgleich];
}
- (void) setGyroAccAbgleich:(NSNumber*) value {
  _parameter.GyroAccAbgleich = [value unsignedCharValue];
}
- (NSNumber*) Driftkomp{
  return [NSNumber numberWithUnsignedChar:_parameter.Driftkomp];
}
- (void) setDriftkomp:(NSNumber*) value {
  _parameter.Driftkomp = [value unsignedCharValue];
}
- (NSNumber*) DynamicStability{
  return [NSNumber numberWithUnsignedChar:_parameter.DynamicStability];
}
- (void) setDynamicStability:(NSNumber*) value {
  _parameter.DynamicStability = [value unsignedCharValue];
}
- (NSNumber*) UserParam5{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam5];
}
- (void) setUserParam5:(NSNumber*) value {
  _parameter.UserParam5 = [value unsignedCharValue];
}
- (NSNumber*) UserParam6{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam6];
}
- (void) setUserParam6:(NSNumber*) value {
  _parameter.UserParam6 = [value unsignedCharValue];
}
- (NSNumber*) UserParam7{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam7];
}
- (void) setUserParam7:(NSNumber*) value {
  _parameter.UserParam7 = [value unsignedCharValue];
}
- (NSNumber*) UserParam8{
  return [NSNumber numberWithUnsignedChar:_parameter.UserParam8];
}
- (void) setUserParam8:(NSNumber*) value {
  _parameter.UserParam8 = [value unsignedCharValue];
}
- (NSNumber*) J16Bitmask{
  return [NSNumber numberWithUnsignedChar:_parameter.J16Bitmask];
}
- (void) setJ16Bitmask:(NSNumber*) value {
  _parameter.J16Bitmask = [value unsignedCharValue];
}
- (NSNumber*) J16Timing{
  return [NSNumber numberWithUnsignedChar:_parameter.J16Timing];
}
- (void) setJ16Timing:(NSNumber*) value {
  _parameter.J16Timing = [value unsignedCharValue];
}
- (NSNumber*) J17Bitmask{
  return [NSNumber numberWithUnsignedChar:_parameter.J17Bitmask];
}
- (void) setJ17Bitmask:(NSNumber*) value {
  _parameter.J17Bitmask = [value unsignedCharValue];
}
- (NSNumber*) J17Timing{
  return [NSNumber numberWithUnsignedChar:_parameter.J17Timing];
}
- (void) setJ17Timing:(NSNumber*) value {
  _parameter.J17Timing = [value unsignedCharValue];
}
- (NSNumber*) WARN_J16_Bitmask{
  return [NSNumber numberWithUnsignedChar:_parameter.WARN_J16_Bitmask];
}
- (void) setWARN_J16_Bitmask:(NSNumber*) value {
  _parameter.WARN_J16_Bitmask = [value unsignedCharValue];
}
- (NSNumber*) WARN_J17_Bitmask{
  return [NSNumber numberWithUnsignedChar:_parameter.WARN_J17_Bitmask];
}
- (void) setWARN_J17_Bitmask:(NSNumber*) value {
  _parameter.WARN_J17_Bitmask = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsModeControl{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsModeControl];
}
- (void) setNaviGpsModeControl:(NSNumber*) value {
  _parameter.NaviGpsModeControl = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsGain{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsGain];
}
- (void) setNaviGpsGain:(NSNumber*) value {
  _parameter.NaviGpsGain = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsP{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsP];
}
- (void) setNaviGpsP:(NSNumber*) value {
  _parameter.NaviGpsP = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsI{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsI];
}
- (void) setNaviGpsI:(NSNumber*) value {
  _parameter.NaviGpsI = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsD{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsD];
}
- (void) setNaviGpsD:(NSNumber*) value {
  _parameter.NaviGpsD = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsPLimit{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsPLimit];
}
- (void) setNaviGpsPLimit:(NSNumber*) value {
  _parameter.NaviGpsPLimit = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsILimit{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsILimit];
}
- (void) setNaviGpsILimit:(NSNumber*) value {
  _parameter.NaviGpsILimit = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsDLimit{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsDLimit];
}
- (void) setNaviGpsDLimit:(NSNumber*) value {
  _parameter.NaviGpsDLimit = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsACC{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsACC];
}
- (void) setNaviGpsACC:(NSNumber*) value {
  _parameter.NaviGpsACC = [value unsignedCharValue];
}
- (NSNumber*) NaviGpsMinSat{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviGpsMinSat];
}
- (void) setNaviGpsMinSat:(NSNumber*) value {
  _parameter.NaviGpsMinSat = [value unsignedCharValue];
}
- (NSNumber*) NaviStickThreshold{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviStickThreshold];
}
- (void) setNaviStickThreshold:(NSNumber*) value {
  _parameter.NaviStickThreshold = [value unsignedCharValue];
}
- (NSNumber*) NaviWindCorrection{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviWindCorrection];
}
- (void) setNaviWindCorrection:(NSNumber*) value {
  _parameter.NaviWindCorrection = [value unsignedCharValue];
}
- (NSNumber*) NaviSpeedCompensation{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviSpeedCompensation];
}
- (void) setNaviSpeedCompensation:(NSNumber*) value {
  _parameter.NaviSpeedCompensation = [value unsignedCharValue];
}
- (NSNumber*) NaviOperatingRadius{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviOperatingRadius];
}
- (void) setNaviOperatingRadius:(NSNumber*) value {
  _parameter.NaviOperatingRadius = [value unsignedCharValue];
}
- (NSNumber*) NaviAngleLimitation{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviAngleLimitation];
}
- (void) setNaviAngleLimitation:(NSNumber*) value {
  _parameter.NaviAngleLimitation = [value unsignedCharValue];
}
- (NSNumber*) NaviPH_LoginTime{
  return [NSNumber numberWithUnsignedChar:_parameter.NaviPH_LoginTime];
}
- (void) setNaviPH_LoginTime:(NSNumber*) value {
  _parameter.NaviPH_LoginTime = [value unsignedCharValue];
}
- (NSNumber*) ExternalControl{
  return [NSNumber numberWithUnsignedChar:_parameter.ExternalControl];
}
- (void) setExternalControl:(NSNumber*) value {
  _parameter.ExternalControl = [value unsignedCharValue];
}
- (NSNumber*) OrientationAngle{
  return [NSNumber numberWithUnsignedChar:_parameter.OrientationAngle];
}
- (void) setOrientationAngle:(NSNumber*) value {
  _parameter.OrientationAngle = [value unsignedCharValue];
}
- (NSNumber*) OrientationModeControl{
  return [NSNumber numberWithUnsignedChar:_parameter.OrientationModeControl];
}
- (void) setOrientationModeControl:(NSNumber*) value {
  _parameter.OrientationModeControl = [value unsignedCharValue];
}
- (NSNumber*) MotorSafetySwitch{
  return [NSNumber numberWithUnsignedChar:_parameter.MotorSafetySwitch];
}
- (void) setMotorSafetySwitch:(NSNumber*) value {
  _parameter.MotorSafetySwitch = [value unsignedCharValue];
}
//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSNumber*) BitConfig_LOOP_OBEN{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_LOOP_OBEN)==CFG_LOOP_OBEN)];
}
- (void) setBitConfig_LOOP_OBEN:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_LOOP_OBEN;
  else
     _parameter.BitConfig &= ~CFG_LOOP_OBEN;
}
- (NSNumber*) BitConfig_LOOP_UNTEN{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_LOOP_UNTEN)==CFG_LOOP_UNTEN)];
  
}
- (void) setBitConfig_LOOP_UNTEN:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_LOOP_UNTEN;
  else
     _parameter.BitConfig &= ~CFG_LOOP_UNTEN;
}
- (NSNumber*) BitConfig_LOOP_LINKS{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_LOOP_LINKS)==CFG_LOOP_LINKS)];
}
- (void) setBitConfig_LOOP_LINKS:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_LOOP_LINKS;
  else
     _parameter.BitConfig &= ~CFG_LOOP_LINKS;
}
- (NSNumber*) BitConfig_LOOP_RECHTS{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_LOOP_RECHTS)==CFG_LOOP_RECHTS)];
}
- (void) setBitConfig_LOOP_RECHTS:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_LOOP_RECHTS;
  else
     _parameter.BitConfig &= ~CFG_LOOP_RECHTS;
}
- (NSNumber*) BitConfig_MOTOR_BLINK{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_MOTOR_BLINK)==CFG_MOTOR_BLINK)];
}
- (void) setBitConfig_MOTOR_BLINK:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_MOTOR_BLINK;
  else
     _parameter.BitConfig &= ~CFG_MOTOR_BLINK;
}
- (NSNumber*) BitConfig_MOTOR_OFF_LED1{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_MOTOR_OFF_LED1)==CFG_MOTOR_OFF_LED1)];
}
- (void) setBitConfig_MOTOR_OFF_LED1:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_MOTOR_OFF_LED1;
  else
     _parameter.BitConfig &= ~CFG_MOTOR_OFF_LED1;
}
- (NSNumber*) BitConfig_MOTOR_OFF_LED2{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_MOTOR_OFF_LED2)==CFG_MOTOR_OFF_LED2)];
}
- (void) setBitConfig_MOTOR_OFF_LED2:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_MOTOR_OFF_LED2;
  else
     _parameter.BitConfig &= ~CFG_MOTOR_OFF_LED2;
}
//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSNumber*) ServoCompInvert_NICK{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_SERVOCOMPINVERT_NICK)==CFG_SERVOCOMPINVERT_NICK)];
}
- (void) setServoCompInvert_NICK:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_SERVOCOMPINVERT_NICK;
  else
     _parameter.BitConfig &= ~CFG_SERVOCOMPINVERT_NICK;
}
- (NSNumber*) ServoCompInvert_ROLL{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_SERVOCOMPINVERT_ROLL)==CFG_SERVOCOMPINVERT_ROLL)];
}
- (void) setServoCompInvert_ROLL:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_SERVOCOMPINVERT_ROLL;
  else
     _parameter.BitConfig &= ~CFG_SERVOCOMPINVERT_ROLL;
}

//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSNumber*) ExtraConfig_HEIGHT_LIMIT{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG2_HEIGHT_LIMIT)==CFG2_HEIGHT_LIMIT)];
}
- (void) setExtraConfig_HEIGHT_LIMIT:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG2_HEIGHT_LIMIT;
  else
     _parameter.BitConfig &= ~CFG2_HEIGHT_LIMIT;
}
- (NSNumber*) ExtraConfig_VARIO_BEEP{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG2_VARIO_BEEP)==CFG2_VARIO_BEEP)];
}
- (void) setExtraConfig_VARIO_BEEP:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG2_VARIO_BEEP;
  else
     _parameter.BitConfig &= ~CFG2_VARIO_BEEP;
}
- (NSNumber*) ExtraConfig_SENSITIVE_RC{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_SENSITIVE_RC)==CFG_SENSITIVE_RC)];
}
- (void) setExtraConfig_SENSITIVE_RC:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_SENSITIVE_RC;
  else
     _parameter.BitConfig &= ~CFG_SENSITIVE_RC;
}
- (NSNumber*) ExtraConfig_3_3V_REFERENCE{
  return [NSNumber numberWithBool:((_parameter.BitConfig&CFG_3_3V_REFERENCE)==CFG_3_3V_REFERENCE)];
}
- (void) setExtraConfig_3_3V_REFERENCE:(NSNumber*) value {
  if([value boolValue])
     _parameter.BitConfig |= CFG_3_3V_REFERENCE;
  else
     _parameter.BitConfig &= ~CFG_3_3V_REFERENCE;
}

//---------------------------------------------------
#pragma mark -
//---------------------------------------------------
- (NSString*) Name {
  return [NSString stringWithCString:_parameter.Name encoding:NSASCIIStringEncoding];
}
- (void) setName:(NSString*)name {

  memset(_parameter.Name, 0, 12);
  
  [name getBytes:(void*)_parameter.Name 
       maxLength:12 
      usedLength:NULL 
        encoding:NSASCIIStringEncoding 
         options:0 
           range:NSMakeRange(0,[name length]) 
  remainingRange:NULL];
}

@end
