//
//  QueryResult.h
//  builtDemo
//
//  Created by Samir Bhide on 07/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
/** Helper class for parsing the result of BuiltQuery */
@interface QueryResult : NSObject

- (id)initWithObjectDictionary:(NSDictionary *)responseDict;

/**
    @abstract Get array of objects returned by BuiltQuery.
    @return Returns an array of objects returned by BuiltQuery.
 */
- (NSMutableArray *)getResult;


/**
 @abstract Get array of roles returned by BuiltQuery.
 @return Returns an array of roles returned by BuiltQuery.
 */
- (NSMutableArray *)getRoles;

/**
 @abstract Get array of users returned by BuiltQuery.
 @return Returns an array of users returned by BuiltQuery.
 */
- (NSMutableArray *)getUsers;

/**
 @abstract Count of number of object returned by BuiltQuery alongwith objects themselves.
 @return Returns the count of number of object returned by BuiltQuery.
 */
- (NSInteger)totalCount;


/**
 @abstract Gets the schema of objects returned by BuiltQuery alongwith objects themselves.
 @return Returns schemas.
 */
- (NSArray *)schema;

/**
 @abstract Count of number of object returned by BuiltQuery.
 @return Returns the count of number of object returned by BuiltQuery.
 */
- (NSInteger)count;
//
@property (nonatomic, readonly, assign) NSInteger count;

@end
