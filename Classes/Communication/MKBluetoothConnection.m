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


#import "MKBluetoothConnection.h"
#import "MKBTStackManager.h"

static NSString * const MKBluetoothConnectionException = @"MKBluetoothConnectionException";

@interface MKBluetoothConnection()

-(void)didDisconnect;
-(void)didConnect;
-(void)didDisconnectWithError:(int) err;
-(void)setAddressFromString:(NSString*)addressString;

- (NSString *) stringForAddress;

@end

@implementation MKBluetoothConnection

#pragma mark Properties

@synthesize delegate;
@synthesize mkData;


//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Initialization

- (id) init {
  return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(id<MKConnectionDelegate>)theDelegate;
{
  if (self == [super init]) {
    
    btManager = [MKBTStackManager sharedInstance];
    btManager.delegate=self;
    
    self.delegate = theDelegate;
    
    memset(address, 0, sizeof(bd_addr_t));
    
  }
  return self;
}

- (void) dealloc {
  DLog("dealloc");
  self.mkData=nil;
  [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark MKInput


-(void)didDisconnect {
  
  int err=bt_close();
  DLog(@"bt_close called with retval %d", err);
  
  opened=NO;
  
  if ( [delegate respondsToSelector:@selector(didDisconnect)] ) {
    [delegate didDisconnect];
  }
}

-(void)didConnect {
  
  opened=YES;
  
  if ( [delegate respondsToSelector:@selector(didConnectTo:)] ) {
    [delegate didConnectTo:[self stringForAddress]];
  }
}

-(void)didDisconnectWithError:(int) err {
  
  int retval=bt_close();
  DLog(@"bt_close called with retval %d", retval);
  
  opened=NO;
  
  if ( [delegate respondsToSelector:@selector(willDisconnectWithError:)] ) {
    [delegate willDisconnectWithError:[NSError errorWithDomain:@"de.frankblumenberg.ikopter" code:err userInfo:nil]];
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (BOOL) connectTo:(NSString *)hostOrDevice error:(NSError **)err;
{
  if (delegate == nil) {
    [NSException raise:MKBluetoothConnectionException
                format:@"Attempting to connect without a delegate. Set a delegate first."];
  }
  
  DLog(@"Try to connect to %@", hostOrDevice);
  
  [self setAddressFromString:hostOrDevice];
  
  self.mkData=[NSMutableData dataWithCapacity:30];
  
  if( bt_open()!=0 ){
    DLog(@"bt_open failed. Maybe no BTStack installed");
    [self didDisconnectWithError:-1];
  }
                                    
  bt_send_cmd(&btstack_set_power_mode, HCI_POWER_ON );
  DLog(@"Did connect to %@", hostOrDevice);
  
  return YES;
}

- (BOOL) isConnected;
{
  return opened;
}

- (void) disconnect;
{
  DLog(@"Try to disconnect from %@", [self stringForAddress]);
  
  DLog(@"Send RFCOMM disconnect");
  bt_send_cmd(&rfcomm_disconnect, rfcomm_channel_id,0);
  DLog(@"Send deactivate");
	bt_send_cmd(&btstack_set_power_mode, HCI_POWER_OFF);
  
  [self didDisconnect];
}

- (void) writeMkData:(NSData *)data;
{
  bt_send_rfcomm(rfcomm_channel_id, (uint8_t*)[data bytes], [data length]);
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)btReadData:(uint8_t *)packet withLen:(uint16_t) size
{
	NSData *data = [NSData dataWithBytes:packet length:size];
	if ([data length] > 0) {
    
    [self.mkData appendData:data];
    
    const char* haystackBytes = [self.mkData bytes];
    static char needle='\r';
    
    for (NSUInteger i=0; i < [self.mkData length]; i++)
    {
      if( haystackBytes[i]==needle ) {
        
        NSRange r={0,i+1};
        NSData* cmdData=[self.mkData subdataWithRange:r];
        
        r=NSMakeRange(i+1,[self.mkData length]-[cmdData length]);
        
        self.mkData=[[self.mkData subdataWithRange:r]mutableCopy];
        
        //        NSString *dataText = [[[NSString alloc] initWithData:cmdData encoding:NSASCIIStringEncoding]autorelease];
        //        NSLog(@"%@",dataText);
        
        if ( [delegate respondsToSelector:@selector(didReadMkData:)] ) {
          [delegate didReadMkData:cmdData];
        }
        break;
      }
    }
	} 
}


- (NSString *) stringForAddress {
	return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", address[0], address[1], address[2],
          address[3], address[4], address[5]];
}

-(void)setAddressFromString:(NSString*)addressString {
  
  // support both : and - or NOTHING as separator
  addressString = [addressString stringByReplacingOccurrencesOfString:@":" withString:@""];
  addressString = [addressString stringByReplacingOccurrencesOfString:@"-" withString:@""];
  if ([addressString length] != 12) return;
  
  unsigned int bd_addr_buffer[BD_ADDR_LEN];  //for sscanf, integer needed
  // reset result buffer
  int i;
  for (i = 0; i < BD_ADDR_LEN; i++) {
    bd_addr_buffer[i] = 0;
  }
  
  // parse
  int result = sscanf([addressString UTF8String], "%2x%2x%2x%2x%2x%2x", &bd_addr_buffer[0], &bd_addr_buffer[1], &bd_addr_buffer[2],
                      &bd_addr_buffer[3], &bd_addr_buffer[4], &bd_addr_buffer[5]);
  // store
  if (result == 6){
    for (i = 0; i < BD_ADDR_LEN; i++) {
      address[i] = (uint8_t) bd_addr_buffer[i];
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

-(void) btstackManager:(MKBTStackManager*) manager
  handlePacketWithType:(uint8_t) packet_type
            forChannel:(uint16_t) channel
               andData:(uint8_t *)packet
               withLen:(uint16_t) size {
  bd_addr_t event_addr;
  
	switch (packet_type) {
			
		case RFCOMM_DATA_PACKET:
			DLog(@"Received RFCOMM data on channel id %u, size %u", channel, size);
			hexdump(packet, size);
      [self btReadData:packet withLen:size];
			break;
			
		case HCI_EVENT_PACKET:
			switch (packet[0]) {
					
				case BTSTACK_EVENT_POWERON_FAILED:
					// handle HCI init failure
					DLog(@"HCI Init failed - make sure you have turned off Bluetooth in the System Settings");
          [self didDisconnectWithError:-1];
					break;		
					
				case BTSTACK_EVENT_STATE:
					// bt stack activated, get started
          if (packet[2] == HCI_STATE_WORKING) {
            DLog(@"BTStack is activated, start RFCOMM connection");
						bt_send_cmd(&rfcomm_create_channel, address, 1);
					}
					break;
					
				case HCI_EVENT_PIN_CODE_REQUEST:
					// inform about pin code request
					DLog(@"Using PIN 0000");
					bt_flip_addr(event_addr, &packet[2]); 
					bt_send_cmd(&hci_pin_code_request_reply, &event_addr, 4, "0000");
					break;
          
				case RFCOMM_EVENT_OPEN_CHANNEL_COMPLETE:
					// data: event(8), len(8), status (8), address (48), server channel(8), rfcomm_cid(16), max frame size(16)
					if (packet[2]) {
						DLog(@"RFCOMM channel open failed, status %u", packet[2]);
            [self didDisconnectWithError:packet[2]];
					} else {
						rfcomm_channel_id = READ_BT_16(packet, 10);
						int16_t mtu = READ_BT_16(packet, 12);
						DLog(@"RFCOMM channel open succeeded. New RFCOMM Channel ID %u, max frame size %u", rfcomm_channel_id, mtu);
            [self didConnect];
					}
					break;
					
				case HCI_EVENT_DISCONNECTION_COMPLETE:
					// connection closed -> quit test app
					DLog(@"Basebank connection closed");
          [self didDisconnect];
					break;
					
				default:
					break;
			}
			break;
		default:
			break;
	}
}


@end
