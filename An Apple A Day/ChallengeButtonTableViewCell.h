//
//  ChallengeButtonTableViewCell.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/29/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChallengeButtonTableViewCellDelegate;

@interface ChallengeButtonTableViewCell : UITableViewCell
- (IBAction)buttonPressed:(id)sender;

@property (nonatomic, weak) id<ChallengeButtonTableViewCellDelegate> delegate;



@end

@protocol ChallengeButtonTableViewCellDelegate <NSObject>

- (void)challengeButtonWasPressed;

@end
