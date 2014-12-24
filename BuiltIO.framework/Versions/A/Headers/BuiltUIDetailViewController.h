//
//  BuiltDetailViewController.h
//  builtDemo
//
//  Created by Reefaq on 10/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuiltObject;

/**---------------------------------------------------------------------------------------
 *  Sub-class of UIViewController with support of BuiltIO SDK
 *  ---------------------------------------------------------------------------------------
 */
@interface BuiltUIDetailViewController : UIViewController

/**
 @abstract Built-Class-UID of which object UID is set.
 */
@property (nonatomic, copy) NSString* classUID;

/**
 @abstract Built-Object-UID which need to be fetched.
 */
@property (nonatomic, copy) NSString* objectUID;

/**
 @abstract Built-Object which is fetched according to objectUID set.
 */
@property (nonatomic, readonly) BuiltObject *builtObject;

/**
 @abstract called before whenever a network request is initialed.
 */
- (void)networkWillStartLoad;

/**
 @abstract called after a network request is finished.
 @param error An Error if network call fails else nil.
 */
- (void)networkDidFinishLoad:(NSError *)error;

@end
