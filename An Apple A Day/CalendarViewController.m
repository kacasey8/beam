//
//  CalendarViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "CalendarViewController.h"
#import "HistoryViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CalendarViewController ()

@property(nonatomic, strong) NSDate *minimumDate;

@end

@implementation CalendarViewController

NSDateFormatter *dateFormatter;

//- (id)init {
//    self = [super init];
//    if (self) {
//        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
//        self.calendar = calendar;
//        calendar.delegate = self;
//        
//        self.dateFormatter = [[NSDateFormatter alloc] init];
//        [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
//        self.minimumDate = [self.dateFormatter dateFromString:@"09/20/2014"];
//        
//        self.challengeCompletedDates = @[
//                               [self.dateFormatter dateFromString:@"01/05/2015"],
//                               [self.dateFormatter dateFromString:@"01/06/2015"],
//                               [self.dateFormatter dateFromString:@"01/07/2015"]
//                               ];
//        
//        calendar.onlyShowCurrentMonth = NO;
//        calendar.adaptHeightToNumberOfWeeksInMonth = NO;
//        calendar.backgroundColor = [UIColor clearColor];
//        calendar.titleColor = [UIColor blackColor];
//        [calendar setInnerBorderColor:[UIColor clearColor]];
//        [calendar setDayOfWeekBottomColor:[UIColor blackColor] topColor:[UIColor blackColor]];
//        calendar.dayOfWeekTextColor = [UIColor whiteColor];
//        
//        calendar.frame = CGRectMake(0, 20, 320, 320);
//        [self.view addSubview:calendar];
//        
//        self.view.backgroundColor = UIColorFromRGB(0xA1E7EC);
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // using ISODate format so it will sort properly
    
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 2.;
    
    self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
        NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger currentMonthIndex = comps.month;
        
        while(currentMonthIndex <= 0){
            currentMonthIndex += 12;
        }
        
        NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
        
        return [NSString stringWithFormat:@"%@\n%d", monthText, (int)comps.year];
    };
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // Must be call in viewDidAppear
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Calendar datasource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date {
    HistoryViewController *parentVC = (HistoryViewController *) self.parentViewController;
    NSArray *completdDates = [parentVC.completedChallenges allKeys];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    return [completdDates containsObject:currentDate];
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date {
    NSLog(@"%@", [dateFormatter stringFromDate:date]);
}

@end
