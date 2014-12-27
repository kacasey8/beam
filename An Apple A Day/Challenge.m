//
//  Challenge.m
//  An Apple A Day
//
//  Created by Gavin Chu on 12/26/14.
//  Copyright (c) 2014 ieor190. All rights reserved.
//

#import "Challenge.h"

@implementation Challenge

- (instancetype)initWithDate:(NSString *)date
                        info:(NSString *)info
                         uid:(NSString *)uid {
    self = [super init];
    if(self){
        self.date = date;
        self.info = info;
        self.uid = uid;
    }
    return self;
}

- (void)updateComment:(NSString *)comment {
    self.comment = comment;
}

- (void)updateImage:(UIImage *)image {
    self.image = image;
}

@end
