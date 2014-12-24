//
//  BuiltLocation.h
//  builtDemo
//
//  Created by Akshay Mhatre on 27/07/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Location class for creating a location object that can be used to set location on objects using setLocation: method.
 Also, you can query objects on the basis of their geo locations where `BuiltLocation` is required to specify a location parameter.
 */

@interface BuiltLocation : NSObject

/**
 longitude of the location in degrees
 */
@property (nonatomic, assign) double longitude;


/**
 latitude of the location in degrees
 */
@property (nonatomic, assign) double latitude;


/**
 @abstract returns a `BuiltLocation` object for the given longitude and latitude
 @param longitude longitude of the location in degrees
 @param latitude latitude of the location in degrees
 @return `BuiltLocation` object with the given longitude and latitude
 */
+ (BuiltLocation *)locationWithLongitude:(double)longitude andLatitude:(double)latitude;


/**
 @abstract returns a `BuiltLocation` object for the current longitude and latitude
 @param successBlock will have the `BuiltLocation` object with current longitude and latitude.
 @param errorBlock will have an `NSError` object in case the current location was not available.
 */
+ (void)currentLocationOnSuccess:(void (^) (BuiltLocation *currentLocation))successBlock onError:(void (^) (NSError *error))errorBlock;

@end

