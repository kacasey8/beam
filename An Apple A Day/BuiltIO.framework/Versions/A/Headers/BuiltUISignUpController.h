//
//  BuiltUISignUpController.h
//  builtDemo
//
//  Created by Reefaq on 13/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuiltACL;

/** SignUp View Controller */
@interface BuiltUISignUpController : UIViewController

/**
 @abstract this is the logo for the app. The default logo is for built.io.
 */
@property (nonatomic, strong, readonly) UIImageView* logoImageView;

/**
 @abstract ACL that will be set to the user signing up.
 @param ACL The ACL for the object.
 */
- (void)setACL:(BuiltACL *)ACL;

@end
