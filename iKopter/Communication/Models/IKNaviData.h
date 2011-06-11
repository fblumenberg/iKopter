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

#import <Foundation/Foundation.h>

#import "IKMkDataTypes.h"

@interface IKNaviData : NSObject {

  IKMkNaviData _data;
}

@property(assign,readonly) IKMkNaviData* data;

+ (id)data;
+ (id)dataWithData:(NSData *)data;
- (id)initWithData:(NSData*)data;

@end


@interface IKGPSPos : NSObject<NSCoding> {
  
}

@property(assign) NSInteger  longitude;      // in 1E-7 deg
@property(assign) NSInteger  latitude;       // in 1E-7 deg
@property(assign) NSUInteger altitude;       // in mm
@property(assign) NSInteger  status;         // validity of data

+ (id)positionWithMkPos:(IKMkGPSPos *)pos;
- (id)initWithMkPos:(IKMkGPSPos*)pos;

@end

@interface IKGPSPosDev : NSObject<NSCoding> {
  
}

@property(assign) NSUInteger distance;       // in mm
@property(assign) NSInteger  bearing;         // validity of data

+ (id)positionWithMkPosDev:(IKMkGPSPosDev *)pos;
- (id)initWithMkPosDev:(IKMkGPSPosDev*)pos;

@end

