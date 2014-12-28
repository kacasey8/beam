//
//  ChallengeDetailTableViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/27/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeDetailTableViewController.h"
#import "ChallengeImageTableViewCell.h"
#import "ChallengeCommentTableViewCell.h"

@interface ChallengeDetailTableViewController ()

@end

@implementation ChallengeDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _globalKeyValueStore = [Global globalClass];
    self.tableView.rowHeight = 300;
    self.navigationItem.title = self.challenge.date;
    [self getChallengeDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getChallengeDetail {
    NSLog(@"getting challenge detail");
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"usersChallenges"];
    [query whereKey:@"challenge" equalTo:self.challenge.uid];
    [query whereKey:@"user" equalTo:[_globalKeyValueStore getValueforKey:kBuiltUserUID]];
    
    [query includeOnlyFields:[NSArray arrayWithObjects: @"uid", @"comment", @"files", nil]];
    
    [query exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        
        NSDictionary *builtResult = [[result getResult] objectAtIndex:0];
        //NSLog(@"challenge detail result %@", builtResult);
        
        NSString *comment = [builtResult objectForKey:@"comment"];
        self.challenge.comment = comment;
        
        NSDictionary *file = [builtResult objectForKey:@"files"];
        if (file) {
            NSString *fileUrl = [file objectForKey:@"url"];
            NSURL *url = [NSURL URLWithString:fileUrl];
            if ([[file objectForKey:@"filename"] isEqualToString:@"image"]) {
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [[UIImage alloc] initWithData:data];
                if (img != nil) {
                    self.challenge.image = img;
                }
                
//            } else {
//                MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
//                player.view.frame = CGRectMake(0, 200, 400, 300);
//                [self.view addSubview:player.view];
            }
        }
        NSLog(@"%@", [self.challenge toString]);

        [self.tableView reloadData];
    } onError:^(NSError *error, ResponseType type) {
        // query execution failed.
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.challenge.image) {
//        return 2;
//    } else {
//        return 1;
//    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChallengeImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeImageCell" forIndexPath:indexPath];
        cell.image.image = self.challenge.image;
        return cell;
    } else {
        ChallengeCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeCommentCell" forIndexPath:indexPath];
        cell.comment.text = self.challenge.comment;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 101;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    customHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *challengeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-20, 100)];
    challengeTitle.text = self.challenge.info;
    challengeTitle.textAlignment = NSTextAlignmentCenter;
    challengeTitle.numberOfLines = 3;
    challengeTitle.lineBreakMode = NSLineBreakByWordWrapping;
    challengeTitle.backgroundColor = [UIColor whiteColor];
    [customHeaderView addSubview:challengeTitle];
    
    CGRect sepFrame = CGRectMake(0, customHeaderView.frame.size.height-1, self.tableView.frame.size.width, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [customHeaderView addSubview:seperatorView];
    return customHeaderView;
}

@end
