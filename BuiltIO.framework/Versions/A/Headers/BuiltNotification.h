//
//  BuiltNotification.h
//  builtDemo
//
//  Created by Akshay Mhatre on 09/07/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Notification class for sending notifications*/

@interface BuiltNotification : NSObject

/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */
/**
 @abstract notification message to send
 */
@property (nonatomic, strong) NSString *message;

/**
 @abstract date time at which to send the notification
 */
@property (nonatomic, strong) NSDate *sendAt;

/**
 @abstract set this property to TRUE to send the notification local to the users' timezones. Useful only with the `sendAt` property. Defaults to FALSE.
 */
@property (nonatomic, assign) BOOL localPush;

/**
 @abstract the response containing status code and all the raw HTTP response headers
 */
@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;

/**
 @abstract returns `BuiltNotification` object
 */
+ (BuiltNotification *)notification;

/**
 @abstract returns `BuiltNotification` object. Internally calls [BuiltNotification notification].
 */
+ (BuiltNotification *)init;

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



/**
 @abstract send notification
 @param successBlock Success callback.
 @param users array of users' uids
 @param errorBlock Error callback.
 @discussion set the `message` property before calling this method. You may also set `sendAt` property to specify a delivery time .
 */
- (void)sendNotificationToUsers:(NSArray *)users onSuccess:(void (^)(void))successBlock onError:(void (^) (NSError *error))errorBlock;

@end

