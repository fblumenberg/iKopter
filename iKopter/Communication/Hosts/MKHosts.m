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

#import "MKHosts.h"
#import "MKHost.h"

#import "TTGlobalCorePaths.h"
#import "TTCorePreprocessorMacros.h"

@interface MKHosts (Private)
-(void) load;
-(void) save;
@end

@implementation MKHosts

- (id) init
{
  self = [super init];
  if (self != nil) {
    [self load];
    
    if(!hosts) {
      hosts = [[NSMutableArray alloc]init];
      
      MKHost* h;

      h = [[MKHost alloc]init];
      h.name = @"Quadkopter Serial";
      h.address = @"/dev/tty.iap";
      h.connectionClass = @"MKSerialConnection";
      [hosts addObject:h];
      [h release];
      
      h = [[MKHost alloc]init];
      h.name = @"Quadkopter Fake";
      h.address = @"Dummy";
      h.connectionClass = @"MKFakeConnection";
      [hosts addObject:h];
      [h release];
#ifdef DEBUG      
      h = [[MKHost alloc]init];
      h.name = @"Quadkopter WLAN";
      h.address = @"192.168.0.74:23";
      h.connectionClass = @"MKIpConnection";
      [hosts addObject:h];
      [h release];
      
      h = [[MKHost alloc]init];
      h.name = @"Serproxy";
      h.address = @"127.0.0.1:64400";
      h.connectionClass = @"MKIpConnection";
      [hosts addObject:h];
      [h release];

      h = [[MKHost alloc]init];
      h.name = @"Quadkopter MK-BT";
      h.address = @"00:0b:ce:04:ce:e3";
      h.connectionClass = @"MKBluetoothConnection";
      [hosts addObject:h];
      [h release];

      h = [[MKHost alloc]init];
      h.name = @"Quadkopter Serial MKUSB";
      h.address = @"/dev/cu.usbserial-A2002Qzh";
      h.connectionClass = @"MKSerialConnection";
      [hosts addObject:h];
      [h release];

      h = [[MKHost alloc]init];
      h.name = @"Quadkopter Serial MKUSB";
      h.address = @"/dev/cu.MikroKopter_BT-SerialPo";
      h.connectionClass = @"MKSerialConnection";
      [hosts addObject:h];
      [h release];
#endif
      
      [self save];
    }
  }
  return self;
}

- (void) dealloc
{
  [hosts release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#define kFilename        @"mkhosts"
#define kDataKey         @"Data"

-(void) load {
  
  NSString *filePath = TTPathForDocumentsResource(kFilename);
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    
    qlinfo(@"Load the hosts from %@",filePath);
    
    NSData *data = [[NSMutableData alloc]
                    initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    TT_RELEASE_SAFELY(hosts);
    hosts = [unarchiver decodeObjectForKey:kDataKey];
    [hosts retain];
    
    [unarchiver finishDecoding];
    
    [unarchiver release];
    [data release];        

    qldebug(@"Loaded the hosts %@",hosts);

  }
}

-(void) save {

  qldebug(@"Save the hosts %@",hosts);
  
  NSString *filePath = TTPathForDocumentsResource(kFilename);
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

  [archiver encodeObject:hosts forKey:kDataKey];
  [archiver finishEncoding];
  if(![data writeToFile:filePath atomically:YES]){
    qlerror(@"Failed to save the host data to %@",filePath);
  }

  [archiver release];
  [data release];    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSUInteger) count {
  return [hosts count];
}

-(MKHost*) hostAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger row = [indexPath row];
  return [hosts objectAtIndex:row];
}

-(NSIndexPath*) addHost {
  MKHost* h = [[MKHost alloc]init];
  h.connectionClass = @"MKFakeConnection";
  [hosts addObject:h];
  [h release];

  [self save];
  return [NSIndexPath indexPathForRow:[hosts count]-1 inSection:0]; 
}

-(void) moveHostAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  qltrace(@"moveHostAtIndexPath %@ -> %@",fromIndexPath,toIndexPath);
  qltrace(@"%@",hosts);

  NSUInteger fromRow = [fromIndexPath row];
  NSUInteger toRow = [toIndexPath row];
  
  id object = [[hosts objectAtIndex:fromRow] retain]; 
  [hosts removeObjectAtIndex:fromRow]; 
  [hosts insertObject:object atIndex:toRow]; 
  [object release];
    
  qltrace(@"%@",hosts);
  [self save];
}

-(void) deleteHostAtIndexPath:(NSIndexPath*)indexPath {
  [hosts removeObjectAtIndex:[indexPath row]]; 
  [self save];
}

@end

