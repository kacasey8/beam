//
//  Global.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "Global.h"

@implementation Global

static Global *globalClass = nil;
NSString *kBuiltUserUID = @"builtUserUID";
NSString *kChallengeObject = @"challengeObject";
NSString *kChallengeCompleted = @"challengeCompleted";
NSString *kChallengeDate = @"challengeDate";
NSString *kUsersChallengesUID = @"usersChallengesUID";

+ (Global *)globalClass
{
    if (globalClass == NULL)
    {
        // Thread safe allocation and initialization -> singletone object
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ globalClass = [[Global alloc] init]; });
    }
    return globalClass;
}

- (BOOL)setValue:(id)val forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
    return YES;
}

- (id)getValueforKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
