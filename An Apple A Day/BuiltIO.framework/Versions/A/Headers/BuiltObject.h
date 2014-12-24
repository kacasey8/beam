//
//  BuiltObject.h
//  builtDemo
//
//  Created by Akshay Mhatre on 18/02/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltACL.h"
#import "BuiltLocation.h"

/** Create, Retrieve, Update, Delete objects using BuiltObject class */
@interface BuiltObject : NSObject


/**
 @abstract Returns an array of `BuiltObject`s for the specified reference key
 @discussion Use this method to retrieve `BuiltObject`s when using includeRefFieldWithKey: method of `BuiltQuery`. The reference field key may have an array of objects or a single object. This method will return the `BuiltObject`s for the included reference field.
 @param key the reference field key
 @param classUID set the class uid of the class to which the object(s) belongs
 @return An array of `BuiltObject`s for the specified key
 */
- (NSArray *)getAllObjectsForKey:(NSString *)key withClassUID:(NSString *)classUID;
/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract The uid of the object
 */
@property(nonatomic, strong)NSString *uid;

/**
 @abstract The class uid of the object
 */
@property(nonatomic, strong)NSString *classUID;

/**
 @abstract The ACL for the object
 */
@property (nonatomic, retain) BuiltACL *ACL;

/**
 @abstract the response containing status code and all the raw HTTP response headers
 */
@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;

#pragma mark
#pragma mark create object

/**---------------------------------------------------------------------------------------
 * @name Creating BuiltObject
 *  ---------------------------------------------------------------------------------------
 */

/** 
    @abstract Create a new BuiltObject of a class
    @param classUID of the class that is created using Web UI
    @return BuiltObject of the class with the provided classUID
 */
+ (BuiltObject *)objectWithClassUID:(NSString *)classUID;


#pragma mark
#pragma mark Add/Remove Optional Headers

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
    @abstract If you require to create/retrieve/update an object belonging to some other application, you can use this method to set the app parameters
    @param apiKey api key of the app
    @param appUid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)appUid;


/** --------------------------------------------------------------------------------------
 @name Actions
 -----------------------------------------------------------------------------------------
 */

#pragma mark
#pragma mark set tags

/**
 @abstract add tag(s) while saving object
 @param tags an array of tag(s)
 */
- (void)setTags:(NSArray *)tags;


#pragma mark
#pragma mark set values for reference fields

/**
 @abstract set object/UID for reference field
 @param reference This can either be a UID of a referenced object or an instance of BuiltObject.
 @param key for which you are setting the object
 */
- (void)setReference:(id)reference forKey:(NSString *)key;

/**
 @abstract set object for reference field where the dictionary matches the objects of the referred class
 @param dictionary This is the dictionary against which the matching objects are set for the reference field. For example you can pass the dictionary like this:
 @{@"uid": @"bltxxxxxxxxxxxxxxxxx"}
 In this case, the object with uid bltxxxxxxxxxxxxxxxxx will be set for the reference field
 @param key The key for which you are setting the object
 @discussion All the key value pairs are checked for and the objects matching the condition(s) are attached to the reference field.
 */
- (void)setReferenceWhere:(NSDictionary *)dictionary forKey:(NSString *)key;


#pragma mark
#pragma mark Update/Insert

/**
 @abstract update or insert.
 @param dictionary A check will be performed, whether any object has the key value pair(s) supplied in the dictionary
 @discussion The key value pair(s) are searched for and if an existing object is found containing those pair(s), it is updated else a new object is created(when the object is saved).
 */
- (void)upsert:(NSDictionary *)dictionary;

/**
 @abstract
 @param dictionary A check will be performed, whether any object has the key value pair(s) supplied in the dictionary in the reference field.
 @param refField reference field on which UPSERT is to be performed.
 @param newDict new key value pairs for the fields inside the referenced object.
 @discussion use this method only when the values of the fields inside referenced object are to be changed while creating a new object
 */
- (void)upsert:(NSDictionary *)dictionary forRefField:(NSString *)refField newDictionary:(NSDictionary *)newDict;


#pragma mark
#pragma mark timeless

/**
 @abstract issue a timeless update. The date of creation, updation will not change
 */
- (void)setTimeless;


#pragma mark
#pragma mark set values for object's fields

/**
 @abstract set value for the given key
 @param object the object to set
 @param key the key(field uid in your class)
 */
- (void)setObject:(id)object forKey:(NSString *)key;


/**
 @abstract set location for an object
 @param location an object of `BuiltLocation`
 */
- (void)setLocation:(BuiltLocation *)location;

#pragma mark
#pragma mark operations on fields of multiple type

/**
 @abstract add a value at a particular index to a field that allows multiple values
 @param value value to enter in field
 @param index index at which value is to be added
 @param key uid of the field
 */
- (void)pushValue:(id)value atIndex:(NSInteger)index forKey:(NSString *)key;

/**
 @abstract add a value to a field that allows multiple values
 @param value value to enter in field
 @param key uid of the field
 */
- (void)pushValue:(id)value forKey:(NSString *)key;

/**
 @abstract delete a value from a field that allows multiple values
 @param index index at which the value is to be deleted
 @param key uid of the field
 */
- (void)pullValueAtIndex:(NSInteger)index forKey:(NSString *)key;

/**
 @abstract delete a value from a field that allows multiple values
 @param value value or array of values to enter in field
 @param key uid of the field
 */
- (void)pullValue:(id)value forKey:(NSString *)key;


/**
 @abstract update a value in a field that allows multiple values
 @param updatedValue new value to be updated
 @param index index at which the value is to be updated
 @param key uid of the field
 */
- (void)updateValue:(id)updatedValue atIndex:(NSInteger)index forKey:(NSString *)key;


#pragma mark
#pragma mark increment, decrement, multiply, divide

/**
 @abstract increment the given key(number field) by 1
 @param key the key to increment
 */
- (void)incrementKey:(NSString *)key;

/**
 @abstract increment the given key(number field) by given number
 @param key the key to increment
 @param number by how much amount to increment
 */
- (void)incrementKey:(NSString *)key by:(NSNumber *)number;

/**
 @abstract decrement the given key(number field) by 1
 @param key the key to decrement
 */
- (void)decrementKey:(NSString *)key;

/**
 @abstract decrement the given key(number field) by given number
 @param key the key to decrement
 @param number by how much amount to decrement
 */
- (void)decrementKey:(NSString *)key by:(NSNumber *)number;

/**
 @abstract multiply the given key(number field) by a given number
 @param key the key to be multiplied by
 @param number the number by which to multiply
 */
- (void)multiplyKey:(NSString *)key by:(NSNumber *)number;

/**
 @abstract divide the given key(number field) by a given number
 @param key the key to be divided by
 @param number the number by which to divide
 */
- (void)divideKey:(NSString *)key by:(NSNumber *)number;


#pragma mark
#pragma mark Object fetch

/**
 @abstract Fetches an object provided object UID and class UID
 @discussion Fetches an object provided object UID and class UID.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchonSuccess:(void (^) (void))successBlock
               onError:(void (^)(NSError *error))errorBlock;

/**
 @abstract Fetches and returns class's schema
 @discussion Fetches and returns class's schema.
 @param successBlock Returns schema in callback on success
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchSchemaOnSuccess:(void (^) (id schema))successBlock onError:(void (^) (NSError *error))errorBlock;


#pragma mark
#pragma mark Object save

/**
 @abstract save an object as draft so that it is not visible unless explicitly called for. see [including drafts]([BuiltQuery includeDrafts])
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)saveAsDraftOnSuccess:(void (^) (void))successBlock onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract Saves the BuiltObject to built.io servers
 @discussion Saves the BuiltObject.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)saveOnSuccess:(void (^) (void))successBlock onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract Saves the BuiltObject as draft if network is unavailable. Resumes when network becomes available.
 @discussion Saves the BuiltObject as draft if network is unavailable. Resumes when network becomes available.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)saveEventuallyOnSuccess:(void (^) (void))successBlock onError:(void (^) (NSError *error))errorBlock;


#pragma mark
#pragma mark Object delete

/**
 @abstract Deletes the BuiltObject with specified object UID.
 @discussion Deletes the BuiltObject.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)destroyOnSuccess:(void (^) (void))successBlock onError:(void (^) (NSError *error))errorBlock;

/**
 @abstract Deletes the BuiltObject with specified object UID. Drafts the operation if network is unavailable. Resumes after network is back.
 @discussion Deletes the BuiltObject with specified object UID. Drafts the operation if network is unavailable. Resumes after network is back.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)destroyEventuallyOnSuccess:(void (^) (void))successBlock onError:(void (^) (NSError *error))errorBlock;


#pragma mark
#pragma mark access object values

/** ---------------------------------------------------------------------------------------
 @name Helpers
 ------------------------------------------------------------------------------------------
 */

/** 
    @abstract check if the object is new or present on server
    @return YES if new, NO if not
 */
- (BOOL)isNew;

/**
 @abstract check if key exists in an object
 @param key the key(field uid in your class)
 @return YES if key exists, NO if not
 */
- (BOOL)hasKey:(NSString *)key;


/** --------------------------------------------------------------------------------------
 @name Accesor
 -----------------------------------------------------------------------------------------
 */

/**
 @abstract get value for the given key
 @param key the key(field uid in your class)
 @return the value for the key provided
 */
- (id)objectForKey:(NSString *)key;


/**
 @abstract get location of an object
 @return `BuiltLocation` object with the longitude and latitude of the object
 */
- (BuiltLocation *)getLocation;


/**
 @abstract get the count of objects
 @return count of objects
 */
- (NSInteger)getCount;

#pragma mark
#pragma mark object owner

/**
 @abstract returns if the object has owner
 @return YES if object has owner else NO
 */
- (BOOL)hasOwner;

/**
 @abstract returns owner if the object has owner
 @return owner of the object
 @discussion it is advisable to use hasOwner to check if an object has owner before using this method
 */
- (id)owner;

/**
 @abstract get the UID of the owner of the object
 @return UID of the owner
 @discussion it is advisable to use hasOwner to check if an object has owner before using this method
 */
- (NSString *)ownerUID;

/**
 @abstract get the email of the owner of the object
 @return email of the owner of the object
 @discussion it is advisable to use hasOwner to check if an object has owner before using this method
 */
- (NSString *)ownerEmail;


#pragma mark
#pragma mark Additional Options

/**
 @abstract Include the owner's profile in the objects' data.
 @discussion The returned objects will also contain a key "_owner", which will include the owner's profile in the object's data.
 */
- (void)includeOwner;


/**
 @abstract Gives object count alongwith the object returned in response.
 @discussion Gives object count alongwith the object returned in response.
 */
- (void)includeCount;

/**
 @abstract Include custom query using a key and a value.
 @discussion Include custom query using a key and a value.
 @param key name of the query.
 @param value value for the query.
 */
- (void)addQueryWithKey:(NSString *)key andValue:(id)value;

@end
