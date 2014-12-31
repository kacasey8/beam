//
//  ChallengeCommentTableViewCell.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/28/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UIImageView *openQuote;
@property (weak, nonatomic) IBOutlet UIImageView *closeQuote;

@end
