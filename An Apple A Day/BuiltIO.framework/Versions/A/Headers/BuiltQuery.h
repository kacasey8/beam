//
//  BuiltQuery.h
//  builtDemo
//
//  Created by Akshay Mhatre on 19/02/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltObject.h"
#import "QueryResult.h"

@class BuiltObject;
/** A class that defines a query that is used to query for BuiltObjects.
 */
@interface BuiltQuery : NSObject

@property (nonatomic, strong)NSString *classUID;

#pragma mark
#pragma mark Create Query Object
// Creating a Query for a Class

/**---------------------------------------------------------------------------------------
 * @name Create a BuiltQuery Object.
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Initializes and returns a BuiltQuery instance for a class.
 @param classUID A Class UID for which Query has to be made.
 */
+ (BuiltQuery *)queryWithClassUID:(NSString *)classUID;

/**
 @abstract the response containing status code and all the raw HTTP response headers
 */
@property (strong, nonatomic, readonly) NSHTTPURLResponse *response;

#pragma mark
#pragma mark Add/Remove Optional Headers
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


/** --------------------------------------------------------------------------------------
 @name Set api key and app uid for another application
 -----------------------------------------------------------------------------------------
 */

/**
 @abstract If you require to retrieve object(s) belonging to some other application, you can use this method to set the app parameters
 @param apiKey api key of the app
 @param uid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)uid;


#pragma mark
#pragma mark Query Conditions

/**
 @abstract A custom dictionary can be provided to a query that can specify the conditions for retrieving objects.
 @param queryDict A dictionary with all the necessary conditions for retrieving objects.
 @discussion If a complex query needs to be performed and if it is difficult to specify it using the query methods, a dictionary can be provided that specifies all the conditions. The dictionary should be as per the JSON format specified in the REST API docs.
 */
- (void)customQuery:(NSDictionary *)queryDict;

/**
 @abstract use this method if you want only drafts to appear in the response of a query.
 */
- (void)onlyDrafts;

/**---------------------------------------------------------------------------------------
 * @name Adding Basic Constraints
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Add a constraint to the query that requires a particular key's object to be equal to the provided object.
 @param key The key to be constrained.
 @param object The object that must be equalled.
 
 */
- (void)whereKey:(NSString *)key equalTo:(id)object;

/**
 @abstract Add a constraint to the query that requires a particular key's object to be not equal to the provided object.
 @param key The key to be constrained
 @param object The object that must not be equalled.
 
 */
- (void)whereKey:(NSString *)key notEqualTo:(id)object;

/**
 @abstract Add a constraint to the query that requires a particular key's object to be less than the provided object.
 @param key The key to be constrained.
 @param object The object that provides an upper bound.
 
 */
- (void)whereKey:(NSString *)key lessThan:(id)object;


/**
 @abstract Add a constraint to the query that requires a particular key's object to be greater than the provided object.
 @param key The key to be constrained.
 @param object The object that must be equalled.
 
 */
- (void)whereKey:(NSString *)key greaterThan:(id)object;

/**
 @abstract Add a constraint to the query that requires a particular key's object to be less than or equal to the provided object.
 @param key The key to be constrained.
 @param object The object that must be equalled.
 
 */
- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object;

/**
 @abstract Add a constraint to the query that requires a particular key's object to be greater than or equal to the provided object.
 @param key The key to be constrained.
 @param object The object that must be equalled.
 
 */
- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object;

/**
 @abstract Add a constraint to the query that requires a particular key's object to be contained in the provided array.
 @param key The key to be constrained.
 @param array The possible values for the key's object.
 
 */
- (void)whereKey:(NSString *)key containedIn:(NSArray *)array;


/**
 @abstract Add a constraint to the query that requires a particular key's object not be contained in the provided array.
 @param key The key to be constrained.
 @param array The list of values the key's object should not be.
 
 */
- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array;


/**
 @abstract Add a constraint that requires a particular key exists.
 @param key The key to be constrained.
 
 */
- (void)whereKeyExists:(NSString *)key;


/**
 @abstract Add a constraint that requires a key not exist.
 @param key The key to be constrained.
 
 */
- (void)whereKeyDoesNotExist:(NSString *)key;

/**
 @abstract Add a regular expression constraint for finding string values that match the provided regular expression. This may be slow for large datasets.
 @discussion Add a regular expression constraint for finding string values that match the provided regular expression. This may be slow for large datasets.
 @param key The key to be constrained
 @param regex The regular expression pattern to match.
 
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex;


/**
 @abstract Add a regular expression constraint for finding string values that match the provided regular expression. This may be slow for large datasets.
 @discussion Add a regular expression constraint for finding string values that match the provided regular expression. This may be slow for large datasets.
 @param key The key to be constrained
 @param regex The regular expression pattern to match.
 @param modifier Any of the following supported Regex modifiers
 
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifier;

/**
 @abstract Add a constraint to the query that requires a particular key's object to be equal to the provided object.
 @param key The key to be constrained.
 @param selectQuery The select query to be performed on another class
 @param pickedKey the key for which the values should be returned after the select query is performed
 */
- (void)whereKey:(NSString *)key equalToResultOfSelectQuery:(BuiltQuery *)selectQuery forKey:(NSString *)pickedKey;


/**
 @abstract Add a constraint to the query that requires a particular key's object to be equal to the provided object.
 @param key The key to be constrained.
 @param dontSelectQuery The dont_select query to be performed on another class. This is the inverse of the select query. Returns all the objects that do not match the conditions.
 @param pickedKey the key for which the values should be returned after the dont_select query is performed
 */
- (void)whereKey:(NSString *)key equalToResultOfDontSelectQuery:(BuiltQuery *)dontSelectQuery forKey:(NSString *)pickedKey;

/**
 @abstract Specifies an array of 'only' keys in BASE object that would be included in the response.
 @discussion Specifies an array of keys in BASE object that would be included in the response.
 @param fieldUIDs Array of the 'only' keys to be included in response.
 
 */
- (void)includeOnlyFields:(NSArray *)fieldUIDs;

/**
 @abstract Specifies an array of keys in reference class object that would be 'excluded' from the response.
 @discussion Specifies an array of keys in BASE object that would be 'excluded' from the response.
 @param fieldUIDs Array of keys to be excluded from the response.
 
 */
- (void)includeAllFieldsExcept:(NSArray *)fieldUIDs;


#pragma mark
#pragma mark Before/After UID

/**---------------------------------------------------------------------------------------
 * @name Objects Before/After UID
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Returns objects before specified UID.
 @discussion Returns objects before specified UID from set of objects returned in response.
 @param uid UID before which objects should be returned.
 
 */
- (void)beforeUID:(NSString *)uid;


/**
 @abstract Returns objects after specified UID.
 @discussion Returns objects after specified UID from set of objects returned in response.
 @param uid UID after which objects should be returned.
 
 */
- (void)afterUID:(NSString *)uid;


#pragma mark
#pragma mark Pagination

/**---------------------------------------------------------------------------------------
 * @name Paginating Results
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract A limit on the number of objects to return.
 @discussion The limit parameter can be used for pagination. "limit" specifies the number of objects to limit to in the response.
 @param number No of objects to limit.
 
 */
- (void)limitObjects:(NSNumber *)number;


/**
 @abstract The number of objects to skip before returning any.
 @discussion The skip parameter can be used for pagination. "skip" specifies the number of objects to skip in the response.
 @param number No of objects to skip from returned objects.
 
 */
- (void)skipObjects:(NSNumber *)number;


#pragma mark
#pragma mark include

/**
 @abstract Gives only the count of objects returned in response.
 @discussion Gives only the count of objects returned in response.
 */
- (void)objectsCount;

/**
 @abstract Include all unpublished objects of a class.
 @discussion The "include_unpublished" parameter, when set to "true", also includes all the objects that are unpublished (published=false).
 */
- (void)includeDrafts;

/**
 @abstract Includes schemas of all returned objects alongwith objects themselves.
 @discussion When set to "true", this parameter allows you to include the schema portion of your class in the objects response.
 */
- (void)includeSchema;

/**
 @abstract Include the owner's profile in the objects' data.
 @discussion When set to "true", the returned objects will also contain a key "_owner", which will include the owner's profile in the objects' data.
 */
- (void)includeOwner;

/**---------------------------------------------------------------------------------------
 * @name Counting the Matches in a Query
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Gives object count alongwith objects returned in response.
 @discussion Gives object count alongwith objects returned in response.
 */
- (void)includeCount;



#pragma mark
#pragma mark Order

/**---------------------------------------------------------------------------------------
 * @name Sorting
 *  ---------------------------------------------------------------------------------------
 */


/**
 @abstract Sort the results in ascending order with the given key.
 @discussion The asc parameter will sort the returned objects in ascending order of the provided field uid.
 @param key The key to order by.
 
 */
- (void)orderByAscending:(NSString *)key;


/**
 @abstract Sort the results in descending order with the given key.
 @discussion The desc parameter will sort the returned objects in descending order of the provided field uid.
 @param key The key to order by.
 
 */
- (void)orderByDescending:(NSString *)key;



#pragma mark
#pragma mark Query Conditions on Reference fields

/**---------------------------------------------------------------------------------------
 * @name Referential Queries
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract perform query based on referred objects
 @discussion fetch objects for a class by querying the fields in the referred object. Use inQuery if you want to fetch objects that match the conditions specified. Can be used for nested references.(referred object inside referred object and so on)
 @param query the query to perform on the referred object
 @param key the key of the referred object
 */
- (void)inQuery:(BuiltQuery *)query forKey:(NSString *)key;


/**
 @abstract perform query based on referred objects
 @discussion fetch objects for a class by querying the fields in the referred object. Use notinQuery if you want to fetch objects that do not match the conditions specified (negation of inQuery). Can be used for nested references.(referred object inside referred object and so on)
 @param query the query to perform on the referred object
 @param key the key of the referred object
 */
- (void)notinQuery:(BuiltQuery *)query forKey:(NSString *)key;


/**
 @abstract Include reference objects with given key in response
 @discussion The include parameter accepts the name of a reference field. By default, no reference field is bought along with the object, only the uids are. To include any reference, this parameter must be used. Nested references can be bought by "." separating the references. This will work for references which are nested inside groups or references which are nested inside other references.
 @param key Array of reference keys to include in response.
 
 */
- (void)includeRefFieldWithKey:(NSArray *)key;


/**
 @abstract Specifies an array of 'only' keys in reference class object that would be included in the response.
 @discussion Specifies an array of keys in reference class object that would be included in the response.
 @param key Key who has reference to some other class object.
 @param values Array of the 'only' reference keys to be included in response.
 
 */
- (void)includeRefFieldWithKey:(NSString *)key andOnlyRefValuesWithKeys:(NSArray *)values;


/**
 @abstract Specifies an array of keys in reference class object that would be 'excluded' from the response.
 @discussion Specifies an array of keys in reference class object that would be 'excluded' from the response.
 @param key Key who has reference to some other class object.
 @param values Array of the 'only' reference keys to be 'excluded' from the response.
 
 */
- (void)includeRefFieldWithKey:(NSString *)key excludingRefValuesWithKeys:(NSArray *)values;


#pragma mark
#pragma mark geo location queries

/**
 @abstract fetch objects that are near a specified location within a given radius
 @param location the location near which you wish to query. Location can be an object of `BuiltLocation` or an object uid. In the latter case, it will use the object's location.
 @param radius the radius within which you wish to query
 */
- (void)nearLocation:(id)location withRadius:(double)radius;


/**
 @abstract fetch objects that are within specified locations.
 @param locations an array of locations. Locations can have objects of `BuiltLocation` or object uids. If object uid is passed, the location of that object will be used.
 At least three locations need to be passed so that the search area is a polygon.
 */
- (void)withinLocations:(NSArray *)locations;


#pragma mark
#pragma mark tags

/**
 @abstract Include Tags with which to search objects
 @discussion The "tags" parameter allows you to specify a comma-seperated list of tags with which to search objects.
 @param tags Comma separated array of tags with which to search objects.

 */
- (void)whereTagsEqualTo:(NSArray *)tags;

/**
 @abstract fetch all the tags for a class
 @param successBlock an array of tags
 @param errorBlock callBack in case of failure
 */
- (void)fetchAllTagsOnSuccess:(void(^)(NSArray *tags))successBlock
                      onError:(void (^)(NSError *error))errorBlock;
#pragma mark
#pragma mark AND OR

/**
 @abstract Accepts an array of queries, and ORs them.
 @discussion The query object on which you call this method will be OR of the passed queries.
 @param queries Array of `BuiltQuery`s to apply OR on.
 */
- (void)orWithSubqueries:(NSArray *)queries;


/**
 @abstract Accepts an array of queries, and ANDs them.
 @discussion The query object on which you call this method will be AND of the passed queries.
 @param queries Array of `BuiltQuery`s to apply AND on.
 */
- (void)andWithSubqueries:(NSArray *)queries;


#pragma mark
#pragma mark additional Options

/**
 @abstract Include custom query using a key and a value.
 @discussion Include custom query using a key and a value.
 @param key name of the query.
 @param value value for the query.
 */
- (void)addQueryWithKey:(NSString *)key andValue:(NSString *)value;

/**
 @abstract Remove provided query key from custom query if exist.
 @param key Query name to remove.
 */
-(void)removeQuery:(NSString *)key;

#pragma mark
#pragma mark Clear Query Conditions

/**---------------------------------------------------------------------------------------
 * @name Cancelling a Query
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract cancel ongoing network requests if any
 */
- (void)cancel;


#pragma mark
#pragma mark Caching Query

/**---------------------------------------------------------------------------------------
 * @name Query Cache Policy
 *  ---------------------------------------------------------------------------------------
 */
/**
    @abstract Different Cache Policies
    @discussion Built.IO provides various cache policies allowing access to data with various approaches.
 */
typedef enum{
    IGNORE_CACHE = 0,
    CACHE_ONLY,
    NETWORK_ONLY,
    CACHE_ELSE_NETWORK,
    NETWORK_ELSE_CACHE,
    CACHE_THEN_NETWORK
}CachePolicy;

/**
 @abstract Response Type (Cache, Network)
 @discussion Defines the origin of the response. Whether it is from cache or network.
 */
typedef enum{
    CACHE = 0,
    NETWORK
}ResponseType;


/**
    @abstract The Cache Policy to be adopted. Defaults to IGNORE_CACHE.
 */
@property (nonatomic, assign) CachePolicy cachePolicy;


/**
    @abstract Enum for origin of response data. Whether it is from cache or network.
 */
@property (nonatomic, assign) ResponseType responseType;


/**
 @abstract The timeout interval of the cache. Defaults to 24 hours.
 */
@property (nonatomic, assign) double timeoutInterval;


/**
 @abstract set the cache policy globally. This policy will be followed by every query that is executed.
 @param policy The cache policy to be adopted throughout the application. You can always override this by setting the `cachePolicy` of a particular query object.
 */
+(void)setGlobalCachePolicy:(CachePolicy)policy;

#pragma mark
#pragma mark Execute Query

/**---------------------------------------------------------------------------------------
 * @name Execute Query
 *  ---------------------------------------------------------------------------------------
 */

/**
 @abstract Execute a Query
 @discussion Executes a single or a chained query and callbacks the `QueryResult` with `ResponseType`.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)exec:(void (^) (QueryResult *result, ResponseType type))successBlock onError:(void (^) (NSError *error, ResponseType type))errorBlock;

@end

