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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
