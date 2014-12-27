//
//  HistoryViewController.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *totalCompletedCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentStreakCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *longestStreakCountLabel;
@property (strong, nonatomic) IBOutlet UIView *calendarViewContainer;
@property (strong, nonatomic) IBOutlet UIView *listViewContainer;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toggleButton;

@end
