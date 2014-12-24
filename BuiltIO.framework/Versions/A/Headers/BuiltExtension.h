//
//  BuiltExtension.h
//  builtDemo
//
//  Created by Akshay Mhatre on 10/08/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Execute a code snippet in extension*/


@interface BuiltExtension : NSObject

/**
 @abstract Makes a call to an extension function
 @param functionName the name of the function that you want to execute
 @param properties any data that you want to pass to the function
 @param successBlock on success this block will be called and `response` will contain the response from the extension method
 @param errorBlock in case of any errors this block will be called
 */
+ (void)executeWithName:(NSString *)functionName
                   data:(NSDictionary *)properties
              onSuccess:(void (^)(id response))successBlock
                onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract Makes a call to an extension function
 @param functionName the name of the function that you want to execute
 @param successBlock on success this block will be called and `response` will contain the response from the extension method
 @param errorBlock in case of any errors this block will be called
 */
+ (void)executeWithName:(NSString *)functionName
              onSuccess:(void (^)(id response))successBlock
                onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract cancel all executing requests
 */
+ (void)cancelRequests;

@end
