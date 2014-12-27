//
//  ChallengeViewController.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeViewController.h"
#import "CompleteChallengeViewController.h"

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

NSString *dateQueried;
bool dailyCompleted;
NSDateFormatter *dateFormatter;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // using ISODate format so it will sort properly
    
    _globalKeyValueStore = [Global globalClass];
    _completedDescription.hidden = YES;
    _completedImageView.hidden = YES;
    
    [self getDailyChallenge];
    
    /*[self loadCacheFromPersistantStorage];
    
    if ([self shouldUseCache]) {
        NSLog(@"using cache");
        [self setUpInformationForChallenge];
        if (dailyCompleted) {
            
        }
    }*/
}

- (void)activateView
{
    if (![self shouldUseCache]) {
        NSLog(@"Querying server for challenge");
        [self queryCompletedDailyChallenge];
    } else {
        NSLog(@"Querying server for challenge");
        [self queryCompletedDailyChallenge];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Persistant Storage

- (void)saveCacheToPersistantStorage
{
    [_globalKeyValueStore setValue:_challenge forKey:kChallengeObject];
    [_globalKeyValueStore setValue:dateQueried forKey:kChallengeDate];
    [_globalKeyValueStore setValue:[NSNumber numberWithBool:dailyCompleted] forKey:kChallengeCompleted];
}

- (void)loadCacheFromPersistantStorage
{
    dateQueried = [_globalKeyValueStore getValueforKey:kChallengeDate];
    if (![self shouldUseCache]) {
        // Date doesn't line up. No point in querying anything else
        return;
    }
    
    _challenge = [_globalKeyValueStore getValueforKey:kChallengeObject];
    dailyCompleted = [[_globalKeyValueStore getValueforKey:kChallengeCompleted] boolValue];
}

- (BOOL) shouldUseCache
{
    return [dateQueried isEqualToString:[dateFormatter stringFromDate:[NSDate date]]];
}

#pragma mark - Daily Challenge

- (void)getDailyChallenge
{
    // Set date queried to be stored to persistent storage later
    dateQueried = [dateFormatter stringFromDate:[NSDate date]];
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"challenge"];
    [query whereKey:@"date" equalTo:dateQueried];
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"date", @"information", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *results = [result getResult];
        if ([results count] == 0) {
            NSLog(@"NO DAILY CHALLENGE!");
        } else {
            BuiltObject *tmp = [results objectAtIndex:0];
            _challenge = [NSMutableDictionary dictionary];
            
            // I'm transferring it to a mutable dictionary so it can be saved to persistent storage on device
            
            NSArray *keysToTransfer = @[@"uid", @"information"];
            
            for (NSString *s in keysToTransfer) {
                NSString *hi = [tmp objectForKey:s];
                [_challenge setValue:hi forKey:s];
            }
                                        
            NSLog(@"%@", _challenge);
            [self setUpInformationForChallenge];
            [self queryCompletedDailyChallenge];
        }
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

- (void)setUpInformationForChallenge
{
    _challengeInformation.text = [_challenge objectForKey:@"information"];
}

- (void)queryCompletedDailyChallenge
{
    if ([_challenge objectForKey:@"uid"] && [_globalKeyValueStore getValueforKey:kBuiltUserUID]) {
        BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
        [query whereKey:@"user" equalTo:[_globalKeyValueStore getValueforKey:kBuiltUserUID]];
        [query whereKey:@"challenge" equalTo:[_challenge objectForKey:@"uid"]];
        
        [query exec:^(QueryResult *result, ResponseType type) {
            // the query has executed successfully.
            // [result getResult] will contain a list of objects that satisfy the conditions
            NSArray *builtResults = [result getResult];
            
            if ([builtResults count] == 0) {
                NSLog(@"not completed");
                dailyCompleted = false;
            } else {
                NSLog(@"completed");
                dailyCompleted = true;
                NSDictionary *builtResult = [builtResults objectAtIndex:0];
                NSLog(@"%@", builtResult);
                
                _challengePost = [[NSMutableDictionary alloc] init];
                NSString *text = [builtResult objectForKey:@"comment"];
                NSString *imageUrl = [[[builtResult objectForKey:@"files"] objectAtIndex:0] objectForKey:@"url"];
                NSString *uid = [builtResult objectForKey:@"uid"];
                
                NSURL *url = [NSURL URLWithString:imageUrl];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [[UIImage alloc] initWithData:data];
                
                [_challengePost setObject:text forKey:@"comment"];
                [_challengePost setObject:img forKey:@"image"];
                [_challengePost setObject:uid forKey:@"uid"];
                
                [self updateCompletedDailyChallengeWithProperties:_challengePost];
                
                /* uncomment to clear the user challenges
                for (int i = 0; i < [builtResults count]; i++) {
                    NSDictionary *result = [builtResults objectAtIndex:i];
                    BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
                    
                    [obj setUid:[result objectForKey:@"uid"]];
                    
                    [obj destroyOnSuccess:^{
                        // object is deleted
                        NSLog(@"%d", i);
                    } onError:^(NSError *error) {
                        // there was an error in deleting the object
                        // error.userinfo contains more details regarding the same
                        NSLog(@"%@", error.userInfo);
                    }];
                }*/
            }
            [self saveCacheToPersistantStorage];
        } onError:^(NSError *error, ResponseType type) {
            // query execution failed.
            // error.userinfo contains more details regarding the same
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    }
}

- (void)updateCompletedDailyChallengeWithProperties:(NSMutableDictionary *)properties {
    NSString *comment = [properties objectForKey:@"comment"];
    if (comment) {
        _completedDescription.text = comment;
        _completedDescription.hidden = NO;
        [_completeButton setTitle:@"Update" forState:UIControlStateNormal];
    }

    UIImage *image = [properties objectForKey:@"image"];
    if (image) {
        _completedImageView.image = image;
        _completedImageView.hidden = NO;
        _completedImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

#pragma mark - All Challenge Helper

- (void)getAllChallengesIHaveCompleted
{
    BuiltQuery *select_query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
    [select_query whereKey:@"user" equalTo:[_globalKeyValueStore getValueforKey:kBuiltUserUID]];
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"challenge"];
    [query whereKey:@"uid" equalToResultOfSelectQuery:select_query forKey:@"challenge"];
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"date", @"information", nil]];
    [query includeCount];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *builtResult = [result getResult];
        
        NSLog(@"%@", builtResult);
        
        int challengesCompelted = [builtResult count];
        NSLog(@"Challenges completed = %d", challengesCompelted);
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    // Close the session and remove the access token from the cache
    // The session state handler (in the app delegate) will be called automatically
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)promptCompleteChallenge:(id)sender {
    CompleteChallengeViewController *vc = [[CompleteChallengeViewController alloc] init];

    vc.presenter = self;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
