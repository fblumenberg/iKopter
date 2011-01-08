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

#import "NSData+MKCommandDecode.h"

#define kInvalidMKCommand @"Invalid MK command"

// ///////////////////////////////////////////////////////////////////////////////
#pragma mark Helper funktions

static NSData * decode64(const char * inBuffer, int length)
{
  unsigned char a, b, c, d;
  unsigned char x, y, z;
  
  int srcIdx = 0;
  int dstIdx = 0;
  
  NSMutableData * outData = [NSMutableData dataWithLength:length];
  unsigned char * outBuffer = [outData mutableBytes];
  
  if (inBuffer[srcIdx] != 0) 
  {
    while (length != 0) 
    {
      a = inBuffer[srcIdx++] - '=';
      b = inBuffer[srcIdx++] - '=';
      c = inBuffer[srcIdx++] - '=';
      d = inBuffer[srcIdx++] - '=';
      
      x = (a << 2) | (b >> 4);
      y = ((b & 0x0f) << 4) | (c >> 2);
      z = ((c & 0x03) << 6) | d;
      
      if (length--) outBuffer[dstIdx++] = x; else break;
      if (length--) outBuffer[dstIdx++] = y; else break;
      if (length--) outBuffer[dstIdx++] = z; else break;
    }
  }
  
  [outData setLength:dstIdx];
  return outData;
}

// ///////////////////////////////////////////////////////////////////////////////
@implementation NSData (MKCommandDecode)

- (NSUInteger) frameLength;
{
  NSUInteger frameLength =  [self length];
  const char * frameBytes = [self bytes];
  
  if (frameLength > 0 && frameBytes[frameLength - 1] == '\r')
    frameLength--;
  
  return frameLength;
}


- (BOOL) isMkData 
{
  NSUInteger frameLength =  [self frameLength];
  const char * frameBytes = [self bytes];
  
  if ( frameLength < 5) 
  {
    NSLog(@"The frame length is to short %d. Frame is invalid", frameLength);
    return NO;
  }
  
  if (frameBytes[0] != '#') 
  {
    NSLog(@"The frame is no MK frame");
    return NO;
  }
  
  return YES;
}


- (BOOL) isCrcOk 
{
  
  if (![self isMkData])
    return NO;
  
  NSUInteger frameLength =  [self frameLength];
  const uint8_t * frameBytes = [self bytes];
  
  uint8_t crc2 = frameBytes[frameLength - 1];
  uint8_t crc1 = frameBytes[frameLength - 2];
  
  int crc = 0;
  for (int i = 0; i < frameLength - 2; i++) 
  {
    crc += frameBytes[i];
  }
  
  crc %= 4096;
  
  if (crc1 == ('=' + (crc / 64)) && crc2 == ('=' + crc % 64))
    return YES;
  
  return NO;
}

- (IKMkAddress) address 
{
  if (![self isCrcOk])
    [NSException raise:kInvalidMKCommand format:@"cannot get the address from a invalid MK frame"];
  
  const char * frameBytes = [self bytes];
  
  return (IKMkAddress)(frameBytes[1] - 'a');
}

- (MKCommandId) command 
{
  if (![self isCrcOk])
    [NSException raise:kInvalidMKCommand format:@"cannot get the address from a invalid MK frame"];
  
  const char * frameBytes = [self bytes];
  return frameBytes[2];
}


- (NSData *) payload;
{
  NSUInteger frameLength =  [self frameLength];
  const char * frameBytes = [self bytes];
  
  int startIndex = 3;
  int frameDataLength = frameLength - startIndex - 2;
  
  return decode64(frameBytes + startIndex, frameDataLength);
}


@end
