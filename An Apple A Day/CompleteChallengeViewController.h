//
//  CompleteChallengeViewController.h
//  An Apple A Day
//
//  Created by Alice Jia Qi Liu on 12/25/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ChallengeViewControllerOld.h"


@interface CompleteChallengeViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, atomic) ChallengeViewControllerOld *presenter;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (strong, nonatomic) UIToolbar *toolBar;
@property NSURL *videoUrl;
@property BOOL newMedia;

@end
