//
//  ChallengeInfoTableViewCell.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/29/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeInfoTableViewCell.h"

@implementation ChallengeInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _completeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _completeButton.layer.borderWidth = 1.0f;
    _completeButton.layer.cornerRadius = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)completeChallengeClicked:(UIButton *)sender {
    NSLog(@"clicked");
}

@end
