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

@interface ChallengeTableViewController ()

@end

@implementation ChallengeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 0.0f, 0.0f); //hack to remove top space
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
        return cell;
    }
    return nil;
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
