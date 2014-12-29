//
//  ChallengeTableViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/28/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeTableViewController.h"
#import "ChallengeHeaderTableViewCell.h"
#import "ChallengeInfoTableViewCell.h"
#import "ChallengeImageTableViewCell.h"
#import "ChallengeCommentTableViewCell.h"
#import "ChallengeButtonTableViewCell.h"
#import "CompleteChallengeViewController.h"
#import <BuiltIO/BuiltIO.h>
#import "Global.h"

@interface ChallengeTableViewController () <ChallengeButtonTableViewCellDelegate>

@end

@implementation ChallengeTableViewController

NSDateFormatter *dateFormatter;
Global *globalKeyValueStore;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.challenge = [[Challenge alloc] init];
        globalKeyValueStore = [Global globalClass];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 0.0f, 0.0f); //hack to remove top space
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // using ISODate format so it will sort properly
}

- (void)getChallengeForDay
{
    // Set date queried to be stored to persistent storage later
    NSString *dateQueried = [dateFormatter stringFromDate:self.date];
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"challenge"];
    [query whereKey:@"date" equalTo:dateQueried];
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"uid", @"date", @"information", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSArray *results = [result getResult];
        if ([results count] == 0) {
            NSLog(@"NO DAILY CHALLENGE!");
        } else {
            BuiltObject *builtChallenge = [results objectAtIndex:0];
            NSLog(@"CHALLENGE %@", builtChallenge);
            self.challenge.date = dateQueried;
            self.challenge.info = [builtChallenge objectForKey:@"information"];
            self.challenge.uid = [builtChallenge objectForKey:@"uid"];
        }
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

- (void)queryCompletedDailyChallenge
{
    // Make sure everything is set up first. This method gets called when we successfully login and when challenge
    // is successfully queried
    if (self.challenge.uid && [globalKeyValueStore getValueforKey:kBuiltUserUID]) {
        BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
        [query whereKey:@"user" equalTo:[globalKeyValueStore getValueforKey:kBuiltUserUID]];
        [query whereKey:@"challenge" equalTo:self.challenge.uid];
        
        [query exec:^(QueryResult *result, ResponseType type) {
            // the query has executed successfully.
            // [result getResult] will contain a list of objects that satisfy the conditions
            NSArray *builtResults = [result getResult];
            
            if ([builtResults count] == 0) {
                NSLog(@"not completed");
            } else {
                NSLog(@"completed");
                NSDictionary *builtResult = [builtResults objectAtIndex:0];
                NSLog(@"%@", builtResult);
                
                self.challenge.comment = [builtResult objectForKey:@"comment"];
                NSDictionary *file = [builtResult objectForKey:@"file"];
                if (file) {
                    NSString *fileUrl = [file objectForKey:@"url"];
                    NSURL *url = [NSURL URLWithString:fileUrl];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    if ([[file objectForKey:@"filename"] isEqualToString:@"image"]) {
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        if (img != nil) {
                            self.challenge.image = img;
                        }
                        
                    } else { // must be MOV file
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"tmp.mov"];
                        
                        NSData *videoData = [NSData dataWithContentsOfURL:url];
                        
                        [[NSFileManager defaultManager] createFileAtPath:path contents:videoData attributes:nil];
                        NSURL *moveUrl = [NSURL fileURLWithPath:path];
                        
                        self.challenge.videoUrl = moveUrl;
                    }
                }
                self.challenge.usersChallengesUID = [builtResult objectForKey:@"uid"];
            }
        } onError:^(NSError *error, ResponseType type) {
            // query execution failed.
            // error.userinfo contains more details regarding the same
            NSLog(@"%@", @"ERROR");
            NSLog(@"%@", error.userInfo);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenHeight = self.view.frame.size.height;
    NSLog(@"table view height: %f", screenHeight);
    if (indexPath.row == 0) {
        NSLog(@"header height: %f", screenHeight*0.3);
        return screenHeight*0.3;
    } else if (indexPath.row == 1) {
        NSLog(@"info height: %f", screenHeight*0.7);
        return screenHeight*0.7;
    } else if (indexPath.row == 2) {
        return 300;
    } else if (indexPath.row == 3) {
        return 200;
    } else if (indexPath.row == 4) {
        return 60;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChallengeHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeHeaderCell" forIndexPath:indexPath];
        cell.dateLabel.text = @"12/28/14";
        return cell;
    } else if (indexPath.row == 1) {
        ChallengeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeInfoCell" forIndexPath:indexPath];
        cell.title.text = @"Bake Something";
        cell.info.text = @"Gather with friends and bake something delicious! Cookies, brownies, anything!";
        return cell;
    } else if (indexPath.row == 2) {
        ChallengeImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeImageCell" forIndexPath:indexPath];
        cell.image.image = self.challenge.image;
        return cell;
    } else if (indexPath.row == 3) {
        ChallengeCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeCommentCell" forIndexPath:indexPath];
        cell.comment.text = self.challenge.comment;
        return cell;
    } else if (indexPath.row == 4) {
        ChallengeButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeButtonCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (void)challengeButtonWasPressed
{
    CompleteChallengeViewController *vc = [[CompleteChallengeViewController alloc] init];
    
    vc.presenter = self;
    [self presentViewController:vc animated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
