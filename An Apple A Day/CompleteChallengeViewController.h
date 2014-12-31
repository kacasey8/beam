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
#import "Challenge.h"
#import "ChallengeTableViewController.h"


@interface CompleteChallengeViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, atomic) Challenge *challenge; // Shared challenge object between presenter and this
@property (weak, atomic) ChallengeTableViewController *presenter;
@property (strong, nonatomic) IBOutlet UITextField *placeholder;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (strong, nonatomic) UIToolbar *toolBar;
@property NSURL *videoUrl;
@property BOOL newMedia;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end
