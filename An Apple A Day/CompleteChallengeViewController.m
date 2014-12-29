//
//  CompleteChallengeViewController.m
//  An Apple A Day
//
//  Created by Alice Jia Qi Liu on 12/25/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "CompleteChallengeViewController.h"

@interface CompleteChallengeViewController ()

@end

@implementation CompleteChallengeViewController

CGFloat SCREEN_WIDTH;
CGFloat SCREEN_HEIGHT;

- (id)init {
    self = [super initWithNibName:@"CompleteChallengeViewController" bundle:nil];
    if (self != nil) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    SCREEN_WIDTH = screenRect.size.width;
    SCREEN_HEIGHT = screenRect.size.height;
    // Do any additional setup after loading the view from its nib.
    
    _textView.text = [_presenter.challengePost objectForKey:@"comment"];
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonSystemItemAction target:self action:@selector(useCamera:)];
    UIBarButtonItem *imagesButton = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonSystemItemAction target:self action:@selector(useImages:)];
    [_toolBar setItems:@[cameraButton, imagesButton]];
    _textView.delegate = self;
    
    [self clearImageAndVideo];
    [self insertAndSetUpImage:[_presenter.challengePost objectForKey:@"image"]];
    _videoUrl = [_presenter.challengePost objectForKey:@"video"];
    [self insertAndSetUpVideoGivenVideoUrl];
}

- (void)viewDidAppear:(BOOL)animated {
    [_textView becomeFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_textView setInputAccessoryView:_toolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

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
    CGSize newSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView.image = newImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.hidden = NO;
    [self.view setNeedsDisplay];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (_presenter.challengePost != nil) {
        [obj setUid:[_presenter.challengePost objectForKey:@"uid"]];
        NSLog(@"updaing object with uid: %@", [_presenter.challengePost objectForKey:@"uid"]);
    } else {
        [obj setReference:[_presenter.globalKeyValueStore getValueforKey:kBuiltUserUID]
                   forKey:@"user"];
        [obj setReference:[_presenter.challenge objectForKey:@"uid"]
                   forKey:@"challenge"];
    }
    
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:_textView.text forKey:@"comment"];
    [obj setObject:_textView.text forKey:@"comment"];

    [obj saveOnSuccess:^{
        // object is created successfully
        NSLog(@"initial update, modal is done. uid: %@", obj.uid);
        [_presenter.challengePost setObject:obj.uid forKey:@"uid"];
    } onError:^(NSError *error) {
        // there was an error in creating the object
        // error.userinfo contains more details regarding the same
        NSLog(@"%@", @"ERROR");
        NSLog(@"%@", error.userInfo);
    }];

    BuiltFile *file = [BuiltFile file];
    if (_imageView.image != nil) {
        [properties setValue:_imageView.image forKey:@"image"];
        [file setImage:_imageView.image forKey:@"image"];
        [file saveOnSuccess:^ {
            //file successfully uploaded
            //file properties are populated
            
            NSLog(@"Image up, uid: %@", file.uid);
            
            [obj setObject:file.uid
                    forKey:@"file"];
            
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
        [properties setValue:_videoUrl forKey:@"video"];
        [file setFile:[_videoUrl path] forKey:@"video"];
        [file setContentType:@"mov"];
        [file saveOnSuccess:^ {
            //file successfully uploaded
            //file properties are populated
            
            NSLog(@"Video up, uid: %@", file.uid);
            
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
    
    [_presenter updateCompletedDailyChallengeWithProperties:properties];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)useCamera:(id)sender {
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

- (IBAction)useImages:(id)sender {
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
