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
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; // add zzz at end to use local time zone.
    // currently just dropping time zone, just looking for date to match up.
    
    _globalKeyValueStore = [Global globalClass];
    
    [self loadCacheFromPersistantStorage];
    
    if ([self shouldUseCache]) {
        NSLog(@"using cache");
        [self setUpInformationForChallenge];
        if (dailyCompleted) {
            [self setUpCompletedForDailyChallenge];
        } else {
            [self setUpNotCompletedForDailyChallenge];
        }
    }
}

- (void)activateView
{
    if (![self shouldUseCache]) {
        NSLog(@"Querying server for challenge");
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
    [_globalKeyValueStore setValue:_challenge forKey:kChallengeObject];
    [_globalKeyValueStore setValue:[NSNumber numberWithBool:dailyCompleted] forKey:kChallengeCompleted];
    [_globalKeyValueStore setValue:_usersChallengesDailyUID forKey:kUsersChallengesUID];
    
    [_globalKeyValueStore setValue:dateQueried forKey:kChallengeDate];
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
    _usersChallengesDailyUID = [_globalKeyValueStore getValueforKey:kUsersChallengesUID];
}

- (BOOL) shouldUseCache
{
    return [dateQueried isEqualToString:[dateFormatter stringFromDate:[self beginningOfDay:[NSDate date]]]];
}

#pragma mark - Daily Challenge

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
            _challenge = [NSMutableDictionary dictionary];
            
            NSArray *keysToTransfer = @[@"uid", @"information"];
            
            for (NSString *s in keysToTransfer) {
                NSString *hi = [tmp objectForKey:s];
                [_challenge setValue:hi forKey:s];
            }
                                        
            NSLog(@"%@", _challenge);
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

- (void)setUpInformationForChallenge
{
    _challengeInformation.text = [_challenge objectForKey:@"information"];
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
    if ([_challenge objectForKey:@"uid"]) {
        while ([_globalKeyValueStore getValueforKey:kBuiltUserUID] == NULL) {
            // Needed to wait for the built login to execute before moving on.
            [NSThread sleepForTimeInterval:0.5];
        }
        BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
        [query whereKey:@"user" equalTo:[_globalKeyValueStore getValueforKey:kBuiltUserUID]];
        [query whereKey:@"challenge" equalTo:[_challenge objectForKey:@"uid"]];
        
        [query exec:^(QueryResult *result, ResponseType type) {
            // the query has executed successfully.
            // [result getResult] will contain a list of objects that satisfy the conditions
            
            NSArray *builtResults = [result getResult];
            if ([builtResults count] == 0) {
                [self setUpNotCompletedForDailyChallenge];
            } else {
                [self setUpCompletedForDailyChallenge];
                _usersChallengesDailyUID = [[builtResults objectAtIndex:0] objectForKey:@"uid"];
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

/*- (IBAction)toggleDailyChallenge:(id)sender {
    if (dailyCompleted) {
        [self setUpNotCompletedForDailyChallenge];
        BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
        
        [obj setUid:_usersChallengesDailyUID];
        
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
        [obj setReference:[_globalKeyValueStore getValueforKey:kBuiltUserUID]
                   forKey:@"user"];
        [obj setReference:[_challenge objectForKey:@"uid"]
                   forKey:@"challenge"];
        [obj saveOnSuccess:^{
            // object is created successfully
            NSLog(@"Built updated challenge completed");
            _usersChallengesDailyUID = obj.uid;
        } onError:^(NSError *error) {
            // there was an error in creating the object
            // error.userinfo contains more details regarding the same
            [self setUpNotCompletedForDailyChallenge]; // it failed. revert local state.
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    }
}*/
@end
