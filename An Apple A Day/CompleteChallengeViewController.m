//
//  CompleteChallengeViewController.m
//  An Apple A Day
//
//  Created by Alice Jia Qi Liu on 12/25/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "CompleteChallengeViewController.h"
#import <BuiltIO/BuiltIO.h>
#import "Global.h"

@interface CompleteChallengeViewController ()

@end

@implementation CompleteChallengeViewController

CGFloat SCREEN_WIDTH;
CGFloat SCREEN_HEIGHT;
NSString *placeHolderText = @"How was your experience? What did you do?";
Global *globalKeyValueStore;

- (id)init {
    self = [super init];
    if (self != nil) {
        globalKeyValueStore = [Global globalClass];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    SCREEN_WIDTH = screenRect.size.width;
    SCREEN_HEIGHT = screenRect.size.height;
    
    _textView.textContainerInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    if (self.challenge.comment) {
        _textView.text = self.challenge.comment;
        _textView.textColor = [UIColor blackColor];
    }
    
    if (self.textView.text.length == 0) {
        self.placeholder.hidden = NO;
    } else {
        self.placeholder.hidden = YES;
    }
    
    _textView.delegate = self;
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _videoUrl = self.challenge.videoUrl;

    UIImage *cameraIcon = [self imageWithImage:[UIImage imageNamed:@"camera_icon"] scaledToSize:CGSizeMake(30.0f, 20.0f)];
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithImage:cameraIcon style:UIBarButtonItemStylePlain target:self action:@selector(useCamera:)];
    cameraButton.tintColor = [UIColor grayColor];
    UIImage *galleryIcon = [self imageWithImage:[UIImage imageNamed:@"gallery_icon"] scaledToSize:CGSizeMake(30.0f, 20.0f)];
    UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithImage:galleryIcon style:UIBarButtonItemStylePlain target:self action:@selector(useGallery:)];
    galleryButton.tintColor = [UIColor grayColor];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [_toolBar setItems:@[flex, cameraButton, flex, galleryButton, flex]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self clearImageAndVideo];
    [self insertAndSetUpImage:self.challenge.image];
    [self insertAndSetUpVideoGivenVideoUrl];
}

- (void)viewDidAppear:(BOOL)animated {
    [_textView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [_textView setInputAccessoryView:_toolBar];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholder.hidden = NO;
    } else {
        self.placeholder.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)clearImageAndVideo
{
    if (_player) {
        [_player.view removeFromSuperview];
    }
    _player = nil;
    _videoUrl = nil;
    _imageView.image = nil;
}

- (void)insertAndSetUpImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    self.imageView.image = image;
    self.imageHeightConstraint.constant = image.size.height * SCREEN_WIDTH / image.size.width;
    _imageView.hidden = NO;
}

- (void)insertAndSetUpVideoGivenVideoUrl
{
    if (_videoUrl == NULL) {
        return;
    }
    _player = [[MPMoviePlayerController alloc] initWithContentURL:_videoUrl];
    _player.view.frame = CGRectMake(0, _imageView.frame.origin.y, SCREEN_WIDTH, SCREEN_WIDTH);
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
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_textView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0.0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_player.view
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
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

#pragma mark - Actions

- (IBAction)closeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)completeChallenge:(id)sender {
    if (_textView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Text Missing"
                              message: @"Reflect about what you did to complete the challenge!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    BuiltObject *obj = [BuiltObject objectWithClassUID:@"usersChallenges"];
    NSLog(@"usersChallengesUID: %@",self.challenge.usersChallengesUID);
    NSLog(@"challengeUID: %@", self.challenge.uid);
    NSLog(@"userUID: %@", [globalKeyValueStore getValueforKey:kBuiltUserUID]);
    if (self.challenge.usersChallengesUID != nil) {
        [obj setUid:self.challenge.usersChallengesUID];
        NSLog(@"updaing object with uid: %@", self.challenge.usersChallengesUID);
    } else {
        [obj setReference:[globalKeyValueStore getValueforKey:kBuiltUserUID]
                   forKey:@"user"];
        [obj setReference:self.challenge.uid
                   forKey:@"challenge"];
    }
    
    [obj setObject:_textView.text forKey:@"comment"];
    self.challenge.comment = _textView.text;

    [obj saveOnSuccess:^{
        // object is created successfully
        NSLog(@"initial update, modal is done. uid: %@", obj.uid);
        self.challenge.usersChallengesUID = obj.uid;
    } onError:^(NSError *error) {
        // there was an error in creating the object
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];

    BuiltFile *file = [BuiltFile file];
    if (_imageView.image != nil) {
        self.challenge.image = _imageView.image;
        self.challenge.videoUrl = nil;
        [file setImage:_imageView.image forKey:@"image"];
        [file saveOnSuccess:^ {
            //file successfully uploaded
            //file properties are populated
            
            [obj setObject:file.uid forKey:@"file"];
            
            [obj saveOnSuccess:^{
                // object is created successfully
                NSLog(@"Secondary update, image attached");
            } onError:^(NSError *error) {
                // there was an error in creating the object
                // error.userinfo contains more details regarding the same
                NSLog(@"%@", @"ERROR");
                NSLog(@"%@", error.userInfo);
            }];
        } onError:^(NSError *error) {
            //error in uploading
        }];
    } else if (_videoUrl != nil) {
        self.challenge.videoUrl = _videoUrl;
        self.challenge.image = nil;
        [file setFile:[_videoUrl path] forKey:@"video"];
        [file saveOnSuccess:^ {
            //file successfully uploaded
            //file properties are populated
            
            [obj setObject:file.uid
                    forKey:@"file"];
            
            [obj saveOnSuccess:^{
                // object is created successfully
                NSLog(@"Secondary update, video attached");
            } onError:^(NSError *error) {
                // there was an error in creating the object
                // error.userinfo contains more details regarding the same
                NSLog(@"%@", @"ERROR");
                NSLog(@"%@", error.userInfo);
            }];
        } onError:^(NSError *error) {
            //error in uploading
        }];
    }
    
    BuiltInstallation *installation = [BuiltInstallation currentInstallation];
    
    [installation setObject:[NSNumber numberWithInt:0]
                     forKey:@"badge"];
    
    [installation saveOnSuccess:^{
        // the badge is cleared
        // clear badge client side
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    } onError:^(NSError *error) {
        // error in clearing the badge
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];
    
    self.challenge.completed = YES;
    
    [_presenter updateCompletedDailyChallenge];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)useCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage, (NSString *) kUTTypeMovie];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
}

- (void)useGallery:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage, (NSString *) kUTTypeMovie];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = NO;
    }
}

- (void)dismissKeyboard {
    [_textView resignFirstResponder];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self clearImageAndVideo];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        [self insertAndSetUpImage:image];
        
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        _videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [self insertAndSetUpVideoGivenVideoUrl];
        
        if (_newMedia)
            UISaveVideoAtPathToSavedPhotosAlbum([_videoUrl relativePath],
                                                self,
                                                @selector(video:didFinishSavingWithError:contextInfo:),
                                                nil);
    }
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save video"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (_player) {
        _player.view.frame = CGRectMake(0, _imageView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.width);
    }
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
