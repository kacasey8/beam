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
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"date", @"information", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *results = [result getResult];
        if ([results count] == 0) {
            NSLog(@"NO DAILY CHALLENGE!");
        } else {
            BuiltObject *tmp = [results objectAtIndex:0];
            _challenge = [NSMutableDictionary dictionary];
            
            // I'm transferring it to a mutable dictionary so it can be saved to persistent storage on device
            
            NSArray *keysToTransfer = @[@"uid", @"information"];
            
            for (NSString *s in keysToTransfer) {
                NSString *hi = [tmp objectForKey:s];
                [_challenge setValue:hi forKey:s];
            }
                                        
            NSLog(@"%@", _challenge);
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
                NSArray *files = [builtResult objectForKey:@"files"];

                if ([files count] > 0) {
                    NSDictionary *file = [[builtResult objectForKey:@"files"] objectAtIndex:0];
                    NSString *fileUrl = [[[builtResult objectForKey:@"files"] objectAtIndex:0] objectForKey:@"url"];
                    NSURL *url = [NSURL URLWithString:fileUrl];
                    if ([[file objectForKey:@"filename"] isEqualToString:@"image"]) {
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        if (img != nil) {
                            [_challengePost setObject:img forKey:@"image"];
                        }

                    } else {
                        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
                        player.view.frame = CGRectMake(0, 200, 400, 300);
                        [self.view addSubview:player.view];
                    }
                }
                NSString *uid = [builtResult objectForKey:@"uid"];
                
                [_challengePost setObject:uid forKey:@"uid"];
                [_challengePost setObject:text forKey:@"comment"];
                
                [self updateCompletedDailyChallengeWithProperties:_challengePost];
            }
            [self saveCacheToPersistantStorage];
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
    NSString *comment = [properties objectForKey:@"comment"];
    if (comment) {
        _completedDescription.text = comment;
        _completedDescription.hidden = NO;
        [_completeButton setTitle:@"Update" forState:UIControlStateNormal];
    }

    UIImage *image = [properties objectForKey:@"image"];
    if (image) {
        CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
        UIGraphicsBeginImageContext( newSize );
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _completedImageView.image = newImage;
        _completedImageView.hidden = NO;
        _completedImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    NSURL *videoUrl = [properties objectForKey:@"video"];
    if (videoUrl) {
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        player.view.frame = CGRectMake(0, 200, 400, 300);
        [self.view addSubview:player.view];
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
