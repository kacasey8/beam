//
//  Global.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "Global.h"
#import <BuiltIO/BuiltIO.h> // TODO TAKE THIS OUT OF PRODUCTION

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

- (void)deleteAllUsersChallenges
{
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        NSArray *builtResults = [result getResult];
        for (int i = 0; i < [builtResults count]; i++) {
             NSDictionary *result = [builtResults objectAtIndex:i];
             BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
             
             [obj setUid:[result objectForKey:@"uid"]];
             
             NSLog(@"%d", i);
             
             [obj destroyOnSuccess:^{
                 // object is deleted
                 NSLog(@"%d", i);
                } onError:^(NSError *error) {
                    // there was an error in deleting the object
                    // error.userinfo contains more details regarding the same
                    NSLog(@"%@", error.userInfo);
             }];
        }
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
    
}

@end

