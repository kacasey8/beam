//
//  BuiltAnalytics.h
//  builtDemo
//
//  Created by Samir Bhide on 28/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltEvent.h"
/**  
Class for integrating BuiltAnalytics support for apps.
Use BuiltAnalytics class to track an event to analyse the datapoints, the use case and usage behaviour throughout the app.

        // Initialize the API
        BuiltAnalytics *builtAnalytics = [BuiltAnalytics sharedInstance];
     
        // Set super properties that are to be sent with every event
        NSDictionary *superProperties = [NSDictionary dictionaryWithObjectsAndKeys:@"Username", @"Steve",@"email",@"steve.jobs@domainname.com" nil];
        [builtAnalytics registerSuperProperties:superProperties];
 
        //Create event
        BuiltEvent *event = [[BuiltEvent alloc]init];
        [event setEventUid:@"logged_in"];
 
        //Track event
        [builtAnalytics trigger:event];
 */


@interface BuiltAnalytics : NSObject{

}

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract the interval for saving the analytics to built.io regularly. Default is 60 seconds.
 */
@property(nonatomic,assign) NSUInteger flushInterval;

/**
 @abstract the response containing status code and all the raw HTTP response headers
 */
@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;

/**---------------------------------------------------------------------------------------
 * @name Instantiate BuiltAnalytics
 *  ---------------------------------------------------------------------------------------
 */

/**
    @abstract Initializes and returns instance of the API or returns the previously instantiated singleton instance of the API.
 */
+ (BuiltAnalytics *)sharedInstance;


/**----------------------------------------------------------------------------------------
 * @name Attaching/Removing Headers
 *-----------------------------------------------------------------------------------------
 */

/**
 @abstract Additional headers if required
 
 @param header header value
 @param key header key
 */
- (void)setHeader:(NSString *)header forKey:(NSString *)key;

/**
 @abstract Remove a header for a specific key
 @param key key for which to remove the header value
 */
- (void)removeHeaderForKey:(NSString *)key;


/** --------------------------------------------------------------------------------------
 @name Set api key and app uid for another application
 -----------------------------------------------------------------------------------------
 */

/**
 @abstract If you require to log analytics belonging to some other application, you can use this method to set the app parameters
 @param apiKey api key of the app
 @param uid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)uid;


/**---------------------------------------------------------------------------------------
 * @name Register super properties
 *  ---------------------------------------------------------------------------------------
 */
/**
    @abstract Registers super properties, overwriting ones that have already been set.
 
    @discussion Super properties, once registered, are automatically sent as properties for
 all event tracking calls. They save you having to maintain and add a common
 set of properties to your events. Property keys must be <code>NSString</code>
 objects and values must be <code>NSString</code>, <code>NSNumber</code>,
 <code>NSNull</code>, <code>NSArray</code>, <code>NSDictionary</code>,
 <code>NSDate</code> or <code>NSURL</code> objects.
 
    @param properties      properties dictionary
 */
- (void)registerSuperProperties:(NSDictionary *)properties;


/**---------------------------------------------------------------------------------------
 * @name Track events
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract use this method to trigger the event.
 @param event an object of `BuiltEvent`
 @discussion The analytics will be saved to built.io regularly depending upon the `flushInterval`.
 */
- (void)trigger:(BuiltEvent *)event;


@end

