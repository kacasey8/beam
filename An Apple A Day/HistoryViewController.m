//
//  HistoryViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property BOOL isCalendarView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCalendarView = YES;
    self.listViewContainer.hidden = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
