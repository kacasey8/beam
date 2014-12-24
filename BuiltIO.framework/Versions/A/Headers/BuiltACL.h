//
//  BuiltACL.h
//  builtDemo
//
//  Created by Samir Bhide on 19/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltUser.h"

/** A BuiltACL is used to control which users can access or modify a particular object. Each BuiltObject can have its own BuiltACL. You can grant read and write permissions separately to specific users, to groups of users that belong to roles, or you can grant permissions to “the public” so that, for example, any user could read a particular object but only a particular set of users could write to that object. */

@interface BuiltACL : NSObject

@property (nonatomic, strong) NSMutableDictionary *aclDictionary;

/**---------------------------------------------------------------------------------------
 * @name Creating an ACL
 *  ---------------------------------------------------------------------------------------
 */
/**
    @abstract Creates an ACL with no permissions granted.
    @discussion Creates an ACL with no permissions granted.
    @return BuiltACL object.
 */
+ (BuiltACL *)ACL;

/**
 @abstract Creates an ACL with no permissions granted. Internally calls [BuiltACL ACL].
 @discussion Creates an ACL with no permissions granted.
 @return BuiltACL object.
 */
+ (BuiltACL *)init;

/**---------------------------------------------------------------------------------------
 * @name Disable ACL
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract Disables ACL on a particular BuiltObject.
 @discussion Disables ACL on a particular BuiltObject.
 @param disable When true disables ACL on BuiltObject, ables otherwise.
 */
- (void)disableACL:(BOOL)disable;

/**
 @abstract States whether ACL is enabled or disabled on BuiltObject.
 @discussion States whether ACL is enabled or disabled on BuiltObject.
 @return Returns true/YES if ACL is enabled, false/NO otherwise.
 */
- (BOOL)isDisabled;

/**---------------------------------------------------------------------------------------
 * @name Controlling Public Access
 *  ---------------------------------------------------------------------------------------
 */
/**
    @abstract Set whether the others is allowed to read this object.
    @discussion Set whether the public is allowed to read this object.
    @param allowed Whether read access is allowed (YES/TRUE or NO/FALSE).
 */
- (void)setPublicReadAccess:(BOOL)allowed;


/**
    @abstract Gets whether the others is allowed to read this object.
    @discussion Gets whether the public is allowed to read this object.
    @return Returns YES if read access is granted to others. NO otherwise.
 */
- (BOOL)getPublicReadAccess;


/**
    @abstract Set whether the others is allowed to write this object.
    @discussion Set whether the public is allowed to write this object.
    @param allowed Whether write access is allowed (YES/TRUE or NO/FALSE).
 
 */
- (void)setPublicWriteAccess:(BOOL)allowed;


/**
    @abstract Gets whether the others is allowed to write this object.
    @discussion Gets whether the public is allowed to write this object.
    @return Returns YES if write access is granted to others. NO otherwise.
 
 */
- (BOOL)getPublicWriteAccess;


/**
    @abstract Set whether the others is allowed to delete this object.
    @discussion Gets whether the public is allowed to delete this object.
    @param allowed Whether delete access is allowed (YES/TRUE or NO/FALSE).
 */
- (void)setPublicDeleteAccess:(BOOL)allowed;


/**
    @abstract Gets whether the others is allowed to delete this object.
    @discussion Gets whether the public is allowed to delete this object.
    @return Returns YES if delete access is granted to others. NO otherwise.
 */
- (BOOL)getPublicDeleteAccess;


/**---------------------------------------------------------------------------------------
 * @name Controlling Access Per-User
 *  ---------------------------------------------------------------------------------------
 */
/**
    @abstract Set whether the given user id is allowed to read this object.
    @discussion Set whether the given user id is allowed to read this object.
    @param allowed Whether read access is allowed (YES/TRUE or NO/FALSE).
    @param userId The user id to assign access.
 */
- (void)setReadAccess:(BOOL)allowed forUserId:(NSString *)userId;


/**
    @abstract Gets whether the given user id is explicitly allowed to read this object.
 Even if this returns NO, the user may still be able to access it if getPublicReadAccess returns YES
 or if the user belongs to a role that has access.
    @param userId User ID for which to check read access.
    @return Returns YES if read access is granted to others. NO otherwise.
 */
- (BOOL)getReadAccessForUserId:(NSString *)userId;


/**
 @abstract Set whether the given user id is allowed to write this object.
 @discussion Set whether the given user id is allowed to write this object.
 @param allowed Whether write access is allowed (YES/TRUE or NO/FALSE).
 @param userId The user id to assign access.
 */
- (void)setWriteAccess:(BOOL)allowed forUserId:(NSString *)userId;


/**
 @abstract Gets whether the given user id is explicitly allowed to write this object.
 Even if this returns NO, the user may still be able to access it if getPublicWriteAccess returns YES
 or if the user belongs to a role that has access.
 @param userId User ID for which to check write access.
 @return Returns YES if write access is granted to others. NO otherwise.
 */
- (BOOL)getWriteAccessForUserId:(NSString *)userId;


/**
 @abstract Set whether the given user id is allowed to delete this object.
 @discussion Set whether the given user id is allowed to delete this object.
 @param allowed Whether delete access is allowed (YES/TRUE or NO/FALSE).
 @param userId The user id to assign access.
 */
- (void)setDeleteAccess:(BOOL)allowed forUserId:(NSString *)userId;


/**
 @abstract Gets whether the given user id is explicitly allowed to delete this object.
 Even if this returns NO, the user may still be able to access it if getPublicDeleteAccess returns YES
 or if the user belongs to a role that has access.
 @param userId User ID for which to check delete access.
 @return Returns YES if delete access is granted to others. NO otherwise.
 */
- (BOOL)getDeleteAccessForUserId:(NSString *)userId;

/**---------------------------------------------------------------------------------------
 * @name Controlling Role Access
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract Gets whether the users with given role are explicitly allowed to read this object.
 Even if this returns NO, the user may still be able to access it if getPublicReadAccess returns YES
 or if the user belongs to a role that has access.
 @param role_uid Role UID for which to check read access.
 @return Returns YES if read access is granted to users with role. NO otherwise.
 */
- (BOOL)getRoleReadAccess:(NSString *)role_uid;


/**
 @abstract Gets whether the users with given role are explicitly allowed to write this object.
 Even if this returns NO, the user may still be able to access it if getPublicWriteAccess returns YES
 or if the user belongs to a role that has access.
 @param role_uid Role UID for which to check write access.
 @return Returns YES if write access is granted to users with role. NO otherwise.
 */
- (BOOL)getRoleWriteAccess:(NSString *)role_uid;


/**
 @abstract Gets whether the users with given role are explicitly allowed to delete this object.
 Even if this returns NO, the user may still be able to access it if getPublicDeleteAccess returns YES
 or if the user belongs to a role that has access.
 @param role_uid Role UID for which to check delete access.
 @return Returns YES if delete access is granted to users with role. NO otherwise.
 */
- (BOOL)getRoleDeleteAccess:(NSString *)role_uid;


/**
 @abstract Set whether the given users with role_uid are allowed to delete this object.
 @discussion Set whether the users with role_uid is allowed to read this object.
 @param allowed Whether read access is allowed (YES/TRUE or NO/FALSE).
 @param role_uid The role uid to assign access.
 */
- (void)setRoleReadAccess:(BOOL)allowed forRoleUID:(NSString *)role_uid;


/**
 @abstract Set whether the given users with role_uid are allowed to write this object.
 @discussion Set whether the users with role_uid is allowed to write this object.
 @param allowed Whether write access is allowed (YES/TRUE or NO/FALSE).
 @param role_uid The role uid to assign access.
 */
- (void)setRoleWriteAccess:(BOOL)allowed forRoleUID:(NSString *)role_uid;

/**
 @abstract Set whether the given users with role_uid are allowed to delete this object.
 @discussion Set whether the users with role_uid is allowed to delete this object.
 @param allowed Whether delete access is allowed (YES/TRUE or NO/FALSE).
 @param role_uid The role uid to assign access.
 */
- (void)setRoleDeleteAccess:(BOOL)allowed forRoleUID:(NSString *)role_uid;

@end
