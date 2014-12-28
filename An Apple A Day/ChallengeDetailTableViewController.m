//
//  ChallengeDetailTableViewController.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/27/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "ChallengeDetailTableViewController.h"

@interface ChallengeDetailTableViewController ()

@end

@implementation ChallengeDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 300;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeImageCell" forIndexPath:indexPath];
        cell.textLabel.text = @"image should be here";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"challengeCommentCell" forIndexPath:indexPath];
        cell.textLabel.text = @"comment";
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
    NSLog(@"tableview width %f", self.tableView.frame.size.width);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
