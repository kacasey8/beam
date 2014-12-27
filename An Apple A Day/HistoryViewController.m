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

@interface HistoryViewController ()

@property BOOL isCalendarView;
@property CalendarViewController *calendarViewController;
@property CalendarTableViewController *calendarTableViewController;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _globalKeyValueStore = [Global globalClass];
    
    self.isCalendarView = YES;
    self.listViewContainer.hidden = YES;
    [self getAllChallengesIHaveCompleted];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedCalendarView"]) {
        self.calendarViewController = (CalendarViewController *) [segue destinationViewController];
    } else if ([segue.identifier isEqualToString:@"embedListView"]) {
        self.calendarTableViewController = (CalendarTableViewController *) [segue destinationViewController];
    }
}

#pragma mark - All Challenge Helper

- (void)getAllChallengesIHaveCompleted {
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
        
        self.completedChallenges = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [builtResult count]; i++) {
            BuiltObject *tmp = [builtResult objectAtIndex:0];
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
        
        NSLog(@"Challenges completed = %d", (int)challengesCompelted);
        NSLog(@"Completed Challenges: %@", self.completedChallenges);
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

@end
