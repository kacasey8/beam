//
//  ChallengeViewController.m
//  An Apple A Day
//
//  Created by Kevin Casey on 12/24/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeViewController.h"
#import "CompleteChallengeViewController.h"

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController

NSString *dateQueried;
bool dailyCompleted;
NSDateFormatter *dateFormatter;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // using ISODate format so it will sort properly
    
    _globalKeyValueStore = [Global globalClass];
    _completedDescription.hidden = YES;
    _completedImageView.hidden = YES;
    
    [self getDailyChallenge];
    
    /*[self loadCacheFromPersistantStorage];
    
    if ([self shouldUseCache]) {
        NSLog(@"using cache");
        [self setUpInformationForChallenge];
        if (dailyCompleted) {
            
        }
    }*/
}

- (void)activateView
{
    if (![self shouldUseCache]) {
        NSLog(@"Querying server for challenge");
        [self queryCompletedDailyChallenge];
    } else {
        NSLog(@"Querying server for challenge");
        [self queryCompletedDailyChallenge];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Persistant Storage

- (void)saveCacheToPersistantStorage
{
    [_globalKeyValueStore setValue:_challenge forKey:kChallengeObject];
    [_globalKeyValueStore setValue:dateQueried forKey:kChallengeDate];
    [_globalKeyValueStore setValue:[NSNumber numberWithBool:dailyCompleted] forKey:kChallengeCompleted];
}

- (void)loadCacheFromPersistantStorage
{
    dateQueried = [_globalKeyValueStore getValueforKey:kChallengeDate];
    if (![self shouldUseCache]) {
        // Date doesn't line up. No point in querying anything else
        return;
    }
    
    _challenge = [_globalKeyValueStore getValueforKey:kChallengeObject];
    dailyCompleted = [[_globalKeyValueStore getValueforKey:kChallengeCompleted] boolValue];
}

- (BOOL) shouldUseCache
{
    return [dateQueried isEqualToString:[dateFormatter stringFromDate:[NSDate date]]];
}

#pragma mark - Daily Challenge

- (void)getDailyChallenge
{
    // Set date queried to be stored to persistent storage later
    dateQueried = [dateFormatter stringFromDate:[NSDate date]];
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"challenge"];
    [query whereKey:@"date" equalTo:dateQueried];
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"date", @"information", @"background", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *results = [result getResult];
        if ([results count] == 0) {
            NSLog(@"NO DAILY CHALLENGE!");
        } else {
            _challenge = [results objectAtIndex:0];
            NSLog(@"CHALLENGE %@", _challenge);
            [self setUpInformationForChallenge];
            [self queryCompletedDailyChallenge];
        }
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

- (void)setUpInformationForChallenge
{
    _challengeInformation.text = [_challenge objectForKey:@"information"];
    NSDictionary *file = [_challenge objectForKey:@"background"];
    if (file) {
        NSString *fileUrl = [file objectForKey:@"url"];
        NSURL *url = [NSURL URLWithString:fileUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage alloc] initWithData:data]];
    } else {
        // self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"background"]]];
    }
}

- (void)queryCompletedDailyChallenge
{
    // Make sure everything is set up first. This method gets called when we successfully login and when challenge
    // is successfully queried
    if ([_challenge objectForKey:@"uid"] && [_globalKeyValueStore getValueforKey:kBuiltUserUID]) {
        BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
        [query whereKey:@"user" equalTo:[_globalKeyValueStore getValueforKey:kBuiltUserUID]];
        [query whereKey:@"challenge" equalTo:[_challenge objectForKey:@"uid"]];
        
        [query exec:^(QueryResult *result, ResponseType type) {
            // the query has executed successfully.
            // [result getResult] will contain a list of objects that satisfy the conditions
            NSArray *builtResults = [result getResult];
            
            if ([builtResults count] == 0) {
                NSLog(@"not completed");
                dailyCompleted = false;
            } else {
                NSLog(@"completed");
                dailyCompleted = true;
                NSDictionary *builtResult = [builtResults objectAtIndex:0];
                NSLog(@"%@", builtResult);
                
                _challengePost = [[NSMutableDictionary alloc] init];
                NSString *text = [builtResult objectForKey:@"comment"];
                NSDictionary *file = [builtResult objectForKey:@"files"];
                if (file) {
                    NSString *fileUrl = [file objectForKey:@"url"];
                    NSURL *url = [NSURL URLWithString:fileUrl];
                    if ([[file objectForKey:@"filename"] isEqualToString:@"image"]) {
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        if (img != nil) {
                            [_challengePost setObject:img forKey:@"image"];
                        }

                    } else { // must be MOV filename
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"tmp.mov"];
                        
                        NSData *videoData = [NSData dataWithContentsOfURL:url];
                        
                        [[NSFileManager defaultManager] createFileAtPath:path contents:videoData attributes:nil];
                        NSURL *moveUrl = [NSURL fileURLWithPath:path];
                        
                        [_challengePost setObject:moveUrl forKey:@"video"];
                    }
                }
                NSString *uid = [builtResult objectForKey:@"uid"];
                
                [_challengePost setObject:uid forKey:@"uid"];
                [_challengePost setObject:text forKey:@"comment"];
                
                [self updateCompletedDailyChallengeWithProperties:_challengePost];
            }
            // [self saveCacheToPersistantStorage];
        } onError:^(NSError *error, ResponseType type) {
            // query execution failed.
            // error.userinfo contains more details regarding the same
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    }
}

- (void)updateCompletedDailyChallengeWithProperties:(NSMutableDictionary *)properties {
    _challengePost = [[NSMutableDictionary alloc] initWithDictionary:properties];
    
    // set text information
    NSString *comment = [properties objectForKey:@"comment"];
    if (comment) {
        _completedDescription.text = comment;
        _completedDescription.hidden = NO;
        [_completeButton setTitle:@"Update"];
    }
    
    // Clear old data.
    if (_player) {
        [_player.view removeFromSuperview];
    }
    _player = nil;
    _completedImageView.image = nil;

    UIImage *image = [properties objectForKey:@"image"];
    NSURL *videoUrl = [properties objectForKey:@"video"];

    if (image) {
        CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
        UIGraphicsBeginImageContext( newSize );
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _completedImageView.image = newImage;
        _completedImageView.hidden = NO;
        _completedImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else if (videoUrl) {
        _player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        _player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        [_player prepareToPlay];
        [self.scrollView addSubview:_player.view];

        // Need to add in all the constraints. This is basically all constraints on the _imageView
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_player.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0]];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_player.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_completedDescription
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0.0]];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_player.view
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0.0]];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_player.view
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0]];
        
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_player.view
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (_player) {
        _player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    }
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    // Close the session and remove the access token from the cache
    // The session state handler (in the app delegate) will be called automatically
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)promptCompleteChallenge:(id)sender {
    CompleteChallengeViewController *vc = [[CompleteChallengeViewController alloc] init];

    vc.presenter = self;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
