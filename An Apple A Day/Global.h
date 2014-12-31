//
//  Global.h
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Global : NSObject

extern NSString *kBuiltUserUID;
extern NSString *kChallengeObject;
extern NSString *kChallengeCompleted;
extern NSString *kChallengeDate;
extern NSString *kUsersChallengesUID;

+ (Global *)globalClass;

- (BOOL)setValue:(id)val forKey:(NSString *)key;

- (id)getValueforKey:(NSString *)key;

-(void)deleteAllUsersChallenges; // TODO TAKE THIS OUT OF PRODUCTION

+ (void)addAnimatingLoaderToView:(UIView *)view;
+ (void)removeAnimatingLoaderFromView:(UIView *)aView;
+ (void)removeAnimatingLoaderFromViewWithExplosion:(UIView *)aView;

@end
