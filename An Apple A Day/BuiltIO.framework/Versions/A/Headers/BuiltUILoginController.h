//
//  BuiltLoginViewController.h
//  builtDemo
//
//  Created by Reefaq on 10/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuiltUser;
@class BuiltSLGlowingTextField;
@class ACAccount;
@class BuiltACL;

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#ifndef NS_OPTIONS
#define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_OPTIONS(NSUInteger, BuiltLoginFields) {
    BuiltLoginFieldNone = 0,
    BuiltLoginFieldUsernameAndPassword = 1 << 0,
    BuiltLoginFieldLogin = 1 << 1,
    BuiltLoginFieldSignUp = 1 << 2,
    BuiltLoginFieldForgotPassword = 1 << 3,
    BuiltLoginFieldGoogle = 1 << 4,
    BuiltLoginFieldDismiss = 1 << 5,
    BuiltLoginFieldTwitter = 1<<6,
    BuiltLoginFieldDefault = BuiltLoginFieldUsernameAndPassword | BuiltLoginFieldForgotPassword | BuiltLoginFieldLogin | BuiltLoginFieldSignUp
};

/**---------------------------------------------------------------------------------------
 *  BuiltUILoginDelegate to notify login success and failure status.
 *  ---------------------------------------------------------------------------------------
 */
@protocol BuiltUILoginDelegate <NSObject>

/**
 @abstract Invoked when Login is successful.
 @param user Built User object of log in user.
 */
- (void)loginSuccessWithUser:(BuiltUser *)user;

/**
 @abstract Invoked when Login is failed.
 @param error NSError object with description of failure. 
 */
- (void)loginFailedWithError:(NSError *)error;

@optional
/**
 @abstract Invoked before Login call will begin.
 */
- (void)willBeginLogin;

/**
 @abstract Invoked when dismiss button is tapped.
 */
- (void)dismissTapped;

@end


/**---------------------------------------------------------------------------------------
 *  BuiltUIGoogleAppSettingDelegate to configure app with Google App ID/Secret key.
 *  ---------------------------------------------------------------------------------------
 */
@protocol BuiltUIGoogleAppSettingDelegate <NSObject>

/**
 @abstract ask for Google App Client ID to authenticate from Google if BuiltLoginFieldGoogle presents in fields.
 */
- (NSString*)googleAppClientID;

/**
 @abstract ask for Google App Client Secret to authenticate from Google if BuiltLoginFieldGoogle presents in fields.
 */
- (NSString*)googleAppClientSecret;

@end


/**---------------------------------------------------------------------------------------
 *  BuiltUITwitterAppSettingDelegate to configure app with Twitter consumer key and secret.
 *  ---------------------------------------------------------------------------------------
 */
@protocol BuiltUITwitterAppSettingDelegate <NSObject>
@required
/**
 @abstract ask for twitter consumer key to authenticate from Twitter if BuiltLoginFieldTwitter present in fields.
 */
- (NSString*)consumerKey;

/**
 @abstract ask for twitter consumer secret to authenticate from Twitter if BuiltLoginFieldTwitter present in fields.
 */
- (NSString*)consumerSecret;
@optional
/**
 @abstract if there is an error after a user hits the twitter button you can catch it here. e.g. if there are no twitter accounts existing.
 @param error error object describing the error
 */
- (void)didClickTwitterButton:(NSError *)error;

@end

/** Login View Controller */
@interface BuiltUILoginController : UIViewController

@property (nonatomic, assign) id<BuiltUILoginDelegate> delegate;
@property (nonatomic, assign) id<BuiltUIGoogleAppSettingDelegate> googleAppSettingDelegate;
@property (nonatomic, assign) id<BuiltUITwitterAppSettingDelegate> twitterAppSettingDelegate;

@property (nonatomic, strong) UILabel* signUpLabel;
@property (nonatomic, strong) UILabel* otherLoginLabel;

/**
 @abstract Specify the login fields which are to be displayed using this bitmask.
    BuiltLoginFieldNone = 0,
    BuiltLoginFieldUsernameAndPassword = 1 << 0,
    BuiltLoginFieldLogin = 1 << 1,
    BuiltLoginFieldSignUp = 1 << 2,
    BuiltLoginFieldForgotPassword = 1 << 3,
    BuiltLoginFieldGoogle = 1 << 4,
    BuiltLoginFieldDismiss = 1 << 5,
    BuiltLoginFieldTwitter = 1<<6,
    BuiltLoginFieldDefault = BuiltLoginFieldUsernameAndPassword | BuiltLoginFieldForgotPassword | BuiltLoginFieldLogin | BuiltLoginFieldSignUp
 */
@property (nonatomic, assign) BuiltLoginFields fields;

/**
 set this property to true if you want loading HUD to be displayed.
 */
@property (nonatomic, assign, getter = isHandlingLoadingHUD) BOOL shouldHandleLoadingHUD;

/**
 @abstract this is the logo for the app. The default logo is for built.io.
 */
@property (nonatomic, readonly) UIImageView* logoImageView;

/**
 @abstract username field
 */
@property (nonatomic, readonly) BuiltSLGlowingTextField* userNameField;

/**
 @abstract password field.
 */
@property (nonatomic, readonly) BuiltSLGlowingTextField* passwordField;

/**
 @abstract login button.
 */
@property (nonatomic, readonly) UIButton* loginButton;

/**
 @abstract login with google button.
 */
@property (nonatomic, readonly) UIButton* googleLoginButton;

/**
 @abstract
 */
@property (nonatomic, readonly) UIButton* tibbrLoginButton;

/**
 @abstract sign up button.
 */
@property (nonatomic, readonly) UIButton* signUpButton;

/**
 @abstract dismissButton.
 */
@property (nonatomic, readonly) UIButton* dismissButton;

/**
 @abstract ACL that will be set to the user signing up or logging in via google, twitter, facebook or tibbr.
 @param ACL The ACL for the object.
 */
- (void)setACL:(BuiltACL *)ACL;

@end
