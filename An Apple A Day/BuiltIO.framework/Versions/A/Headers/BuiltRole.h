//
//  BuiltRole.h
//  builtDemo
//
//  Created by Akshay Mhatre on 23/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltUser.h"
#import "BuiltObject.h"

@class BuiltQuery;
/** Roles are a sort of group containing users and other roles. So instead of giving permission to each user, could instead add those users to and assign permissions to the role. 
 All users in the role would inherit permissions that the role receives.
 */
@interface BuiltRole : BuiltObject

/**---------------------------------------------------------------------------------------
 * @name Create a BuiltRole Object.
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract Initializes a `BuiltRole` Object with a name.
 @param name the name for the role.
 */
+ (BuiltRole *)roleWithName:(NSString *)name;


/**
 @abstract Initializes a `BuiltRole` Object.
 */
+ (BuiltRole *)role;

/**
 @abstract Initializes a `BuiltRole` Object. Internally calls [BuiltRole init].
 */
+ (BuiltRole *)init;

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
 @param key key for which to remove the header value
 */
- (void)removeHeaderForKey:(NSString *)key;

/**
    @abstract If you require to fetch roles belonging to some other application, you can use this method to set the app parameters.
    @param apiKey api key of the app.
    @param uid appuid of the app.
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)uid;


/**
 @abstract Checks whether a role exists inside this role.
 @param roleUID The uid of the role.
 @return Returns whether the role exists or not.
 */
- (BOOL)hasRole:(NSString *)roleUID;

/**
 @abstract Checks whether a user exists inside this role.
 @param userUid The uid of the user.
 @return Returns whether the user exists or not.
 */
- (BOOL)hasUser:(NSString *)userUid;

/**
 @abstract query to fetch roles.
 @discussion Since this method returns an object of BuiltQuery class, all the methods of the BuiltQuery class are available and can be used to query the role class of built.io. Use -getRoles method of QueryResult to get the list of roles.
 @return returns a `BuiltQuery` for the role class.
 */
+ (BuiltQuery *)getRolesQuery;


/**
 @abstract Set the name for the role. This value must be set before the role has been saved, and cannot be set once the role has been saved. A role's name can only contain alphanumeric characters, _, -, and spaces.
 @param name name of the role.
 */
- (void)setName:(NSString *)name;


/**
 Get the name of the role.
 */
@property(nonatomic, strong, readonly)NSString *roleName;

/**
 Array of users that are included in a `BuiltRole`.
 */
@property(nonatomic, strong) NSMutableArray *users;

/**
 Array of other roles that are included in a `BuiltRole`. A role may have other roles included in it.
 */
@property(nonatomic, strong) NSMutableArray *roles;

/**
 @abstract Adds a user to a role
 @param userUid User's uid that needs to be added to the role.
 */
- (void)addUser:(NSString *)userUid;

/**
 @abstract Removes a user from a role
 @param userUid User's uid that needs to be removed from the role.
 */
- (void)removeUser:(NSString *)userUid;

/**
 @abstract Adds a role to this role.
 @param roleUid uid of the role that has to be added to this role.
 */
- (void)addRole:(NSString *)roleUid;

/**
 @abstract Removes a role from this role if it exists.
 @param roleUid uid of the role that has to be removed from this role.
 */
- (void)removeRole:(NSString *)roleUid;

@end
