//
//  ChallengeVideoTableViewCell.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/29/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ChallengeVideoTableViewCell : UITableViewCell

@property (strong, nonatomic) MPMoviePlayerController *player;

@end
