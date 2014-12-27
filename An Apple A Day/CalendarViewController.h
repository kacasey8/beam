//
//  CalendarViewController.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface CalendarViewController : UIViewController <JTCalendarDataSource>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) JTCalendar *calendar;

@property(nonatomic, strong) NSArray *challengeCompletedDates;

@end
