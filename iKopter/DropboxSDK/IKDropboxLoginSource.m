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

#import <IBAForms/IBAForms.h>
#import "IKDropboxLoginSource.h"
#import "SettingsButtonStyle.h"
#import "SettingsFieldStyle.h"


@implementation IKDropboxLoginData

@synthesize email;
@synthesize password;

@end

@interface IKDropboxLoginSource()


-(void)showDiscoveryView;

          
@end

@implementation IKDropboxLoginSource

@synthesize loginButton;
@synthesize passwordField;
@synthesize emailField;
@synthesize delegate;

- (id)initWithModel:(id)aModel {
	if ((self = [super initWithModel:aModel])) {

    NSError *error = NULL;
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    _emailRegexp = [[NSRegularExpression regularExpressionWithPattern:emailRegEx
                                                              options:0
                                                                error:&error] retain];
    
    userDataValid = NO;

    //------------------------------------------------------------------------------------------------------------------------
		IBAFormSection *userDataSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    userDataSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    
    //------------------------------------------------------------------------------------------------------------------------
    self.emailField = [[[IBATextFormField alloc] initWithKeyPath:@"email" title:NSLocalizedString(@"Email",@"DB Login Email")] autorelease];
    [userDataSection addFormField:self.emailField];
    self.emailField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.textFormFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.textFormFieldCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.textFormFieldCell.textField.placeholder = NSLocalizedString(@"example@gmail.com",@"DB Login Email placeholder");
    

    self.passwordField = [[[IBAPasswordFormField alloc] initWithKeyPath:@"password" title:NSLocalizedString(@"Password",@"DB Login Password")] autorelease];
    [userDataSection addFormField:self.passwordField];
    self.passwordField.textFormFieldCell.textField.placeholder = NSLocalizedString(@"Required",@"DB Login Password placeholder");
    self.passwordField.textFormFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.textFormFieldCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
		IBAFormSection *buttonSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];

    buttonSection.formFieldStyle = [[[SettingsButtonStyleDisabled alloc] init] autorelease];
		
    self.loginButton=[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Log in to Dropbox",@"DB Login Button")
                                                           icon:nil
                                                 executionBlock:^{
                                                   [self showDiscoveryView];
                                                 }] autorelease];
		[buttonSection addFormField:self.loginButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
  }
  return self;
}

- (void)dealloc {

  [_emailRegexp release];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.loginButton=nil;
  self.passwordField=nil;
  self.emailField=nil;
  [super dealloc];
}

- (BOOL) isUserDataValid{
  BOOL emailValid=NO;
  
  NSString* email=self.emailField.textFormFieldCell.textField.text;
  if(email){
    NSRange range = [_emailRegexp rangeOfFirstMatchInString:email options:NSMatchingCompleted range:NSMakeRange(0, [email length])];
    emailValid=!NSEqualRanges(range, NSMakeRange(NSNotFound, 0));
  }
  
  NSString* password=self.passwordField.textFormFieldCell.textField.text;
  
  BOOL passwordValid=[password length]>0;
  
  return emailValid && passwordValid;
}

- (void) setLoginButtonStyle{
  
  BOOL valid=[self isUserDataValid];
  if(valid!=userDataValid){
    self.loginButton.formFieldStyle = valid?[[[SettingsButtonStyle alloc] init] autorelease]:[[[SettingsButtonStyleDisabled alloc] init] autorelease];
    qltrace(@"Data valid %d",valid);
    userDataValid=valid;
    [self.loginButton.cell applyFormFieldStyle];
  }
}

- (void)textFieldChanged:(NSNotification *)note {
  [self setLoginButtonStyle];
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
  [self setLoginButtonStyle];
	qltrace(@"%@",[self.model description]);
}

-(void)showDiscoveryView{
  [[IBAInputManager sharedIBAInputManager] deactivateActiveInputRequestor];
  [self.delegate logInToDropbox:self];
}

@end
