//
//  ChallengeViewController.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeViewController.h"
#import <BuiltIO/BuiltIO.h>
#import "Global.h"

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

NSMutableDictionary *challenge;
NSString *usersChallengesDailyUID;
NSString *dateQueried;
bool dailyCompleted;
NSDateFormatter *dateFormatter;
Global *globalKeyValueStore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; // add zzz at end to use local time zone.
    // currently just dropping time zone, just looking for date to match up.
    
    globalKeyValueStore = [Global globalClass];
    
    [self loadCacheFromPersistantStorage];
    
    if ([self shouldUseCache]) {
        NSLog(@"using cache");
        [self setUpInformationForChallenge];
        if (dailyCompleted) {
            [self setUpCompletedForDailyChallenge];
        } else {
            [self setUpNotCompletedForDailyChallenge];
        }
    } else {
        [self getDailyChallenge];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Persistant Storage

- (void)saveCacheToPersistantStorage
{
    [globalKeyValueStore setValue:challenge forKey:kChallengeObject];
    [globalKeyValueStore setValue:[NSNumber numberWithBool:dailyCompleted] forKey:kChallengeCompleted];
    [globalKeyValueStore setValue:usersChallengesDailyUID forKey:kUsersChallengesUID];
    
    [globalKeyValueStore setValue:dateQueried forKey:kChallengeDate];
}

- (void)loadCacheFromPersistantStorage
{
    dateQueried = [globalKeyValueStore getValueforKey:kChallengeDate];
    if (![self shouldUseCache]) {
        // Date doesn't line up. No point in querying anything else
        return;
    }
    
    challenge = [globalKeyValueStore getValueforKey:kChallengeObject];
    dailyCompleted = [[globalKeyValueStore getValueforKey:kChallengeCompleted] boolValue];
    usersChallengesDailyUID = [globalKeyValueStore getValueforKey:kUsersChallengesUID];
}

- (BOOL) shouldUseCache
{
    return [dateQueried isEqualToString:[dateFormatter stringFromDate:[self beginningOfDay:[NSDate date]]]];
}

#pragma mark - Daily Challenge

- (void)setUpInformationForChallenge
{
    _challengeInformation.text = [challenge objectForKey:@"information"];
}

- (void)getDailyChallenge
{
    BuiltQuery *test1 = [BuiltQuery queryWithClassUID:@"challenge"];
    [test1              whereKey:@"date"
               lessThanOrEqualTo:[dateFormatter stringFromDate:[self endOfDay:[NSDate date]]]];
    BuiltQuery *test2 = [BuiltQuery queryWithClassUID:@"challenge"];
    [test2                  whereKey:@"date"
                greaterThanOrEqualTo:[dateFormatter stringFromDate:[self beginningOfDay:[NSDate date]]]];
    
    // Set date queried to be stored to persistent storage later
    dateQueried = [dateFormatter stringFromDate:[self beginningOfDay:[NSDate date]]];
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"challenge"];
    [query andWithSubqueries:@[test1,test2]];
    // this is kind of stupid. According to the docs you can put both less than
    // and greater than on a single query, but doesn't seem to work.
    // I've constructed both individually for now and 'and' them together
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"date", @"information", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *results = [result getResult];
        if ([results count] == 0) {
            NSLog(@"NO DAILY CHALLENGE!");
        } else {
            BuiltObject *tmp = [results objectAtIndex:0];
            challenge = [NSMutableDictionary dictionary];
            
            NSArray *keysToTransfer = @[@"uid", @"information"];
            
            for (NSString *s in keysToTransfer) {
                NSString *hi = [tmp objectForKey:s];
                [challenge setValue:hi forKey:s];
            }
                                        
            NSLog(@"%@", challenge);
            [self setUpInformationForChallenge];
            [self setUpIsDailyChallengeCompleted];
        }
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

- (NSDate *)beginningOfDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:date];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfDay:(NSDate *)givenDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    
    NSDate *date = [calendar dateByAddingComponents:components
                                             toDate:[self beginningOfDay:givenDate]
                                            options:0];
    
    date = [date dateByAddingTimeInterval:-1];
    
    return date;
}

- (void)setUpIsDailyChallengeCompleted
{
    if ([challenge objectForKey:@"uid"]) {
        BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
        [query whereKey:@"user" equalTo:[globalKeyValueStore getValueforKey:kBuiltUserUID]];
        [query whereKey:@"challenge" equalTo:[challenge objectForKey:@"uid"]];
        
        [query exec:^(QueryResult *result, ResponseType type) {
            // the query has executed successfully.
            // [result getResult] will contain a list of objects that satisfy the conditions
            
            NSArray *builtResults = [result getResult];
            if ([builtResults count] == 0) {
                [self setUpNotCompletedForDailyChallenge];
            } else {
                [self setUpCompletedForDailyChallenge];
                usersChallengesDailyUID = [[builtResults objectAtIndex:0] objectForKey:@"uid"];
            }
        } onError:^(NSError *error, ResponseType type) {
            // query execution failed.
            // error.userinfo contains more details regarding the same
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    }
}

- (void)setUpNotCompletedForDailyChallenge
{
    _challengeCompleted.text = @"NO!";
    dailyCompleted = false;
    
    [self saveCacheToPersistantStorage];
}

- (void)setUpCompletedForDailyChallenge
{
    _challengeCompleted.text = @"YES!";
    dailyCompleted = true;
    
    [self saveCacheToPersistantStorage];
}

#pragma mark - All Challenge Helper

- (void)getAllChallengesIHaveCompleted
{
    BuiltQuery *select_query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
    [select_query whereKey:@"user" equalTo:[globalKeyValueStore getValueforKey:kBuiltUserUID]];
    
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

- (IBAction)toggleDailyChallenge:(id)sender {
    if (dailyCompleted) {
        [self setUpNotCompletedForDailyChallenge];
        BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
        
        [obj setUid:usersChallengesDailyUID];
        
        [obj destroyOnSuccess:^{
            // object is deleted
            NSLog(@"Built updated challenge not completed");
        } onError:^(NSError *error) {
            // there was an error in deleting the object
            // error.userinfo contains more details regarding the same
            [self setUpCompletedForDailyChallenge]; // It failed. revert local state.
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    } else {
        [self setUpCompletedForDailyChallenge];
        BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
        [obj setReference:[globalKeyValueStore getValueforKey:kBuiltUserUID]
                   forKey:@"user"];
        [obj setReference:[challenge objectForKey:@"uid"]
                   forKey:@"challenge"];
        [obj saveOnSuccess:^{
            // object is created successfully
            NSLog(@"Built updated challenge completed");
            usersChallengesDailyUID = obj.uid;
        } onError:^(NSError *error) {
            // there was an error in creating the object
            // error.userinfo contains more details regarding the same
            [self setUpNotCompletedForDailyChallenge]; // it failed. revert local state.
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    }
}
@end
