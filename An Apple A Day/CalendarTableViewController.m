//
//  CalendarTableViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "CalendarTableViewController.h"
#import "HistoryViewController.h"
#import "Challenge.h"
#import "ChallengeTableViewCell.h"

@interface CalendarTableViewController ()

@end

@implementation CalendarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    self.tableView.rowHeight = 81;
    
    [self updateCompletedChallenges];
    
    NSLog(@"list view challenges: %@", self.completedChallenges);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCompletedChallenges {
    HistoryViewController *parentVC = (HistoryViewController *) self.parentViewController;
    NSDictionary *completedChallengesDictionary = parentVC.completedChallenges;
    NSArray *completdDates = [completedChallengesDictionary allKeys];
    
    //reinitialize completed challenge array
    self.completedChallenges = nil;
    self.completedChallenges = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [completdDates count]; i++) {
        Challenge *challenge = [completedChallengesDictionary objectForKey:completdDates[i]];
        [self.completedChallenges addObject:challenge];
    }
    [self sortChallenges];
}

- (void)sortChallenges {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject: descriptor];
    NSArray *sortedArray = [self.completedChallenges sortedArrayUsingDescriptors:descriptors];
    [self.completedChallenges removeAllObjects];
    [self.completedChallenges addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.completedChallenges count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChallengeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeCell" forIndexPath:indexPath];
    
    Challenge *challenge = [self.completedChallenges objectAtIndex:indexPath.row];
    
    //convert date string back to NSDate
    NSString *dateString = challenge.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:dateString];
    
    //get month from date
    [dateFormatter setDateFormat:@"MMM"];
    NSString *monthString = [dateFormatter stringFromDate:date];
    
    //get day from date
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayString = [dateFormatter stringFromDate:date];
    
    cell.monthLabel.text = monthString;
    cell.dayLabel.text = dayString;
    cell.infoLabel.text = challenge.info;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Challenge *challenge = [self.completedChallenges objectAtIndex:indexPath.row];
    NSString *currentDate = challenge.date;
    HistoryViewController *parentVC = (HistoryViewController *) self.parentViewController;
    NSArray *completdDates = [parentVC.completedChallenges allKeys];
    if ([completdDates containsObject:currentDate]) {
        [parentVC openChallengeDetailForDate:currentDate];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Can't open this challenge detail. Please try again later."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
