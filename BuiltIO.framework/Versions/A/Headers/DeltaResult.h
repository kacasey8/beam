//
//  DeltaResult.h
//  builtDemo
//
//  Created by Samir Bhide on 08/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
/** Helper class for parsing the result of BuiltDelta */
@interface DeltaResult : NSObject

/**
 @abstract Get array of updated objects returned by BuiltDelta.
 @return Returns an array of updated objects returned by BuiltDelta.
 */
- (NSMutableArray *)updatedObjects;


/**
 @abstract Get array of created objects returned by BuiltDelta.
 @return Returns an array of created objects returned by BuiltDelta.
 */
- (NSMutableArray *)createdObjects;


/**
 @abstract Get array of deleted objects returned by BuiltDelta.
 @return Returns an array of deleted objects returned by BuiltDelta.
 */
- (NSMutableArray *)deletedObjects;


/**
 @abstract Get array of all created/updated/deleted objects returned by BuiltDelta.
 @return Returns an array of created/updated/deleted objects returned by BuiltDelta.
 */
- (NSDictionary *)allObjects;

@end
