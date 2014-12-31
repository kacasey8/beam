//
//  ChallengeImageTableViewCell.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/28/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeImageTableViewCell.h"

@implementation ChallengeImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _image.layer.shadowColor = [UIColor blackColor].CGColor;
    _image.layer.shadowOffset = CGSizeMake(0, 1);
    _image.layer.shadowOpacity = 0.8;
    _image.layer.shadowRadius = 2.0;
    _image.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
