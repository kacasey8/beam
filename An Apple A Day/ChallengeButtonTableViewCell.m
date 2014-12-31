//
//  ChallengeButtonTableViewCell.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/29/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeButtonTableViewCell.h"

@implementation ChallengeButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _button.layer.borderColor = [[UIColor whiteColor] CGColor];
    _button.layer.borderWidth = 2.0f;
    _button.layer.cornerRadius = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
