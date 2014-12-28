//
//  Challenge.h
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Challenge : NSObject

@property NSString *date;
@property NSString *info;
@property NSString *uid;
@property NSString *comment;
@property UIImage *image;

- (instancetype)initWithDate:(NSString *)date
                        info:(NSString *)info
                         uid:(NSString *)uid;

- (void)updateComment:(NSString *)comment;
- (void)updateImage:(UIImage *)image;

- (NSString *)toString;

@end
