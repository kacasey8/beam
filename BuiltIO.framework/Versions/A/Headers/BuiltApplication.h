//
//  BuiltApplication.h
//  builtDemo
//
//  Created by Akshay Mhatre on 24/04/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltQuery.h"

/** Application Settings and Users */
@interface BuiltApplication : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract name of the application
 */
@property (nonatomic, strong) NSString *applicationName;

/**
 @abstract api key
 */
@property (nonatomic, strong) NSString *apiKey;

/**
 @abstract app uid
 */
@property (nonatomic, strong) NSString *appUID;

/**
 @abstract account name
 */
@property (nonatomic, strong) NSString *accountName;

/**
 @abstract appDict contains the response of the fetchApplicationSettingsOnSuccess:onError: method when successful
 */
@property (nonatomic, strong) NSDictionary *appDict;

/**
@abstract the response containing status code and all the raw HTTP response headers
*/
@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;

/**---------------------------------------------------------------------------------------
 * @name Creating BuiltApplication object
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Create a new BuiltApplication object
 @return BuiltApplication object
 */
+ (BuiltApplication *)application;

/**
 @abstract Create a new BuiltApplication object. Internally calls [BuiltApplication application].
 @return BuiltApplication object
 */
+ (BuiltApplication *)init;

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
 @abstract If you require to retrieve details belonging to some other application, you can use this method to set the app parameters
 @param apiKey api key of the app
 @param uid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)uid;

/** --------------------------------------------------------------------------------------
 @name Fetch schema of classes
 -----------------------------------------------------------------------------------------
 */

/**
 @abstract fetch schema for all the classes
 @param successBlock Returns schema in callback on success. 'schema' contains the schema for all classes in the application
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchSchemaForClassesOnSuccess:(void (^) (id schema))successBlock onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract Use when fetching classes schema. This will fetch only the last activity field in the classes schema.
 */
- (void)onlyLastActivityForSchema;


/** --------------------------------------------------------------------------------------
 @name Include Application Variables
 -----------------------------------------------------------------------------------------
 */
/**
 @abstract returns application variables when fetching application settings if this method is called
 */
- (void)includeApplicationVariables;


/** --------------------------------------------------------------------------------------
 @name Fetch application settings
 -----------------------------------------------------------------------------------------
 */

/**
 @abstract Fetches application details viz. app name, uid, apikey, account name and application variables
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchApplicationSettingsOnSuccess:(void (^) (void))successBlock onError:(void (^) (NSError *error))errorBlock;

/** --------------------------------------------------------------------------------------
 @name Accesors
 -----------------------------------------------------------------------------------------
 */
/**
 @abstract get value of the application variable for the given key
 @param key the key of the application variable
 @return the value for the key provided
 */
- (NSString *)applicationVariableForKey:(NSString *)key;


/**
 @abstract Returns a BuiltQuery object for application users class
 @discussion Since this method returns an object of BuiltQuery class, all the methods of the BuiltQuery class are available and can be used to query the application user class of built.io. Use -getUsers method of QueryResult to get the list of users.
 */
+ (BuiltQuery *)getUsersQuery;

/**
 @abstract query to fetch roles.
 @discussion Since this method returns an object of BuiltQuery class, all the methods of the BuiltQuery class are available and can be used to query the role class of built.io. Use -getRoles method of QueryResult to get the list of roles.
 @return returns a `BuiltQuery` for the role class.
 */
+ (BuiltQuery *)getRolesQuery;

@end
