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


#import "MKFakeConnection.h"
#import "NSData+MKCommandDecode.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadDecode.h"
#import "NSData+MKPayloadEncode.h"

#import "MKDataConstants.h"
#import "IKParamSet.h"

#import "NSString+Parsing.h"

#undef ql_component
#define ql_component lcl_cCommunication

/***************************************************/
/*    Default Values for parameter set 1           */
/***************************************************/
void CommonDefaults(IKParamSet* EE_Parameter)
{
	EE_Parameter.Revision = [NSNumber numberWithUnsignedChar:85];
  
  EE_Parameter.Gyro_D = [NSNumber numberWithUnsignedChar:10];
  EE_Parameter.Driftkomp = [NSNumber numberWithUnsignedChar:0];
  EE_Parameter.GyroAccFaktor = [NSNumber numberWithUnsignedChar:27];
  EE_Parameter.WinkelUmschlagNick = [NSNumber numberWithUnsignedChar:78];
  EE_Parameter.WinkelUmschlagRoll = [NSNumber numberWithUnsignedChar:78];
  EE_Parameter.Gyro_D = [NSNumber numberWithUnsignedChar:3];
  EE_Parameter.Driftkomp = [NSNumber numberWithUnsignedChar:32];
  EE_Parameter.GyroAccFaktor = [NSNumber numberWithUnsignedChar:30];
  EE_Parameter.WinkelUmschlagNick = [NSNumber numberWithUnsignedChar:85];
  EE_Parameter.WinkelUmschlagRoll = [NSNumber numberWithUnsignedChar:85];
	EE_Parameter.GlobalConfig = [NSNumber numberWithUnsignedChar:CFG_ACHSENKOPPLUNG_AKTIV | CFG_KOMPASS_AKTIV | CFG_GPS_AKTIV | CFG_HOEHEN_SCHALTER];
	EE_Parameter.ExtraConfig = [NSNumber numberWithUnsignedChar:CFG2_HEIGHT_LIMIT | CFG2_VARIO_BEEP];
	EE_Parameter.Receiver = [NSNumber numberWithUnsignedChar:RECEIVER_SPEKTRUM];
	EE_Parameter.MotorSafetySwitch = [NSNumber numberWithUnsignedChar:0]; 
	EE_Parameter.ExternalControl = [NSNumber numberWithUnsignedChar:0];
  
	EE_Parameter.Gas_Min = [NSNumber numberWithUnsignedChar:8];             // Wert : 0-32
	EE_Parameter.Gas_Max = [NSNumber numberWithUnsignedChar:230];           // Wert : 33-247
	EE_Parameter.KompassWirkung = [NSNumber numberWithUnsignedChar:128];    // Wert : 0-247
  
	EE_Parameter.Hoehe_MinGas = [NSNumber numberWithUnsignedChar:30];
	EE_Parameter.MaxHoehe     = [NSNumber numberWithUnsignedChar:255];         // Wert : 0-247   255 -> Poti1
	EE_Parameter.Hoehe_P      = [NSNumber numberWithUnsignedChar:15];          // Wert : 0-32
	EE_Parameter.Luftdruck_D  = [NSNumber numberWithUnsignedChar:30];          // Wert : 0-247
	EE_Parameter.Hoehe_ACC_Wirkung = [NSNumber numberWithUnsignedChar:0];     // Wert : 0-247
	EE_Parameter.Hoehe_HoverBand = [NSNumber numberWithUnsignedChar:8];     	  // Wert : 0-247
	EE_Parameter.Hoehe_GPS_Z = [NSNumber numberWithUnsignedChar:64];           // Wert : 0-247
	EE_Parameter.Hoehe_StickNeutralPoint = [NSNumber numberWithUnsignedChar:0];// Wert : 0-247 (0 = Hover-Estimation)
	EE_Parameter.Hoehe_Verstaerkung = [NSNumber numberWithUnsignedChar:15];    // Wert : 0-50
  
	EE_Parameter.UserParam1 = [NSNumber numberWithUnsignedChar:  0];           // zur freien Verwendung
	EE_Parameter.UserParam2 = [NSNumber numberWithUnsignedChar:  0];           // zur freien Verwendung
	EE_Parameter.UserParam3 = [NSNumber numberWithUnsignedChar:  0];           // zur freien Verwendung
	EE_Parameter.UserParam4 = [NSNumber numberWithUnsignedChar:  0];           // zur freien Verwendung
	EE_Parameter.UserParam5 = [NSNumber numberWithUnsignedChar:  0];           // zur freien Verwendung
	EE_Parameter.UserParam6 = [NSNumber numberWithUnsignedChar:  0];           // zur freien Verwendung
	EE_Parameter.UserParam7 = [NSNumber numberWithUnsignedChar:0];             // zur freien Verwendung
	EE_Parameter.UserParam8 = [NSNumber numberWithUnsignedChar:0];             // zur freien Verwendung
  
	EE_Parameter.ServoNickControl = [NSNumber numberWithUnsignedChar:120];     // Wert : 0-247     // Stellung des Servos
	EE_Parameter.ServoNickComp = [NSNumber numberWithUnsignedChar:40];         // Wert : 0-247     // Einfluss Gyro/Servo
	EE_Parameter.ServoCompInvert = [NSNumber numberWithUnsignedChar:2];        // Wert : 0-247     // Richtung Einfluss Gyro/Servo
	EE_Parameter.ServoNickMin = [NSNumber numberWithUnsignedChar:15];          // Wert : 0-247     // Anschlag
	EE_Parameter.ServoNickMax = [NSNumber numberWithUnsignedChar:247];         // Wert : 0-247     // Anschlag
	EE_Parameter.ServoNickRefresh = [NSNumber numberWithUnsignedChar:5];
	EE_Parameter.Servo3 = [NSNumber numberWithUnsignedChar:125];
	EE_Parameter.Servo4 = [NSNumber numberWithUnsignedChar:125];
	EE_Parameter.Servo5 = [NSNumber numberWithUnsignedChar:125];
	EE_Parameter.ServoRollControl = [NSNumber numberWithUnsignedChar:120];     // Wert : 0-247     // Stellung des Servos
	EE_Parameter.ServoRollComp = [NSNumber numberWithUnsignedChar:90];         // Wert : 0-247     // Einfluss Gyro/Servo
	EE_Parameter.ServoRollMin = [NSNumber numberWithUnsignedChar:0];           // Wert : 0-247     // Anschlag
	EE_Parameter.ServoRollMax = [NSNumber numberWithUnsignedChar:247];         // Wert : 0-247     // Anschlag
	EE_Parameter.ServoManualControlSpeed = [NSNumber numberWithUnsignedChar:40];
	EE_Parameter.CamOrientation = [NSNumber numberWithUnsignedChar:0];
  
	EE_Parameter.J16Bitmask = [NSNumber numberWithUnsignedChar:95];
	EE_Parameter.J17Bitmask = [NSNumber numberWithUnsignedChar:243];
	EE_Parameter.WARN_J16_Bitmask = [NSNumber numberWithUnsignedChar:0xAA];
	EE_Parameter.WARN_J17_Bitmask = [NSNumber numberWithUnsignedChar:0xAA];
	EE_Parameter.J16Timing = [NSNumber numberWithUnsignedChar:20];
	EE_Parameter.J17Timing = [NSNumber numberWithUnsignedChar:20];
  
	EE_Parameter.LoopGasLimit = [NSNumber numberWithUnsignedChar:50];
	EE_Parameter.LoopThreshold = [NSNumber numberWithUnsignedChar:90];         // Wert: 0-247  Schwelle f¸r Stickausschlag
	EE_Parameter.LoopHysterese = [NSNumber numberWithUnsignedChar:50];
	EE_Parameter.BitConfig = [NSNumber numberWithUnsignedChar:0];              // Bitcodiert: 0x01=oben, 0x02=unten, 0x04=links, 0x08=rechts / wird getrennt behandelt
  
	EE_Parameter.NaviGpsModeControl = [NSNumber numberWithUnsignedChar:254]; // 254 -> Poti 2
	EE_Parameter.NaviGpsGain = [NSNumber numberWithUnsignedChar:100];
	EE_Parameter.NaviGpsP = [NSNumber numberWithUnsignedChar:90];
	EE_Parameter.NaviGpsI = [NSNumber numberWithUnsignedChar:90];
	EE_Parameter.NaviGpsD = [NSNumber numberWithUnsignedChar:90];
	EE_Parameter.NaviGpsPLimit = [NSNumber numberWithUnsignedChar:75];
	EE_Parameter.NaviGpsILimit = [NSNumber numberWithUnsignedChar:75];
	EE_Parameter.NaviGpsDLimit = [NSNumber numberWithUnsignedChar:75];
	EE_Parameter.NaviGpsACC = [NSNumber numberWithUnsignedChar:0];
	EE_Parameter.NaviGpsMinSat = [NSNumber numberWithUnsignedChar:6];
	EE_Parameter.NaviStickThreshold = [NSNumber numberWithUnsignedChar:8];
	EE_Parameter.NaviWindCorrection = [NSNumber numberWithUnsignedChar:90];
	EE_Parameter.NaviSpeedCompensation = [NSNumber numberWithUnsignedChar:30];
	EE_Parameter.NaviOperatingRadius = [NSNumber numberWithUnsignedChar:100];
	EE_Parameter.NaviAngleLimitation = [NSNumber numberWithUnsignedChar:100];
	EE_Parameter.NaviPH_LoginTime = [NSNumber numberWithUnsignedChar:2];
	EE_Parameter.OrientationAngle = [NSNumber numberWithUnsignedChar:0];
	EE_Parameter.OrientationModeControl = [NSNumber numberWithUnsignedChar:0];
	EE_Parameter.UnterspannungsWarnung = [NSNumber numberWithUnsignedChar:33]; // Wert : 0-247 ( Automatische Zellenerkennung bei < 50)
	EE_Parameter.NotGas = [NSNumber numberWithUnsignedChar:45];                // Wert : 0-247     // Gaswert bei Empangsverlust
	EE_Parameter.NotGasZeit = [NSNumber numberWithUnsignedChar:90];            // Wert : 0-247     // Zeit bis auf NotGas geschaltet wird, wg. Rx-Problemen
}

void ParamSet_DefaultSet1(IKParamSet* EE_Parameter) // sport
{
	CommonDefaults(EE_Parameter);
	EE_Parameter.Stick_P = [NSNumber numberWithUnsignedChar:14];            // Wert : 1-20
	EE_Parameter.Stick_D = [NSNumber numberWithUnsignedChar:16];            // Wert : 0-20
	EE_Parameter.Gier_P = [NSNumber numberWithUnsignedChar:12];             // Wert : 1-20
	EE_Parameter.Gyro_P = [NSNumber numberWithUnsignedChar:80];             // Wert : 0-247
	EE_Parameter.Gyro_I = [NSNumber numberWithUnsignedChar:150];            // Wert : 0-247
	EE_Parameter.Gyro_Gier_P = [NSNumber numberWithUnsignedChar:80];        // Wert : 0-247
	EE_Parameter.Gyro_Gier_I = [NSNumber numberWithUnsignedChar:150];       // Wert : 0-247
	EE_Parameter.Gyro_Stability = [NSNumber numberWithUnsignedChar:6]; 	  // Wert : 1-8
	EE_Parameter.I_Faktor = [NSNumber numberWithUnsignedChar:32];
	EE_Parameter.AchsKopplung1 = [NSNumber numberWithUnsignedChar:90];
	EE_Parameter.AchsKopplung2 = [NSNumber numberWithUnsignedChar:80];
	EE_Parameter.CouplingYawCorrection = [NSNumber numberWithUnsignedChar:1];
	EE_Parameter.GyroAccAbgleich = [NSNumber numberWithUnsignedChar:16];        // 1/k];
	EE_Parameter.DynamicStability = [NSNumber numberWithUnsignedChar:100];
	EE_Parameter.Name=@"Sport";
}


/***************************************************/
/*    Default Values for parameter set 2           */
/***************************************************/
void ParamSet_DefaultSet2(IKParamSet* EE_Parameter) // normal
{
	CommonDefaults(EE_Parameter);
	EE_Parameter.Stick_P = [NSNumber numberWithUnsignedChar:10];               // Wert : 1-20
	EE_Parameter.Stick_D = [NSNumber numberWithUnsignedChar:16];               // Wert : 0-20
	EE_Parameter.Gier_P = [NSNumber numberWithUnsignedChar:6];                 // Wert : 1-20
	EE_Parameter.Gyro_P = [NSNumber numberWithUnsignedChar:90];                // Wert : 0-247
	EE_Parameter.Gyro_I = [NSNumber numberWithUnsignedChar:120];               // Wert : 0-247
	EE_Parameter.Gyro_Gier_P = [NSNumber numberWithUnsignedChar:90];           // Wert : 0-247
	EE_Parameter.Gyro_Gier_I = [NSNumber numberWithUnsignedChar:120];          // Wert : 0-247
	EE_Parameter.Gyro_Stability = [NSNumber numberWithUnsignedChar:6]; 	  	  // Wert : 1-8
	EE_Parameter.I_Faktor = [NSNumber numberWithUnsignedChar:32];
	EE_Parameter.AchsKopplung1 = [NSNumber numberWithUnsignedChar:90];
	EE_Parameter.AchsKopplung2 = [NSNumber numberWithUnsignedChar:80];
	EE_Parameter.CouplingYawCorrection = [NSNumber numberWithUnsignedChar:60];
	EE_Parameter.GyroAccAbgleich = [NSNumber numberWithUnsignedChar:32];        // 1/k
	EE_Parameter.DynamicStability = [NSNumber numberWithUnsignedChar:75];
  EE_Parameter.Name=@"Normal";

}


/***************************************************/
/*    Default Values for parameter set 3           */
/***************************************************/
void ParamSet_DefaultSet3(IKParamSet* EE_Parameter) // beginner
{
	CommonDefaults(EE_Parameter);
	EE_Parameter.Stick_P = [NSNumber numberWithUnsignedChar:8];                // Wert : 1-20
	EE_Parameter.Stick_D = [NSNumber numberWithUnsignedChar:16];               // Wert : 0-20
	EE_Parameter.Gier_P  = [NSNumber numberWithUnsignedChar:6];                // Wert : 1-20
	EE_Parameter.Gyro_P = [NSNumber numberWithUnsignedChar:100];               // Wert : 0-247
	EE_Parameter.Gyro_I = [NSNumber numberWithUnsignedChar:120];               // Wert : 0-247
	EE_Parameter.Gyro_Gier_P = [NSNumber numberWithUnsignedChar:100];          // Wert : 0-247
	EE_Parameter.Gyro_Gier_I = [NSNumber numberWithUnsignedChar:120];          // Wert : 0-247
	EE_Parameter.Gyro_Stability = [NSNumber numberWithUnsignedChar:6]; 	  	  // Wert : 1-8
	EE_Parameter.I_Faktor = [NSNumber numberWithUnsignedChar:16];
	EE_Parameter.AchsKopplung1 = [NSNumber numberWithUnsignedChar:90];
	EE_Parameter.AchsKopplung2 = [NSNumber numberWithUnsignedChar:80];
	EE_Parameter.CouplingYawCorrection = [NSNumber numberWithUnsignedChar:70];
	EE_Parameter.GyroAccAbgleich = [NSNumber numberWithUnsignedChar:32];        // 1/k
	EE_Parameter.DynamicStability = [NSNumber numberWithUnsignedChar:70];
	EE_Parameter.Name=@"Beginner";
}

///////////////////////////////////////////////////////////////////////////////////

enum CsvIndex {
  CSV_altimeter=0,CSV_angleNick,CSV_angleRoll,CSV_compassHeading,CSV_current,CSV_currentPosition,
  CSV_errorCode,CSV_fcStatusFlags,CSV_fcStatusFlags2,CSV_flyingTime,CSV_gas,CSV_groundSpeed,
  CSV_heading,CSV_homePosition,CSV_homePositionDeviation,CSV_ncFlags,CSV_operatingRadius,
  CSV_rcQuality,CSV_satsInUse,CSV_setpointAltitude,CSV_targetHoldTime,CSV_targetPosition,
  CSV_targetPositionDeviation,CSV_timeStamp,CSV_topSpeed,CSV_uBat,CSV_usedCapacity,
  CSV_variometer,CSV_version,CSV_waypointIndex,CSV_waypointNumber
};


@interface MKFakeConnection()

-(void) nextRow;
-(void) updateNaviDataFromRow:(NSInteger)row;

@end

///////////////////////////////////////////////////////////////////////////////////

static NSString * const MKDummyConnectionException = @"MKDummyConnectionException";

@interface MKFakeConnection ()

- (void) doConnect;
- (void) doDisconnect;
- (void) doResponseMkData:(NSData*)data;

@property(nonatomic,retain) NSArray* osdData;

@end

@implementation MKFakeConnection

#pragma mark Properties

@synthesize delegate;
@synthesize osdData;

#pragma mark Initialization

- (id) init {
  return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(id)theDelegate;
{
  if (self = [super init]) {
    self.delegate = theDelegate;
    
    settings = [[NSMutableArray array] retain];
      
    IKParamSet* p=[[[IKParamSet alloc]init]autorelease];
    ParamSet_DefaultSet1(p);
    [settings addObject:p];
    p=[[[IKParamSet alloc]init]autorelease];
    ParamSet_DefaultSet2(p);
    [settings addObject:p];
    p=[[[IKParamSet alloc]init]autorelease];
    ParamSet_DefaultSet3(p);
    [settings addObject:p];
    p=[[[IKParamSet alloc]init]autorelease];
    ParamSet_DefaultSet3(p);
    [settings addObject:p];
    p=[[[IKParamSet alloc]init]autorelease];
    ParamSet_DefaultSet3(p);
    [settings addObject:p];
    
    activeSetting = 3;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"FakeOsd" 
                                                         ofType:@"csv"];
    
    NSError*  error;
    NSString* data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error ];
    
    
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
      self.osdData = [data csvRows];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        dataRow = 0;
        [self updateNaviDataFromRow:dataRow];
        
        osdTimer=[NSTimer scheduledTimerWithTimeInterval: 1.0 
                                                  target:self 
                                                selector:@selector(nextRow) 
                                                userInfo:nil 
                                                 repeats:YES];
      });
    });
  }
  return self;
}

- (void) dealloc {
  
  [osdTimer invalidate];
  osdTimer=nil;
  
  self.osdData = nil;
  
  [settings release];
  [super dealloc];
}

#pragma mark -
#pragma mark MKInput

- (BOOL) connectTo:(MKHost*)hostOrDevice error:(NSError **)err;
{
  if (delegate == nil) {
    [NSException raise:MKDummyConnectionException
                format:@"Attempting to connect without a delegate. Set a delegate first."];
  }
  
  [self performSelector:@selector(doConnect) withObject:nil afterDelay:0.5];
  return YES;
}

- (BOOL) isConnected;
{
  return isConnected;
}

- (void) disconnect;
{
  [self performSelector:@selector(doDisconnect) withObject:nil afterDelay:0.1];
}

- (void) writeMkData:(NSData *)data;
{
  [self performSelector:@selector(doResponseMkData:) withObject:[data retain] afterDelay:0.1];
}

#pragma mark -


- (NSData*) versionResponse;
{
  IKMkVersionInfo v;
  v.SWMajor = 0;
  v.SWMinor = 78;
  v.ProtoMajor = 3; 
  v.ProtoMinor = 1;
  v.SWPatch = 3;
  NSData * payload = [NSData dataWithBytes:(void*)&v length:sizeof(v)];
  return payload;
}

- (NSData*) debugResponse;
{
  IKMkDebugOut d;
  NSData * payload = [NSData dataWithBytes:(void*)&d length:sizeof(d)];
  return payload;
}

- (NSData*) osdResponse{
  
  NSData * payload = [NSData dataWithBytes:(void*)&naviData length:sizeof(naviData)];
  return payload;
}

- (NSData*) channelResponse;
{
  int16_t data[26];
  
  for (int i=0; i<26; i++) {
    data[i]=random()%250;
  }
  
  NSData * payload = [NSData dataWithBytes:(void*)&data length:sizeof(data)];
  return payload;
}



- (NSData*) menuResponse:(NSData*)payload {
  
  const char * bytes = [payload bytes];
  
  uint8_t key=(uint8_t)bytes[0];
  //  uint8_t interval=(uint8_t)bytes[1];
  
  if (key==0xFD) {
    menuPage++;
  } else if (key==0xFE) {
    menuPage--;
  }
  
  menuPage %= 16;
  menuCounter = 1;
  
  NSString* screen=[NSString stringWithFormat:@"Page %02d (%d)------->>12345678901234567890abcdefghijklmnopqrst++++++++++++++++++>>",
                    menuPage,menuCounter];
  
  NSData * newPayload = [screen dataUsingEncoding:NSASCIIStringEncoding];
  
  [self performSelector:@selector(resendMenuResponse) withObject:nil afterDelay:0.5];
  
  return newPayload;
}

- (void) resendMenuResponse {
  
  NSString* screen=[NSString stringWithFormat:@"Page %02d (%d)-------<<12345678901234567890abcdefghijklmnopqrst++++++++++++++++++<<",
                    menuPage,menuCounter];
  
  NSData * newPayload = [screen dataUsingEncoding:NSASCIIStringEncoding];
  
  NSData * rspData = [newPayload dataWithCommand:MKCommandLcdResponse forAddress:kIKMkAddressFC];
  
  if ( [delegate respondsToSelector:@selector(didReadMkData:)] ) {
    [delegate didReadMkData:rspData];
  } 
  
  if ( (++menuCounter)<2 ) {
    [self performSelector:@selector(resendMenuResponse) withObject:nil afterDelay:0.5];
  }
} 



- (NSData*) changeSettingsResponse:(NSData*)payload {
  
  const char * bytes = [payload bytes];
  
  uint8_t index=(uint8_t)bytes[0];
  
  activeSetting = index;
  
  NSData * newPayload = [NSData dataWithBytes:(void*)&index length:sizeof(index)];
  return newPayload;
  
}

- (NSData*) writeSettingResponse:(NSData*)payload {
  
  NSDictionary* d = [payload decodeReadSettingResponse];
  
  IKParamSet* p= [d objectForKey:kIKDataKeyParamSet]; 
  
  NSUInteger index = [[p Index] unsignedIntValue];
  
  [settings replaceObjectAtIndex:index-1 withObject:p];
  
  NSData * newPayload = [NSData dataWithBytes:(void*)&index length:sizeof(index)];
  return newPayload;
}

- (NSData*) readSettingResponse:(NSData*)payload {
  
  const char * bytes = [payload bytes];
  
  uint8_t index=(uint8_t)bytes[0];
  
  if (index==0xFF) {
    index=activeSetting;
  }
  
  if( index> [settings count]) index=1;
  
  index--;
  
  IKParamSet* p = [settings objectAtIndex:index];
  p.Index = [NSNumber numberWithInt:index+1];
  
  qltrace(@"%@",p);
  
  NSData * newPayload = [p data]; //[NSData payloadForWriteSettingRequest:d];
  
  return newPayload;
}

#pragma mark -

- (void) doConnect {
  
  isConnected=YES;
  if ( [delegate respondsToSelector:@selector(didConnectTo:)] ) {
    [delegate didConnectTo:@"Dummy"];
  }
  
  NSData * data = [NSData dataWithCommand:MKCommandVersionRequest
                               forAddress:kIKMkAddressAll
                         payloadWithBytes:NULL
                                   length:0];
  
  [self writeMkData:data];
}


- (void) doDisconnect {
  isConnected=NO;
  if ( [delegate respondsToSelector:@selector(didDisconnect)] ) {
    [delegate didDisconnect];
  }
}

- (void) doResponseMkData:(NSData*)data {
  
  if ([data isCrcOk]) {
    
    NSData * payload = [data payload];
    //    IKMkAddress address = [data address];
    
    NSData * rspPayload;
    MKCommandId rspCommand;  
    
    qltrace(@"Need responde for command %c",[data command]);
    
    switch ([data command]) {
        /*
         case MKCommandLcdMenuResponse:
         n = MKLcdMenuNotification;
         d = [payload decodeLcdMenuResponse];
         break;
         case MKCommandLcdResponse:
         n = MKLcdNotification;
         d = [payload decodeLcdResponse];
         break;
         case MKCommandDebugLabelResponse:
         n = MKDebugLabelNotification;
         d = [payload decodeAnalogLabelResponse];
         break;
         */
      case MKCommandLcdRequest:
        rspPayload = [self menuResponse:payload];
        rspCommand = MKCommandLcdResponse;
        break;
      case MKCommandDebugValueRequest:
        rspPayload = [self debugResponse];
        rspCommand = MKCommandDebugValueResponse;
        break;
      case MKCommandChannelsValueRequest:
        rspPayload = [self channelResponse];
        rspCommand = MKCommandChannelsValueResponse;
        break;
      case MKCommandVersionRequest:
        rspPayload = [self versionResponse];
        rspCommand = MKCommandVersionResponse;
        break;
      case MKCommandChangeSettingsRequest:
        rspPayload = [self changeSettingsResponse:payload];
        rspCommand = MKCommandChangeSettingsResponse;
        break;
      case MKCommandReadSettingsRequest:
        rspPayload = [self readSettingResponse:payload];
        rspCommand = MKCommandReadSettingsResponse;
        break;
      case MKCommandWriteSettingsRequest:
        rspPayload = [self writeSettingResponse:payload];
        rspCommand = MKCommandWriteSettingsResponse;
        break;
      case MKCommandOsdRequest:
        rspPayload = [self osdResponse];
        rspCommand = MKCommandOsdResponse;
        break;
      case MKCommandEngineTestRequest:
        qltrace(@"Engine Test %@",payload);
        [data release];
        return;
      default:
        qltrace(@"Unknown command %c",[data command]);
        [data release];
        return;
    }
    
    NSData * rspData = [rspPayload dataWithCommand:rspCommand forAddress:kIKMkAddressFC];
    
    if ( [delegate respondsToSelector:@selector(didReadMkData:)] ) {
      [delegate didReadMkData:rspData];
    } 
    
  }  
  
  [data release];
}

-(void) nextRow {
  dataRow = (++dataRow % [self.osdData count]);
  
  [self updateNaviDataFromRow:dataRow];
}


void fillIKMkGPSPosDevFromString(NSString* data,IKMkGPSPosDev* pos){
  
  NSArray *components=[data componentsSeparatedByString:@":"];
  
  pos->Distance = [[components objectAtIndex:0] intValue];
  pos->Bearing = [[components objectAtIndex:1] intValue];
}

void fillIKMkGPSPosFromString(NSString* data,IKMkGPSPos* pos){
  
  NSArray *components=[data componentsSeparatedByString:@":"];

  pos->Latitude = [[components objectAtIndex:0] intValue];
  pos->Longitude = [[components objectAtIndex:1] intValue];

  pos->Altitude = [[components objectAtIndex:2] intValue];
  pos->Status = [[components objectAtIndex:3] intValue];
}

-(void) updateNaviDataFromRow:(NSInteger)row {
  NSArray* columns = [self.osdData objectAtIndex:row];
  
  naviData.Version=NAVIDATA_VERSION;
  
  fillIKMkGPSPosFromString([columns objectAtIndex:CSV_currentPosition], &(naviData.CurrentPosition));
  fillIKMkGPSPosFromString([columns objectAtIndex:CSV_targetPosition], &(naviData.TargetPosition));
  fillIKMkGPSPosFromString([columns objectAtIndex:CSV_homePosition], &(naviData.HomePosition));
  
  fillIKMkGPSPosDevFromString([columns objectAtIndex:CSV_homePositionDeviation], &(naviData.HomePositionDeviation));
  fillIKMkGPSPosDevFromString([columns objectAtIndex:CSV_targetPositionDeviation], &(naviData.TargetPositionDeviation));
  
  naviData.WaypointIndex = [[columns objectAtIndex:CSV_waypointIndex] intValue];        // index of current waypoints running from 0 to WaypointNumber-1
  naviData.WaypointNumber = [[columns objectAtIndex:CSV_waypointNumber] intValue];       // number of stored waypoints
  naviData.SatsInUse = [[columns objectAtIndex:CSV_satsInUse] intValue];          // number of satellites used for position solution
  naviData.Altimeter = [[columns objectAtIndex:CSV_altimeter] intValue];          // hight according to air pressure
  naviData.Variometer = [[columns objectAtIndex:CSV_variometer] intValue];         // climb(+) and sink(-) rate
  naviData.FlyingTime = [[columns objectAtIndex:CSV_flyingTime] intValue];         // in seconds
  naviData.UBat = [[columns objectAtIndex:CSV_uBat] intValue];           // Battery Voltage in 0.1 Volts
  naviData.GroundSpeed = [[columns objectAtIndex:CSV_groundSpeed] intValue];        // speed over ground in cm/s (2D)
  naviData.Heading = [[columns objectAtIndex:CSV_heading] intValue];          // current flight direction in � as angle to north
  naviData.CompassHeading = [[columns objectAtIndex:CSV_compassHeading] intValue];       // current compass value in �
  naviData.AngleNick = [[columns objectAtIndex:CSV_angleNick] intValue];          // current Nick angle in 1�
  naviData.AngleRoll = [[columns objectAtIndex:CSV_angleRoll] intValue];          // current Rick angle in 1�
  naviData.RC_Quality = [[columns objectAtIndex:CSV_rcQuality] intValue];         // RC_Quality
  naviData.FCStatusFlags = [[columns objectAtIndex:CSV_fcStatusFlags] intValue];        // Flags from FC
  naviData.NCFlags = [[columns objectAtIndex:CSV_ncFlags] intValue];          // Flags from NC
  naviData.Errorcode = [[columns objectAtIndex:CSV_errorCode] intValue];          // 0 --> okay
  naviData.OperatingRadius = [[columns objectAtIndex:CSV_operatingRadius] intValue];      // current operation radius around the Home Position in m
  naviData.TopSpeed = [[columns objectAtIndex:CSV_topSpeed] intValue];         // velocity in vertical direction in cm/s
  naviData.TargetHoldTime = [[columns objectAtIndex:CSV_targetHoldTime] intValue];       // time in s to stay at the given target, counts down to 0 if target has been reached
  naviData.FCStatusFlags2 = [[columns objectAtIndex:CSV_fcStatusFlags2] intValue];				// StatusFlags2 (since version 5 added)
  naviData.SetpointAltitude = [[columns objectAtIndex:CSV_setpointAltitude] intValue];     // setpoint for altitude
  naviData.Gas = [[columns objectAtIndex:CSV_gas] intValue];            // for future use
  naviData.Current = [[columns objectAtIndex:CSV_current] intValue];          // actual current in 0.1A steps
  naviData.UsedCapacity = [[columns objectAtIndex:CSV_usedCapacity] intValue];       // used capacity in mAh
}


@end
