//
//  Global.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "Global.h"
#import <BuiltIO/BuiltIO.h> // TODO TAKE THIS OUT OF PRODUCTION
#import "FLAnimatedImage.h"

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

+ (void)addAnimatingLoaderToView:(UIView *)aView
{
    FLAnimatedImage *sun_gif = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beam1" ofType:@"gif"]]];
    FLAnimatedImageView *sun_image_view = [[FLAnimatedImageView alloc] init];
    sun_image_view.animatedImage = sun_gif;
    sun_image_view.frame = CGRectMake(0.0, 0.0, aView.frame.size.width, aView.frame.size.height);
    sun_image_view.tag = 42;
    [aView addSubview:sun_image_view];
}

+ (void)removeAnimatingLoaderFromViewWithExplosion:(UIView *)aView
{
    FLAnimatedImage *sun_explode_gif = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beam2" ofType:@"gif"]]];
    
    FLAnimatedImageView *animated = (FLAnimatedImageView *)[aView viewWithTag:42];
    animated.animatedImage = sun_explode_gif;
    
    double delayInSeconds = .9; // number of seconds to wait
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [animated removeFromSuperview];
    });
}

+ (void)removeAnimatingLoaderFromView:(UIView *)aView
{
    FLAnimatedImageView *animated = (FLAnimatedImageView *)[aView viewWithTag:42];
    [animated removeFromSuperview];
}

@end

