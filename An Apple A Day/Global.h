//
//  Global.h
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

extern NSString *kBuiltUserUID;
extern NSString *kChallengeObject;
extern NSString *kChallengeCompleted;
extern NSString *kChallengeDate;
extern NSString *kUsersChallengesUID;

+ (Global *)globalClass;

- (BOOL)setValue:(id)val forKey:(NSString *)key;

- (id)getValueforKey:(NSString *)key;

@end
