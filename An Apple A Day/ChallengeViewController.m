//
//  ChallengeViewController.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeViewController.h"
#import <BuiltIO/BuiltIO.h>

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

BuiltObject *challenge;
BuiltUser *user; // This should really be a global variable
NSString *userChallengeUID;
bool dailyCompleted;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUserInfo];
    [self getDailyChallenge];
}

- (void)getUserInfo
{
    user = [BuiltUser user];
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    
    [user loginWithFacebookAccessToken:fbAccessToken
                             onSuccess:^{
                                 // user has logged in successfully
                                 // user.authtoken contains the session authtoken
                                 NSLog(@"User synced");
                                 [self setUpDailyChallengeCompleted];
                                 [self getAllChallengesIHaveCompleted];
                             } onError:^(NSError *error) {
                                 // login failed
                                 // error.userinfo contains more details regarding the same
                                 NSLog(@"Facebook To Built Failed!!!");
                                 NSLog(@"%@", error.userInfo);
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Daily Challenge

- (void)setUpInformationForChallenge
{
    _challengeInformation.text = [challenge objectForKey:@"information"];
}

- (void)getDailyChallenge
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    BuiltQuery *test1 = [BuiltQuery queryWithClassUID:@"challenge"];
    [test1     whereKey:@"date"
               lessThanOrEqualTo:[dateFormatter stringFromDate:[self endOfDay:[NSDate date]]]];
    BuiltQuery *test2 = [BuiltQuery queryWithClassUID:@"challenge"];
    [test2     whereKey:@"date"
            greaterThanOrEqualTo:[dateFormatter stringFromDate:[self beginningOfDay:[NSDate date]]]];
    
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
            challenge = [results objectAtIndex:0];
            NSLog(@"%@", challenge);
            [self setUpInformationForChallenge];
            [self setUpDailyChallengeCompleted];
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

- (void)setUpDailyChallengeCompleted
{
    if (user.uid && challenge.uid) {
        BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
        [query whereKey:@"user" equalTo:user.uid];
        [query whereKey:@"challenge" equalTo:challenge.uid];
        
        [query exec:^(QueryResult *result, ResponseType type) {
            // the query has executed successfully.
            // [result getResult] will contain a list of objects that satisfy the conditions
            
            NSArray *builtResults = [result getResult];
            if ([builtResults count] == 0) {
                [self setUpNotCompletedForDailyChallenge];
            } else {
                [self setUpCompletedForDailyChallenge];
                userChallengeUID = [[builtResults objectAtIndex:0] objectForKey:@"uid"];
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
}

- (void)setUpCompletedForDailyChallenge
{
    _challengeCompleted.text = @"YES!";
    dailyCompleted = true;
}

#pragma mark - All Challenge Helper

- (void)getAllChallengesIHaveCompleted
{
    if (!user.uid) {
        return;
    }
    BuiltQuery *select_query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
    [select_query whereKey:@"user" equalTo:user.uid];
    
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
    NSLog(@"%@", [BuiltUser currentUser]);
    if (dailyCompleted) {
        [self setUpNotCompletedForDailyChallenge];
        BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
        
        [obj setUid:userChallengeUID];
        
        [obj destroyOnSuccess:^{
            // object is deleted
            NSLog(@"Built updated challenge not completed");
        } onError:^(NSError *error) {
            // there was an error in deleting the object
            // error.userinfo contains more details regarding the same
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    } else {
        [self setUpCompletedForDailyChallenge];
        BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
        [obj setReference:user.uid
                   forKey:@"user"];
        [obj setReference:challenge.uid
                   forKey:@"challenge"];
        [obj saveOnSuccess:^{
            // object is created successfully
            NSLog(@"Built updated challenge completed");
        } onError:^(NSError *error) {
            // there was an error in creating the object
            // error.userinfo contains more details regarding the same
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    }
}
@end
