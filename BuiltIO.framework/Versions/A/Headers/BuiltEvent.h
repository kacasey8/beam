//
//  BuiltEvent.h
//  builtDemo
//
//  Created by Akshay Mhatre on 10/07/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 event class object that you will pass to BuiltAnalytics for tracking
 */
@interface BuiltEvent : NSObject

/**---------------------------------------------------------------------------------------
 * @name Properties
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract uid of the event
 */
@property (nonatomic, strong) NSString *eventUid;

/**
 @abstract uid of the previous event. Useful for funneling.
 */
@property (nonatomic, strong) NSString *previousEventUid;

/**
 @abstract Properties will allow you to segment your events in your BuiltAnalytics reports.
 Property keys must be <code>NSString</code> objects and values must be
 <code>NSString</code>, <code>NSNumber</code>, <code>NSNull</code>,
 <code>NSArray</code>, <code>NSDictionary</code>, <code>NSDate</code> or
 <code>NSURL</code> objects.
 */
@property (nonatomic, strong) NSDictionary *properties;

@end
