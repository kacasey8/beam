//
//  BuiltUser.h
//  builtDemo
//
//  Created by Akshay Mhatre on 28/02/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

@class ACAccount;
@class BuiltACL;
@class BuiltQuery;

#import <Foundation/Foundation.h>
#import "BuiltLocation.h"
#import <UIKit/UIKit.h>


/**---------------------------------------------------------------------------------------
 *  GoogleLoginDelegate
 *  ---------------------------------------------------------------------------------------
 */
@protocol GoogleLoginDelegate <NSObject>

/**
 @abstract delegate method that provides the access token after authenticating with google. Implement this delegate when using google UI method showGoogleLoginUIOnViewController:forClientID:forClientSecret:
 @param accessToken access token that is received from Google Authorization Server
 */
- (void)didReceiveAccessToken:(NSString *)accessToken;

@end

/** Users are a special class that allows adding the users functionality to your application. Features such as registration, logging in, logging out live here.
 
 After the log in, a session cookie will be dropped, and the "authtoken" will be given in response. This authtoken is to be supplied for subsequent requests if the the request is to be identified as being from that user */
@interface BuiltUser : NSObject

/**---------------------------------------------------------------------------------------
 * @name Accessing the Current User
 *  ---------------------------------------------------------------------------------------
 */

/** 
    @abstract Gets the currently logged in user from disk and returns an instance of it
    @discussion Gets the currently logged in user from disk and returns an instance of it.
    @return Returns a BuiltUser that is the currently logged in user. If there is none, returns nil.
 */
+ (BuiltUser *)currentUser;


/**
 @abstract the response containing status code and all the raw HTTP response headers
 */
@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;


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
 @abstract If you require to create/retrieve/update a user object belonging to some other application, you can use this method to set the app parameters
 @param apiKey api key of the app
 @param uid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)uid;


/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */
/** 
    @abstract The username for BuiltUser
    @discussion The username for BuiltUser 
 */
@property(nonatomic, strong) NSString *username;


/** 
 @abstract The email for BuiltUser
 @discussion The email for BuiltUser
 */
@property(nonatomic, strong) NSString *email;


/** 
    @abstract The firstname for BuiltUser
    @discussion The firstname for BuiltUser
 */
@property(nonatomic, strong) NSString *firstName;


/** 
 @abstract The lastName for BuiltUser
 @discussion The lastName for BuiltUser
 */
@property(nonatomic, strong) NSString *lastName;


/** 
    @abstract The password for BuiltUser
    @discussion The password for BuiltUser
 */
@property(nonatomic, strong) NSString *password;


/** 
    @abstract Password confirmation
    @discussion Password confirmation to confirm that you are real you, not a bot.
 */
@property(nonatomic, strong) NSString *confirmPassword;

/**
 @abstract The authtoken after logging in
 @discussion The authtoken after logging in
 */
@property (nonatomic, strong) NSString *authtoken;

/**
 @abstract the uid of the user
 @discussion the uid of the user
 */
@property (nonatomic, strong) NSString *uid;

/**
 @abstract the old password of the user
 @discussion the old password of the user to be provided in case user wants to update his/her password. 
 */
@property (nonatomic, strong) NSString *oldPassword;


/**
 @abstract The ACL for the object
 */
@property (nonatomic, strong) BuiltACL *ACL;

/**
 @abstract Custom properties to be set when updating BuiltUser's details, if any. 
 @discussion Any custom properties can be set when updating details of BuiltUser.
 */
@property (nonatomic, strong) NSMutableDictionary *customProperties;


#pragma mark
#pragma mark Create user object

/**---------------------------------------------------------------------------------------
 * @name Creating a New User
 *  ---------------------------------------------------------------------------------------
 */
/** 
    @abstract Creates a new BuiltUser object
    @discussion Creates a new BuiltUser object
    @return Returns a new BuiltUser object.
 */
+ (BuiltUser *)user;

/**
 @abstract Creates a new BuiltUser object. Internally calls [BuiltUser user].
 @discussion Creates a new BuiltUser object
 @return Returns a new BuiltUser object.
 */
+ (BuiltUser *)init;

/**
 @abstract Creates a new BuiltUser object from the response dictionary
 @param dict the response dictionary for the application user
 @discussion Creates a new BuiltUser object
 @return Returns a new BuiltUser object.
 */
- (BuiltUser *)initWithUserDict:(NSDictionary *)dict;

/** 
 @abstract set location for a user
 @param location an object of `BuiltLocation`
 @discussion use this method when signing up a user.
 */
- (void)setLocation:(BuiltLocation *)location;


/**
 @abstract set value for the given key
 @param object the object to set
 @param key the key(field uid in user class)
 */
- (void)setObject:(id)object forKey:(NSString *)key;


/**
 @abstract set object/UID for reference field
 @param reference This can either be a UID of a referenced object or an instance of BuiltObject.
 @param key (field uid in user class) for which you are setting the object
 */
- (void)setReference:(id)reference forKey:(NSString *)key;

#pragma mark
#pragma mark Application User Actions

/**---------------------------------------------------------------------------------------
 * @name Signing Up
 *  ---------------------------------------------------------------------------------------
 */

/** 
    @abstract Signs up the user. Make sure that password and email are set
    @discussion Signs up the user. Make sure that password and email are set. This will also enforce that the email isn't already taken.
    @param successBlock CallBack in case of success.
    @param errorBlock CallBack in case of failure.
 */
- (void)signUpOnSuccess:(void (^) (void))successBlock
                onError:(void (^) (NSError *error))errorBlock;

/**---------------------------------------------------------------------------------------
 * @name Update User
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Updates the existing user
 @discussion Updates the existing user info. This method can also be used to update other custom fields of the user class.
 @discussion User's tibbr and Google Auth data can updated by providing auth_data `NSDictionary` in params. Pass `nil` if there's no need to update auth data.
 @discussion example: For updating tibbr auth data pass `NSDictionary` in following manner. `NSDictionary` *auth_data = @{@"tibbr": @{@"access_token": @"<tibbr_access_token>", @"host":@"<tibbr_host>"}};
 @discussion For updating Google's auth data pass `NSDictionary` in following manner. `NSDictionary` *auth_data = @{@"google": @{@"access_token": @"<google_access_token>"}}
 @discussion We can also update custom properties by `setCustomProperties` method on BuiltUser object, passing `NSDictionary` of fields to be updated.
 @param auth Updates the user's auth data with data provided in `NSDictionary`. This is an optional parameter.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)updateUserWithAuthData:(NSDictionary *)auth onSuccess:(void (^) (void))successBlock onError:(void (^) (NSError *error))errorBlock;


/**---------------------------------------------------------------------------------------
 * @name Logging in
 *  ---------------------------------------------------------------------------------------
 */
/** 
    @abstract Login BuiltUser by providing email as ID and signup password
    @discussion Login BuiltUser by providing email as ID and signup password.
    @param email Email address that you used to signup.
    @param password Your signup password.
    @param successBlock CallBack in case of success.
    @param errorBlock CallBack in case of failure.
 */
- (void)loginWithEmail:(NSString *)email
           andPassword:(NSString *)password
             OnSuccess:(void (^) (void))successBlock
               onError:(void (^) (NSError *error))errorBlock;


/** 
    @abstract Login using Google OAuth 2.0 access token
    @discussion Login BuiltUser by providing Google's OAuth 2.0 access token.
    @param accessToken Google OAuth 2.0 Access Token
    @param successBlock CallBack in case of success.
    @param errorBlock CallBack in case of failure.
 */
- (void)loginWithGoogleAuthAccessToken:(NSString *)accessToken onSuccess:(void (^) (void))successBlock
                                   onError:(void (^) (NSError *error))errorBlock;



/**
 @abstract Login using Facebook access token
 @discussion Login BuiltUser by providing Facebook access token.
 @param accessToken Facebook OAuth Access Token
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)loginWithFacebookAccessToken:(NSString *)accessToken onSuccess:(void (^) (void))successBlock
                             onError:(void (^) (NSError *error))errorBlock;


/**
 @abstract Login with Twitter
 @discussion Login BuiltUser by providing twitter account and consumer key and secret
 @param twitterAccount You can use `ACAccountStore`'s accountsWithAccountType:(ACAccountType *)accountType method to retrieve existing signed in twitter accounts
 @param key consumer key of your twitter app
 @param secret consumer secret of your twitter app
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)loginWithTwitterAccount:(ACAccount *)twitterAccount
                    consumerKey:(NSString *)key
                 consumerSecret:(NSString *)secret
                      onSuccess:(void (^) (void))successBlock
                        onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract Login using tibbr access token
 @discussion Login BuiltUser by providing tibbr access token.
 @param accessToken tibbr OAuth 2.0 Access Token
 @param hostname The host or endpoint of the tibbr installation
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)loginWithTibbrAccessToken:(NSString *)accessToken
                      andHostName:(NSString *)hostname
                        onSuccess:(void (^) (void))successBlock
                          onError:(void (^) (NSError *error))errorBlock;

/**---------------------------------------------------------------------------------------
 * @name Logging Out
 *  ---------------------------------------------------------------------------------------
 */

/** 
    @abstract Logs out the currently logged in user on disk
    @discussion Logs out the currently logged in user on disk.
    @param successBlock CallBack in case of success.
    @param errorBlock CallBack in case of failure.
 */
- (void)logoutOnSuccess:(void (^) (void))successBlock
                onError:(void (^) (NSError *error))errorBlock;


/**---------------------------------------------------------------------------------------
 * @name Deactivate User
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Deactivates user's account on built.io
 @discussion Deactivates user's account on built.io
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)deactivateOnSuccess:(void (^) (void))successBlock
                    onError:(void (^) (NSError *error))errorBlock;


/**---------------------------------------------------------------------------------------
 * @name Refresh user info
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Fetch Logged In user's all information from built server
 @param successBlock CallBack in case of success
 @param errorBlock CallBack in case of failure
 */
- (void)refreshUserInfoOnSuccess:(void (^) (void))successBlock
                         onError:(void (^) (NSError *error))errorBlock;


#pragma mark

/**---------------------------------------------------------------------------------------
 * @name Requesting a Password Reset
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Send a password reset request for a specified email. If a user account exists with that email, an email will be sent to that address with instructions on how to reset their password
 @discussion Send a password reset request for a specified email. If a user account exists with that email, an email will be sent to that address with instructions on how to reset their password.
 @param email Email of the account to send a reset password request.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)forgotPasswordForEmail:(NSString *)email onSuccess:(void (^) (void))successBlock
                             onError:(void (^) (NSError *error))errorBlock;


#pragma mark
#pragma mark Check Authentication


/**
 @abstract Whether the user is an authenticated object for the device. An authenticated BuiltUser is one that is obtained via a signUp or logIn method. An authenticated object is required in order to save (with altered values) or delete it
 @discussion Whether the user is an authenticated object for the device. An authenticated BuiltUser is one that is obtained via a signUp or logIn method. An authenticated object is required in order to save (with altered values) or delete it
 @return Returns whether the user is authenticated
 */
- (BOOL)isAuthenticated;


#pragma mark
#pragma mark getter

/**---------------------------------------------------------------------------------------
 * @name Accessor
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Get Object for key
 @discussion Get Object for key
 @param key key for which objects have to be fetched
 */
- (id)objectForKey:(NSString *)key;

/**
 @abstract get location of an object
 @return `BuiltLocation` object with the longitude and latitude of the object
 */
- (BuiltLocation *)getLocation;

/**---------------------------------------------------------------------------------------
 * @name User Session Maintenance
 *  ---------------------------------------------------------------------------------------
 */


#pragma mark
#pragma mark User Session

/** 
    @abstract Saves User Session to disk.
    @discussion Saves User Session to disk.
 */
- (void)saveSession;


/** 
    @abstract Clears User Session
    @discussion Clears User Session.
 */
- (void)clearSession;

/**
 @abstract Gets user session
 @discussion Gets user session stored on disk.
 @return Returns saved BuiltUser Session stored on disk.
 */
+ (BuiltUser *)getSession;

/**
    @abstract Sets Current logged in `BuiltUser` object.
    @discussion Sets the current user from `BuiltUser` object passed in params.
    @param user `BuiltUser` object. Ideally object returned by `(BuiltUser *)getSession` method.
 */
+(void)setCurrentUser:(BuiltUser *)user;



#pragma mark
#pragma mark Getting user id

/**---------------------------------------------------------------------------------------
 * @name Fetch user uid
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract Fetch user uid by providing email
 @discussion This call will allow you to retrieve the uid for a user, whether or not the user exists. A means for identifying the user needs to be provided. This comes in handy, for example, when you need to apply ACL for a user that may not exist in the system at the moment.
 @param email email of the user
 @param successBlock CallBack in case of success. 'uid' will have the uid of the user.
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchUserUidForEmail:(NSString *)email onSuccess:(void (^) (NSString *uid))successBlock
                     onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract Fetch user uid by providing google email
 @discussion This call will allow you to retrieve the uid for a user, whether or not the user exists. A means for identifying the user needs to be provided. This comes in handy, for example, when you need to apply ACL for a user that may not exist in the system at the moment.
 @param email google email of the user
 @param successBlock CallBack in case of success. 'uid' will have the uid of the user.
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchUserUidForGoogleEmail:(NSString *)email onSuccess:(void (^) (NSString *uid))successBlock
                           onError:(void (^) (NSError *error))errorBlock;


/**
 @abstract Fetch user uid by providing tibbr user id
 @discussion This call will allow you to retrieve the uid for a user, whether or not the user exists. A means for identifying the user needs to be provided. This comes in handy, for example, when you need to apply ACL for a user that may not exist in the system at the moment.
 @param userId user id of the tibbr user
 @param host The host or endpoint of the tibbr installation
 @param successBlock CallBack in case of success. 'uid' will have the uid of the user.
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchUserUidForTibbrUserId:(NSString *)userId
                           andHost:(NSString *)host
                         onSuccess:(void (^) (NSString *uid))successBlock
                           onError:(void (^) (NSError *error))errorBlock;


/**
 @abstract Fetch user uid by providing facebook user id
 @discussion This call will allow you to retrieve the uid for a user, whether or not the user exists. A means for identifying the user needs to be provided. This comes in handy, for example, when you need to apply ACL for a user that may not exist in the system at the moment.
 @param userId Facebook user id
 @param successBlock CallBack in case of success. 'uid' will have the uid of the user.
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchUserUidForFacebookUserId:(NSString *)userId
                            onSuccess:(void (^) (NSString *uid))successBlock
                              onError:(void (^) (NSError *error))errorBlock;



/**
 @abstract activate a user.
 @param userId user id of the user to activate
 @param token activation token
 @param successBlock Callback in case of success. If the user is successfully activated, the success block will be called.
 @param errorBlock CallBack in case of failure.
 @discussion activate an application user.
*/
- (void)activateUserWithUserId:(NSString *)userId
            andActivationToken:(NSString *)token
                     onSuccess:(void (^) (void))successBlock
                       onError:(void (^) (NSError *error))errorBlock;


#pragma mark
#pragma mark Access tokens

/**---------------------------------------------------------------------------------------
 * @name Get access tokens
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract oauth token from twitter used to log a user into your application
 */
+ (NSString *)getTwitterOAuthToken;

/**
@abstract oauth token secret from twitter used to log a user into your application
*/
+ (NSString *)getTwitterOAuthTokenSecret;

/**
 @abstract access token from facebook used to log a user into your application
 */
+ (NSString *)getFacebookAccessToken;

/**
 @abstract oauth 2.0 access token from google used to log a user into your application
 */
+ (NSString *)getGoogleAccessToken;


#pragma mark
#pragma mark Application User Class Query

/**---------------------------------------------------------------------------------------
 * @name Querying User Class
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract Returns a BuiltQuery object for application users class
 @discussion Since this method returns an object of BuiltQuery class, all the methods of the BuiltQuery class are available and can be used to query the application user class of built.io. Use -getUsers method of QueryResult to get the list of users.
 */
+ (BuiltQuery *)getUsersQuery;

#pragma mark
#pragma mark Google Login UI

/**---------------------------------------------------------------------------------------
 * @name Google Login UI
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract Presents a login UI for Google Authentication
 @param controller view controller on which to present google login UI
 @param clientID client id of your installed application. You can get it from your google api console. https://code.google.com/apis/console
 @param clientSecret client secret of your installed application. You can get it from your google api console. https://code.google.com/apis/console
 @discussion Presents a UI for logging in with a google account. Useful when developing your custom login screen. Just use this method to present google login screen to capture user credentials and log in to your application using loginWithGoogleAuthAccessToken:onSuccess:onError:. Use GoogleLoginDelegate method to get the access token from google
 */
- (void)showGoogleLoginUIOnViewController:(UIViewController *)controller
                              forClientID:(NSString *)clientID
                          forClientSecret:(NSString *)clientSecret;

/**
 @abstract delegate for google login UI that provides methods for callback
 @discussion delegate for google login UI that provides methods for callback
 */
@property (nonatomic, strong) id<GoogleLoginDelegate> googleLoginDelegate;

@end