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

#import "NSData+MKCommandEncode.h"

/////////////////////////////////////////////////////////////////////////////////
#pragma mark Helper funktions

static NSData *encode64(NSData *inData) {
  unsigned int dstIdx = 0;
  unsigned int srcIdx = 0;

  const unsigned char *inBuffer = [inData bytes];
  unsigned int length = [inData length];

  unsigned char a, b, c;

  int outDataLength = (length * 4) / 3;

  if (outDataLength % 4)
    outDataLength += 4 - (outDataLength % 4);

  NSMutableData *outData = [NSMutableData dataWithLength:outDataLength];


  char *outBuffer = [outData mutableBytes];

  while (length > 0) {
    if (length) {
      a = inBuffer[srcIdx++];
      length--;
    } else a = 0;
    if (length) {
      b = inBuffer[srcIdx++];
      length--;
    } else b = 0;
    if (length) {
      c = inBuffer[srcIdx++];
      length--;
    } else c = 0;

    outBuffer[dstIdx++] = '=' + (a >> 2);
    outBuffer[dstIdx++] = '=' + (((a & 0x03) << 4) | ((b & 0xf0) >> 4));
    outBuffer[dstIdx++] = '=' + (((b & 0x0f) << 2) | ((c & 0xc0) >> 6));
    outBuffer[dstIdx++] = '=' + (c & 0x3f);
  }

  [outData setLength:dstIdx];

  return outData;
}

// ///////////////////////////////////////////////////////////////////////////////

@implementation NSData (MKCommandEncode)

- (NSData *)dataWithCommand:(MKCommandId)aCommand forAddress:(IKMkAddress)aAddress; {
  NSMutableData *frameData = [NSMutableData dataWithLength:3];

  char *frameBytes = [frameData mutableBytes];
  frameBytes[0] = '#';
  frameBytes[1] = 'a' + aAddress;
  frameBytes[2] = aCommand;

  [frameData appendData:encode64(self)];

  NSUInteger frameLength = [frameData length];
  frameBytes = [frameData mutableBytes];

  int crc = 0;
  for (int i = 0; i < frameLength; i++) {
    crc += frameBytes[i];
  }

  crc %= 4096;

  char tmpCrc1 = '=' + (crc / 64);
  char tmpCrc2 = ('=' + crc % 64);

  [frameData appendBytes:&tmpCrc1 length:1];
  [frameData appendBytes:&tmpCrc2 length:1];
  [frameData appendBytes:"\r" length:1];

  return frameData;
}

+ (NSData *)dataWithCommand:(MKCommandId)aCommand forAddress:(IKMkAddress)aAddress payloadForByte:(uint8_t)byte {
  NSData *payload = [NSData dataWithBytes:&byte length:1];
  return [payload dataWithCommand:aCommand forAddress:aAddress];
}

+ (NSData *)dataWithCommand:(MKCommandId)aCommand
                 forAddress:(IKMkAddress)aAddress
           payloadWithBytes:(const void *)bytes
                     length:(NSUInteger)length {
  NSData *payload = [NSData dataWithBytes:bytes length:length];
  return [payload dataWithCommand:aCommand forAddress:aAddress];
}

@end
