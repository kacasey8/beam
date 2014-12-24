//
//  Built.h
//  builtDemo
//
//  Created by Akshay Mhatre on 09/02/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Contains all Built API classes and functions */
@interface Built : NSObject

/**---------------------------------------------------------------------------------------
 * @name Connecting to built.io
 *  ---------------------------------------------------------------------------------------
 */

/**  
    @abstract Initialize Built
    @discussion Sets the api key and application uid of your application.
    @param apiKey api key of your application on built.io
    @param uid application uid of your application on built.io
 */
+ (void)initializeWithApiKey:(NSString *)apiKey andUid:(NSString *)uid;

/**---------------------------------------------------------------------------------------
 * @name Configuring built.io Settings
 *  ---------------------------------------------------------------------------------------
 */

/** 
    @abstract Sets the Host name and HTTP protocol for initiating calls on built.io
    @discussion Sets the Host name and HTTP protocol for initiating calls on built.io
    @param hostname host name
    @param protocol HTTP protocol for initiating calls (HTTP/HTTPS).
 */
+ (void)setHostname:(NSString *)hostname protocol:(NSString *)protocol;


/**---------------------------------------------------------------------------------------
 * @name Attaching/Removing Headers.
 *  ---------------------------------------------------------------------------------------
 */

/** 
 @abstract Additional headers if required
 
 @param header header value
 @param key header key
 */
+ (void)setHeader:(NSString *)header forKey:(NSString *)key;

/**
 @abstract Remove a header for a specific key
 @param key key for which to remove the header value
 */
+ (void)removeHeaderForKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Set/Remove Tenant
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract set tenant uid 
 @param tenantUid tenant uid
 */
+ (void)setTenant:(NSString *)tenantUid;


/**
 @abstract remove any tenants previously set
 */
+ (void)removeTenant;

@end
