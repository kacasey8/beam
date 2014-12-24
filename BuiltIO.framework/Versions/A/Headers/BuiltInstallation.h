//
//  BuiltInstallation.h
//  builtDemo
//
//  Created by Akshay Mhatre on 05/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltObject.h"
#import "QueryResult.h"

/** Installation class for creating installation and subscribe/unsubscribe for push notifications against a channel*/

@interface BuiltInstallation : BuiltObject


/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */
/**
 @abstract device type (iOS)
 */
@property (nonatomic, readonly, strong) NSString *deviceType;

/**
 @abstract unique id of the installation
 */
@property (nonatomic, strong) NSString *installationId;

/**
 @abstract APNS device token
 */
@property (nonatomic, strong) NSString *deviceToken;

/**
 @abstract subscription channels
 @discussion You can use the following as channel names:
 
 **{class_uid}.object.create**
 
 Use this activity channel, when you want to send notification, after any object is created inside the class with the uid class_uid
 
 **{class_uid}.object.update**
 
 Use this activity channel, when you want to send notification, after any object is updated inside the class with the uid class_uid
 
 **{class_uid}.object.delete**
 
 Use this activity channel, when you want to send notification, after any object is deleted inside the class with the uid class_uid
 
 **{class_uid}.{object_uid}.update**
 
 Use this activity channel, when you want to send notification, after an object with the uid object_uid is updated inside the class with the uid class_uid
 
 **{class_uid}.{object_uid}.delete**
 
 Use this activity channel, when you want to send notification, after an object with the uid object_uid is deleted inside the class with the uid class_uid
 
 **upload.create**
 
 Use this activity channel, when you want to send a notification after an upload is created.
 
 **{upload_uid}.update**
 
 Use this activity channel, when you want to send a notification after an upload is updated.
 
 **{upload_uid}.delete**
 
 Use this activity channel, when you want to send a notification after an upload is deleted.
 
 **upload.update**
 
 Use this activity channel, when you want to send a notification after any upload is updated.
 
 **upload.delete**
 
 Use this activity channel, when you want to send a notification after any upload is deleted.
 
 
 **Developer-Defined Channels**
 
 These are the custom-channel names that the application developer can use subscribe/unsubscribe the installations to. This can be any random name. You can directly subscribe the installation to a channel, it is not required to create a channel first and then make the installation subscribe to it
 */
@property (nonatomic, strong) NSArray *channels;


/**
 @abstract time zone of the installation
 @discussion sets a time zone to the ionstalltion object. Default is the current system time zone.
 */
@property (nonatomic, strong) NSTimeZone *timezone;


/**
 @abstract location for an installation
*/
@property (nonatomic, strong) BuiltLocation *geoLocation;


#pragma mark
#pragma mark Create Installation Object

/**---------------------------------------------------------------------------------------
 * @name Creating installation object
 *  ---------------------------------------------------------------------------------------
 */
/**
    @abstract Create BuiltInstallation instance
    @return Returns BuiltInstallation object
    @discussion Creates a BuiltInstallation object instance to update installations or subscribe/unsubscribe to installation channels
 */
+ (BuiltInstallation *)installation;

/**
 @abstract Create BuiltInstallation instance. Internally calls [BuiltInstallation installation].
 @return Returns BuiltInstallation object
 @discussion Creates a BuiltInstallation object instance to update installations or subscribe/unsubscribe to installation channels
 */
+ (BuiltInstallation *)init;

#pragma mark
#pragma mark Add/Remove Optional Headers

/**---------------------------------------------------------------------------------------
 * @name Attaching/Removing Headers
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract set value for AuthToken. If set, this value will be replaced as AuthToken.
 
 @param auth value for authtoken.
 */
- (void)setAuthToken:(NSString *)auth;

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
 @abstract If you require to create/retrieve/update an installation belonging to some other application, you can use this method to set the app parameters
 @param apiKey api key of the app
 @param appUid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)appUid;



#pragma mark
#pragma mark Create installation

/**---------------------------------------------------------------------------------------
 * @name Create Installation
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Create a new installation
 @discussion Create a new installation with the device token.
 @param deviceToken Device Token received from APNS.
 @param channels Array of channel we wish to subscribe to.
 @param successBlock Success callback. Returns installation dictionary on successful installation.
 @param errorBlock Error callback. Notifies an error that occured during installation.
 */
-(void)createInstallationWithDeviceToken:(NSData *)deviceToken andSubscriptionChannels:(NSArray *)channels onSuccess:(void (^)(void))successBlock onError:(void (^)(NSError *error))errorBlock;


#pragma mark
#pragma mark Subscribe Unsubscribe to Channels

/**---------------------------------------------------------------------------------------
 * @name Subscribe/Unsubcribe installation channels
 *  ---------------------------------------------------------------------------------------
 */

/**
    @abstract Subscribe an installation to more channels.
    @discussion Using this method you can add more channels to your subscription list.
    @param channels Array of channel we wish to subscribe to.
    @param successBlock Success callback. Returns installation data for the given installation ID after successful subscription
    @param errorBlock Error callback.
 */
-(void)subscribeToChannels:(NSArray *)channels onSuccess:(void (^)(void))successBlock onError:(void (^)(NSError *error))errorBlock;

/**
    @abstract Unsubscribe an installation from channels
    @discussion Using this method you can unsubscribe from channels.
    @param channels Array of channel we wish to unsubscribe to.
    @param successBlock Success callback. Returns installation data for the given installation ID after successful unsubscription
    @param errorBlock Error callback.
 */
-(void)unsubscribeToChannels:(NSArray *)channels onSuccess:(void (^)(void))successBlock onError:(void (^)(NSError *error))errorBlock;

/**
 @abstract Returns the current installation object that is saved on the disk.
 @discussion the installation is saved on the disk when createInstallationWithDeviceToken:andSubscriptionChannels:onSuccess:onError: is successfully executed.
 */
+(BuiltInstallation *)currentInstallation;


/**
 @abstract update the current installation with the logged in user, location and time zone.
 @param successBlock Success callback.
 @param errorBlock Error callback.
 @discussion this method associates the installation with the user and updates the location and timezone if set. Call this method after the user is logged in if user is to be associated with the installation.
 */
- (void)updateInstallationOnSuccess:(void (^)(void))successBlock onError:(void (^) (NSError *error))errorBlock;


/**
 @abstract clear the badge count
 @discussion this method notifies built.io to set the notification badge count to zero.
 */
- (void)clearBadge;

@end
