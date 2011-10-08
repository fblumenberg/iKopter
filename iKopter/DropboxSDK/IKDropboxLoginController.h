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

#import <UIKit/UIKit.h>
#import <IBAForms/IBAFormViewController.h>

#import "IKDropboxLoginSource.h"

@class DBRestClient;

@protocol IKDBLoginControllerDelegate;

@interface IKDropboxLoginController : IBAFormViewController<IKDropboxLoginSourceDelegate> {
    
  BOOL shownModal;

  DBRestClient* restClient;
}

@property (nonatomic, assign) id<IKDBLoginControllerDelegate> delegate;

- (void)presentFromController:(UIViewController*)controller;

@end

// This controller tells the delegate whether the user sucessfully logged in or not
// The login controller will dismiss itself
@protocol IKDBLoginControllerDelegate

- (void)loginControllerDidLogin:(IKDropboxLoginController*)controller;
- (void)loginControllerDidCancel:(IKDropboxLoginController*)controller;

@end
