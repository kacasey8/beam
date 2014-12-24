//
//  BuiltDelta.h
//  builtDemo
//
//  Created by Samir Bhide on 08/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeltaResult.h"
#import "BuiltQuery.h"

/** BuiltDelta fetches objects that are modified (created/updated/deleted) at/on specified date */
@interface BuiltDelta : BuiltQuery
@property (nonatomic, strong)NSString *classUID;


/**---------------------------------------------------------------------------------------
 * @name Create DeltaResult instance 
 *  ---------------------------------------------------------------------------------------
 */

/** 
        @abstract BuiltDelta instance.
        @param classUID Class UID of which delta object needs to be fetched.
 */
+ (BuiltDelta *)deltaWithClassUID:(NSString *)classUID;

/**---------------------------------------------------------------------------------------
 * @name Attaching/Removing Headers.
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Additional headers if required
 
 @param header header value
 @param key header key
 */
- (void)setHeader:(NSString *)header forKey:(NSString *)key;
/**
 @abstract Remove a header for a specific key
 @param key Key for which to remove the header value
 */
- (void)removeHeaderForKey:(NSString *)key;


/** --------------------------------------------------------------------------------------
 @name Set api key and app uid for another application
 -----------------------------------------------------------------------------------------
 */

/**
 @abstract If you require to get delta belonging to some other application, you can use this method to set the app parameters
 @param apiKey api key of the app
 @param uid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)uid;


/**---------------------------------------------------------------------------------------
 * @name Delta methods
 *  ---------------------------------------------------------------------------------------
 */

/**
    @abstract Get delta objects created on and after certain time given by user
    @param date Date condition on which delta to be applied.
    @discussion Time in format of DD-MM-YYYY OR DD-MM-YYYY HH:MM:SS.
 */
- (void)createdAt:(NSDate *)date;


/**
    @abstract Get delta objects updated on and after certain time given by user
    @param date Date condition on which delta to be applied.
    @discussion Time in format of DD-MM-YYYY OR DD-MM-YYYY HH:MM:SS.
 */
- (void)updatedAt:(NSDate *)date;


/**
    @abstract Get delta objects deleted on and after certain time given by user
    @param date Date condition on which delta to be applied.
    @discussion Time in format of DD-MM-YYYY OR DD-MM-YYYY HH:MM:SS.
 */
- (void)deletedAt:(NSDate *)date;

/**
    @abstract Get ALL delta objects updated, deleted, created on and after certain time given by user
    @param date Date condition on which delta to be applied.
    @discussion Time in format of DD-MM-YYYY OR DD-MM-YYYY HH:MM:SS.
 */
- (void)allDeltaAt:(NSDate *)date;


/**
    @abstract Execute Delta object query to get delta objects
    @param successBlock CallBack in case of success. Returns DeltaResult
    @param errorBlock CallBack in case of failure.
    @discussion use this method to fetch delta objects. Do NOT use `exec:onError:` method of query.
 */
- (void)execDeltaQuery:(void (^) (DeltaResult *result))successBlock onError:(void (^) (NSError *error))errorBlock;

@end
