//
//  iKopterTests.m
//  iKopterTests
//
//  Created by Frank Blumenberg on 15.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iKopterTests.h"
#import "IKMkDataTypes.h"
#import "IKParamSet.h"

@implementation iKopterTests

static void fillIKMkParamset85(IKMkParamset85* p){
  
  p->Index                          =1;
	p->Revision                       =85;
	p->Kanalbelegung[ 0]              =13;
	p->Kanalbelegung[ 1]              =14;
	p->Kanalbelegung[ 2]              =15;
	p->Kanalbelegung[ 3]              =16;
	p->Kanalbelegung[ 4]              =17;
	p->Kanalbelegung[ 5]              =18;
	p->Kanalbelegung[ 6]              =19;
	p->Kanalbelegung[ 7]              =20;
	p->Kanalbelegung[ 8]              =21;
	p->Kanalbelegung[ 9]              =22;
	p->Kanalbelegung[10]              =23;
	p->Kanalbelegung[11]              =24;
	p->GlobalConfig                   =26;
	p->Hoehe_MinGas                   =27;
	p->Luftdruck_D                    =28;
	p->MaxHoehe                       =29;
	p->Hoehe_P                        =30;
	p->Hoehe_Verstaerkung             =31;
	p->Hoehe_ACC_Wirkung              =32;
	p->Hoehe_HoverBand                =33;
	p->Hoehe_GPS_Z                    =34;
	p->Hoehe_StickNeutralPoint        =35;
	p->Stick_P                        =36;
	p->Stick_D                        =37;
	p->Gier_P                         =38;
	p->Gas_Min                        =39;
	p->Gas_Max                        =40;
	p->GyroAccFaktor                  =41;
	p->KompassWirkung                 =42;
	p->Gyro_P                         =43;
	p->Gyro_I                         =44;
	p->Gyro_D                         =45;
	p->Gyro_Gier_P                    =46;
	p->Gyro_Gier_I                    =47;
	p->Gyro_Stability                 =48;
	p->UnterspannungsWarnung          =49;
	p->NotGas                         =50;
	p->NotGasZeit                     =51;
	p->Receiver                       =52;
	p->I_Faktor                       =53;
	p->UserParam1                     =54;
	p->UserParam2                     =55;
	p->UserParam3                     =56;
	p->UserParam4                     =57;
	p->ServoNickControl               =58;
	p->ServoNickComp                  =59;
	p->ServoNickMin                   =60;
	p->ServoNickMax                   =61;
	p->ServoRollControl               =62;
	p->ServoRollComp                  =63;
	p->ServoRollMin                   =64;
	p->ServoRollMax                   =65;
	p->ServoNickRefresh               =66;
  p->ServoManualControlSpeed        =67;
  p->CamOrientation                 =68;
	p->Servo3                         =69;
	p->Servo4                         =70;
	p->Servo5                         =71;
	p->LoopGasLimit                   =72;
	p->LoopThreshold                  =73;
	p->LoopHysterese                  =74;
	p->AchsKopplung1                  =75;
	p->AchsKopplung2                  =76;
	p->CouplingYawCorrection          =77;
	p->WinkelUmschlagNick             =78;
	p->WinkelUmschlagRoll             =79;
	p->GyroAccAbgleich                =80;
	p->Driftkomp                      =81;
	p->DynamicStability               =82;
	p->UserParam5                     =83;
	p->UserParam6                     =84;
	p->UserParam7                     =85;
	p->UserParam8                     =86;
	p->J16Bitmask                     =87;
	p->J16Timing                      =88;
	p->J17Bitmask                     =89;
	p->J17Timing                      =90;
	p->WARN_J16_Bitmask               =91;
	p->WARN_J17_Bitmask               =92;
	p->NaviGpsModeControl             =93;
	p->NaviGpsGain                    =94;
	p->NaviGpsP                       =95;
	p->NaviGpsI                       =96;
	p->NaviGpsD                       =97;
	p->NaviGpsPLimit                  =98;
	p->NaviGpsILimit                  =99;
	p->NaviGpsDLimit                  =110;
	p->NaviGpsACC                     =111;
	p->NaviGpsMinSat                  =112;
	p->NaviStickThreshold             =113;
	p->NaviWindCorrection             =114;
	p->NaviSpeedCompensation          =115;
	p->NaviOperatingRadius            =116;
	p->NaviAngleLimitation            =117;
	p->NaviPH_LoginTime               =118;
	p->ExternalControl                =119;
	p->OrientationAngle               =120;
	p->OrientationModeControl         =121;
  p->MotorSafetySwitch              =122;
//  p->MotorSmooth                    =123;
//  p->ComingHomeAltitude             =124;
//  p->FailSafeTime                   =125;
//  p->MaxAltitude                    =126;
  //	p->FailsafeChannel                =127;
  //	p->ServoFilterNick                =128;
  //	p->ServoFilterRoll                =129;
	p->BitConfig                      =130;
	p->ServoCompInvert                =131;
	p->ExtraConfig                    =132;
  //	p->GlobalConfig3                  =133;
//	p->crc                            =134;
  strcpy(p->Name, "Paramsert80");
}

static void fillIKMkParamset88(IKMkParamset88* p){
  
  p->Index                          =1;
	p->Revision                       =88;
	p->Kanalbelegung[ 0]              =13;
	p->Kanalbelegung[ 1]              =14;
	p->Kanalbelegung[ 2]              =15;
	p->Kanalbelegung[ 3]              =16;
	p->Kanalbelegung[ 4]              =17;
	p->Kanalbelegung[ 5]              =18;
	p->Kanalbelegung[ 6]              =19;
	p->Kanalbelegung[ 7]              =20;
	p->Kanalbelegung[ 8]              =21;
	p->Kanalbelegung[ 9]              =22;
	p->Kanalbelegung[10]              =23;
	p->Kanalbelegung[11]              =24;
	p->GlobalConfig                   =26;
	p->Hoehe_MinGas                   =27;
	p->Luftdruck_D                    =28;
	p->MaxHoehe                       =29;
	p->Hoehe_P                        =30;
	p->Hoehe_Verstaerkung             =31;
	p->Hoehe_ACC_Wirkung              =32;
	p->Hoehe_HoverBand                =33;
	p->Hoehe_GPS_Z                    =34;
	p->Hoehe_StickNeutralPoint        =35;
	p->Stick_P                        =36;
	p->Stick_D                        =37;
	p->StickGier_P                    =38;
	p->Gas_Min                        =39;
	p->Gas_Max                        =40;
	p->GyroAccFaktor                  =41;
	p->KompassWirkung                 =42;
	p->Gyro_P                         =43;
	p->Gyro_I                         =44;
	p->Gyro_D                         =45;
	p->Gyro_Gier_P                    =46;
	p->Gyro_Gier_I                    =47;
	p->Gyro_Stability                 =48;
	p->UnterspannungsWarnung          =49;
	p->NotGas                         =50;
	p->NotGasZeit                     =51;
	p->Receiver                       =52;
	p->I_Faktor                       =53;
	p->UserParam1                     =54;
	p->UserParam2                     =55;
	p->UserParam3                     =56;
	p->UserParam4                     =57;
	p->ServoNickControl               =58;
	p->ServoNickComp                  =59;
	p->ServoNickMin                   =60;
	p->ServoNickMax                   =61;
	p->ServoRollControl               =62;
	p->ServoRollComp                  =63;
	p->ServoRollMin                   =64;
	p->ServoRollMax                   =65;
	p->ServoNickRefresh               =66;
  p->ServoManualControlSpeed        =67;
  p->CamOrientation                 =68;
	p->Servo3                         =69;
	p->Servo4                         =70;
	p->Servo5                         =71;
	p->LoopGasLimit                   =72;
	p->LoopThreshold                  =73;
	p->LoopHysterese                  =74;
	p->AchsKopplung1                  =75;
	p->AchsKopplung2                  =76;
	p->CouplingYawCorrection          =77;
	p->WinkelUmschlagNick             =78;
	p->WinkelUmschlagRoll             =79;
	p->GyroAccAbgleich                =80;
	p->Driftkomp                      =81;
	p->DynamicStability               =82;
	p->UserParam5                     =83;
	p->UserParam6                     =84;
	p->UserParam7                     =85;
	p->UserParam8                     =86;
	p->J16Bitmask                     =87;
	p->J16Timing                      =88;
	p->J17Bitmask                     =89;
	p->J17Timing                      =90;
	p->WARN_J16_Bitmask               =91;
	p->WARN_J17_Bitmask               =92;
	p->NaviGpsModeControl             =93;
	p->NaviGpsGain                    =94;
	p->NaviGpsP                       =95;
	p->NaviGpsI                       =96;
	p->NaviGpsD                       =97;
	p->NaviGpsPLimit                  =98;
	p->NaviGpsILimit                  =99;
	p->NaviGpsDLimit                  =110;
	p->NaviGpsACC                     =111;
	p->NaviGpsMinSat                  =112;
	p->NaviStickThreshold             =113;
	p->NaviWindCorrection             =114;
	p->NaviAccCompensation            =115;
	p->NaviOperatingRadius            =116;
	p->NaviAngleLimitation            =117;
	p->NaviPH_LoginTime               =118;
	p->ExternalControl                =119;
	p->OrientationAngle               =120;
	p->CareFreeModeControl            =121;
  p->MotorSafetySwitch              =122;
  p->MotorSmooth                    =123;
  p->ComingHomeAltitude             =124;
  p->FailSafeTime                   =125;
  p->MaxAltitude                    =126;
//	p->FailsafeChannel                =127;
//	p->ServoFilterNick                =128;
//	p->ServoFilterRoll                =129;
	p->BitConfig                      =130;
	p->ServoCompInvert                =131;
	p->ExtraConfig                    =132;
//	p->GlobalConfig3                  =133;
//	p->crc                            =134;
  strcpy(p->Name, "Paramsert88");
}

static void fillIKMkParamset90(IKMkParamset90* p){
  
  p->Index                          =1;
	p->Revision                       =90;
	p->Kanalbelegung[ 0]              =13;
	p->Kanalbelegung[ 1]              =14;
	p->Kanalbelegung[ 2]              =15;
	p->Kanalbelegung[ 3]              =16;
	p->Kanalbelegung[ 4]              =17;
	p->Kanalbelegung[ 5]              =18;
	p->Kanalbelegung[ 6]              =19;
	p->Kanalbelegung[ 7]              =20;
	p->Kanalbelegung[ 8]              =21;
	p->Kanalbelegung[ 9]              =22;
	p->Kanalbelegung[10]              =23;
	p->Kanalbelegung[11]              =24;
	p->GlobalConfig                   =26;
	p->Hoehe_MinGas                   =27;
	p->Luftdruck_D                    =28;
	p->MaxHoehe                       =29;
	p->Hoehe_P                        =30;
	p->Hoehe_Verstaerkung             =31;
	p->Hoehe_ACC_Wirkung              =32;
	p->Hoehe_HoverBand                =33;
	p->Hoehe_GPS_Z                    =34;
	p->Hoehe_StickNeutralPoint        =35;
	p->Stick_P                        =36;
	p->Stick_D                        =37;
	p->StickGier_P                    =38;
	p->Gas_Min                        =39;
	p->Gas_Max                        =40;
	p->GyroAccFaktor                  =41;
	p->KompassWirkung                 =42;
	p->Gyro_P                         =43;
	p->Gyro_I                         =44;
	p->Gyro_D                         =45;
	p->Gyro_Gier_P                    =46;
	p->Gyro_Gier_I                    =47;
	p->Gyro_Stability                 =48;
	p->UnterspannungsWarnung          =49;
	p->NotGas                         =50;
	p->NotGasZeit                     =51;
	p->Receiver                       =52;
	p->I_Faktor                       =53;
	p->UserParam1                     =54;
	p->UserParam2                     =55;
	p->UserParam3                     =56;
	p->UserParam4                     =57;
	p->ServoNickControl               =58;
	p->ServoNickComp                  =59;
	p->ServoNickMin                   =60;
	p->ServoNickMax                   =61;
	p->ServoRollControl               =62;
	p->ServoRollComp                  =63;
	p->ServoRollMin                   =64;
	p->ServoRollMax                   =65;
	p->ServoNickRefresh               =66;
  p->ServoManualControlSpeed        =67;
  p->CamOrientation                 =68;
	p->Servo3                         =69;
	p->Servo4                         =70;
	p->Servo5                         =71;
	p->LoopGasLimit                   =72;
	p->LoopThreshold                  =73;
	p->LoopHysterese                  =74;
	p->AchsKopplung1                  =75;
	p->AchsKopplung2                  =76;
	p->CouplingYawCorrection          =77;
	p->WinkelUmschlagNick             =78;
	p->WinkelUmschlagRoll             =79;
	p->GyroAccAbgleich                =80;
	p->Driftkomp                      =81;
	p->DynamicStability               =82;
	p->UserParam5                     =83;
	p->UserParam6                     =84;
	p->UserParam7                     =85;
	p->UserParam8                     =86;
	p->J16Bitmask                     =87;
	p->J16Timing                      =88;
	p->J17Bitmask                     =89;
	p->J17Timing                      =90;
	p->WARN_J16_Bitmask               =91;
	p->WARN_J17_Bitmask               =92;
	p->NaviGpsModeControl             =93;
	p->NaviGpsGain                    =94;
	p->NaviGpsP                       =95;
	p->NaviGpsI                       =96;
	p->NaviGpsD                       =97;
	p->NaviGpsPLimit                  =98;
	p->NaviGpsILimit                  =99;
	p->NaviGpsDLimit                  =110;
	p->NaviGpsACC                     =111;
	p->NaviGpsMinSat                  =112;
	p->NaviStickThreshold             =113;
	p->NaviWindCorrection             =114;
	p->NaviAccCompensation            =115;
	p->NaviOperatingRadius            =116;
	p->NaviAngleLimitation            =117;
	p->NaviPH_LoginTime               =118;
	p->ExternalControl                =119;
	p->OrientationAngle               =120;
	p->CareFreeModeControl            =121;
  p->MotorSafetySwitch              =122;
  p->MotorSmooth                    =123;
  p->ComingHomeAltitude             =124;
  p->FailSafeTime                   =125;
  p->MaxAltitude                    =126;
	p->FailsafeChannel                =127;
	p->ServoFilterNick                =128;
	p->ServoFilterRoll                =129;
	p->BitConfig                      =130;
	p->ServoCompInvert                =131;
	p->ExtraConfig                    =132;
	p->GlobalConfig3                  =133;
//	p->crc                            =134;
  strcpy(p->Name, "Paramsert90");
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInvalidRevision
{
  IKMkParamset90 pMk;
  fillIKMkParamset90(&pMk);

  pMk.Revision=0;
  NSData * origPayload = [NSData dataWithBytes:(void*)&pMk length:sizeof(pMk)];
  STAssertNotNil(origPayload, @"Payload creating failed");

  STAssertThrows([IKParamSet settingWithData:origPayload], @"");
}

- (void)testParamset90
{
  IKMkParamset90 pMk;
  fillIKMkParamset90(&pMk);
  NSData * origPayload = [NSData dataWithBytes:(void*)&pMk length:sizeof(pMk)];
  STAssertNotNil(origPayload, @"Payload creating failed");
  
  IKParamSet* p = [IKParamSet settingWithData:origPayload];
  STAssertNotNil(p, @"IKParamSet creating failed");

  NSString* name = [NSString stringWithCString:pMk.Name encoding:NSASCIIStringEncoding];
  STAssertNotNil(p.Name, @"IKParamSet name");
  
  STAssertEqualObjects(name, p.Name, @"The names are not equal");

  STAssertEqualObjects(origPayload, [p data], @"The encoded data is not equal");
}

- (void)testParamset90Random
{
  IKMkParamset90 pMk;
  
  arc4random_buf(&pMk, sizeof(pMk));
  pMk.Revision=90;

  NSData * origPayload = [NSData dataWithBytes:(void*)&pMk length:sizeof(pMk)];
  STAssertNotNil(origPayload, @"Payload creating failed");
  
  IKParamSet* p = [IKParamSet settingWithData:origPayload];
  STAssertNotNil(p, @"IKParamSet creating failed");
  
  STAssertEqualObjects(origPayload, [p data], @"The encoded data is not equal");
}

- (void)testParamset88
{
  IKMkParamset88 pMk;
  fillIKMkParamset88(&pMk);

  NSData * origPayload = [NSData dataWithBytes:(void*)&pMk length:sizeof(pMk)];
  STAssertNotNil(origPayload, @"Payload creating failed");
  
  IKParamSet* p = [IKParamSet settingWithData:origPayload];
  STAssertNotNil(p, @"IKParamSet creating failed");
  
  NSString* name = [NSString stringWithCString:pMk.Name encoding:NSASCIIStringEncoding];
  STAssertNotNil(p.Name, @"IKParamSet name");
  
  STAssertEqualObjects(name, p.Name, @"The names are not equal");
  
  STAssertEqualObjects(origPayload, [p data], @"The encoded data is not equal");
}


- (void)testParamset85
{
  IKMkParamset85 pMk;
  fillIKMkParamset85(&pMk);

  NSData * origPayload = [NSData dataWithBytes:(void*)&pMk length:sizeof(pMk)];
  STAssertNotNil(origPayload, @"Payload creating failed");
  
  IKParamSet* p = [IKParamSet settingWithData:origPayload];
  STAssertNotNil(p, @"IKParamSet creating failed");
  
  NSString* name = [NSString stringWithCString:pMk.Name encoding:NSASCIIStringEncoding];
  STAssertNotNil(p.Name, @"IKParamSet name");
  
  STAssertEqualObjects(name, p.Name, @"The names are not equal");
  
  STAssertEqualObjects(origPayload, [p data], @"The encoded data is not equal");
}




@end
