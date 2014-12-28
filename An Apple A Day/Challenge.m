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

- (NSString *)toString {
    NSString *result = @"Challenge:\n";
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\tdate: %@\n", self.date]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\tinfo: %@\n", self.info]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\tuid: %@\n", self.uid]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\tcomment: %@\n", self.comment]];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\timage: %@\n", self.image]];
    return result;
}

@end
