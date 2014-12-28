//
//  ChallengeTableViewCell.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/28/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end
