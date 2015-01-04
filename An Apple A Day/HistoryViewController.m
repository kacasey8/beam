//
//  HistoryViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "HistoryViewController.h"
#import "Challenge.h"
#import "CalendarViewController.h"
#import "CalendarTableViewController.h"
#import "ChallengeDetailViewController.h"

@interface HistoryViewController ()

@property BOOL isCalendarView;
@property CalendarViewController *calendarViewController;
@property CalendarTableViewController *calendarTableViewController;

@property NSString *challengeDate; //used to open the correct challenge detail based on this date

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Global addAnimatingLoaderToView:[[[UIApplication sharedApplication] delegate] window]];
    
    _globalKeyValueStore = [Global globalClass];
    
    self.isCalendarView = YES;
    self.calendarViewContainer.hidden = NO;
    self.listViewContainer.hidden = YES;
    [self getAllChallengesIHaveCompleted];
    [self updateStreakInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toggleView:(UIBarButtonItem *)sender {
    //toggle between CalendarViewController and CalendarTableViewController
    if (self.isCalendarView) {
        self.toggleButton.title = @"Calendar";
        self.calendarViewContainer.hidden = YES;
        self.listViewContainer.hidden = NO;
    } else {
        self.toggleButton.title = @"List";
        self.calendarViewContainer.hidden = NO;
        self.listViewContainer.hidden = YES;
    }
    self.isCalendarView = !self.isCalendarView;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"destinationViewController:%@", [segue destinationViewController]);
    if ([segue.identifier isEqualToString:@"embedCalendarView"]) {
        self.calendarViewController = (CalendarViewController *) [segue destinationViewController];
    } else if ([segue.identifier isEqualToString:@"embedListView"]) {
        self.calendarTableViewController = (CalendarTableViewController *) [segue destinationViewController];
    } else if ([segue.identifier isEqualToString:@"openChallengeDetail"]) {
        ChallengeDetailViewController *challengeDetailVC = (ChallengeDetailViewController *)[segue destinationViewController];
        Challenge *selectedChallenge = [self.completedChallenges objectForKey:self.challengeDate];
        challengeDetailVC.challenge = selectedChallenge;
        
        NSLog(@"challenge date: %@", self.challengeDate);
        NSLog(@"Completed Challenges: %@", self.completedChallenges);
        NSLog(@"selected challenge: %@", [selectedChallenge toString]);
        
    }
}

- (void)openChallengeDetailForDate:(NSString *)date {
    self.challengeDate = date;
    [self performSegueWithIdentifier:@"openChallengeDetail" sender:self];
}

#pragma mark - All Challenge Helper

- (void)updateStreakInformation {
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"built_io_application_user"];
    [query whereKey:@"uid" equalTo:[_globalKeyValueStore getValueforKey:kBuiltUserUID]];
    [query includeOnlyFields:[NSArray arrayWithObjects:@"current_streak", @"highest_streak", @"last_date_completed", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        BuiltObject *user = [[result getResult] objectAtIndex:0];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // using ISODate
        
        NSDate *today = [NSDate date];
        
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-84000]; // 84000 seconds in a day.
        
        if([[dateFormatter stringFromDate:today] isEqualToString:[user objectForKey:@"last_date_completed"]]
           ||
           [[dateFormatter stringFromDate:yesterday] isEqualToString:[user objectForKey:@"last_date_completed"]]) {
            // Either completed today or yesterday. Thus current streak from server is valid.
            _currentStreakCountLabel.text = [NSString stringWithFormat:@"%@", [user objectForKey:@"current_streak"]];
        } else {
            // Haven't completed the challenge today or yesterday, invalid current streak
            _currentStreakCountLabel.text = @"0";
        }
        
        NSNumber *highest_streak = [user objectForKey:@"highest_streak"];
        
        if ([highest_streak isKindOfClass:[NSNull class]]) {
            _highestStreakCountLabel.text = @"0";
        } else {
            _highestStreakCountLabel.text = [NSString stringWithFormat:@"%@", [user objectForKey:@"highest_streak"]];
        }
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
        [Global removeAnimatingLoaderFromViewWithExplosion:[[[UIApplication sharedApplication] delegate] window]];
    }];
}

- (void)getAllChallengesIHaveCompleted {
    NSLog(@"getting all completed challenges");
    BuiltQuery *select_query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
    [select_query whereKey:@"user" equalTo:[_globalKeyValueStore getValueforKey:kBuiltUserUID]];
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"challenge"];
    [query whereKey:@"uid" equalToResultOfSelectQuery:select_query forKey:@"challenge"];
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"date", @"information", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *builtResult = [result getResult];
        
        self.completedChallenges = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [builtResult count]; i++) {
            BuiltObject *tmp = [builtResult objectAtIndex:i];
            NSString *date = [tmp objectForKey:@"date"];
            NSString *info = [tmp objectForKey:@"information"];
            NSString *uid = [tmp objectForKey:@"uid"];
            NSLog(@"date: %@\tinfo: %@\tuid:%@", date, info, uid);
            Challenge *challenge = [[Challenge alloc] initWithDate:date info:info uid:uid];
            [self.completedChallenges setObject:challenge forKey:date];
        }
        
        NSInteger challengesCompelted = [builtResult count];
        self.totalCompletedCountLabel.text = [NSString stringWithFormat:@"%d", (int)challengesCompelted];
        
        [self.calendarViewController.calendar reloadData];
        [self.calendarTableViewController updateCompletedChallenges]; //this should reload the table view data
        
        NSLog(@"Challenges completed = %d", (int)challengesCompelted);
        NSLog(@"Completed Challenges: %@", self.completedChallenges);
        
        [Global removeAnimatingLoaderFromViewWithExplosion:[[[UIApplication sharedApplication] delegate] window]];
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
        [Global removeAnimatingLoaderFromViewWithExplosion:[[[UIApplication sharedApplication] delegate] window]];
    }];
}

@end
