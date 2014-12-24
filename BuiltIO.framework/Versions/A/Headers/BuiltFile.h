//
//  BuiltFile.h
//  builtDemo
//
//  Created by Akshay Mhatre on 26/02/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BuiltACL.h"

#if TARGET_OS_IPHONE
typedef void (^BuiltImageBlock) (UIImage *image);
#elif TARGET_OS_MAC
typedef void (^BuiltImageBlock) (NSImage *image);
#endif

/**BuiltFile class to upload multiple images and files to built.io*/
@interface BuiltFile : NSObject{
}

/**----------------------------------------------------------------------------------------
 * @name Properties
 *-----------------------------------------------------------------------------------------
 */
/**
 @abstract the filename of the uploaded file
 */
@property (nonatomic, strong) NSString *filename;

/**
 @abstract the filesize of the uploaded file
 */
@property (nonatomic, assign) unsigned int filesize;

/**
 @abstract the contentType of the uploaded file
 */
@property (nonatomic, strong) NSString *contentType;

/**
 @abstract the uid of the uploaded file
 */
@property (nonatomic, strong) NSString *uid;

/**
 @abstract the tags associated with the uploaded file
 */
@property (nonatomic, strong) NSArray *tags;

/**
 @abstract the ACL applied to the uploaded file
 */
@property (nonatomic, strong) BuiltACL *ACL;

/**
 @abstract the url of the uploaded file
 */
@property (nonatomic, strong) NSString *url;

/**
 @abstract Gives total count of the objects if includeCount method is called.
 */
@property (nonatomic, assign) NSInteger totalCount;



/**----------------------------------------------------------------------------------------
 * @name Caching images/files
 *-----------------------------------------------------------------------------------------
 */
/**
 @abstract allow/disallow caching for all images downloaded.
 @param imageCache YES to allow caching. You can always override this by setting the `imageCache` property of a particular file object.
 */
+ (void)setGlobalImageCache:(BOOL)imageCache;

/**
 @abstract allow/disallow caching for all files downloaded.
 @param fileCache YES to allow caching. You can always override this by setting the `fileCache` property of a particular file object.
 */
+ (void)setGlobalFilesCache:(BOOL)fileCache;

/**
 @abstract enable/disable image caching. By default image caching is enabled.
 @param cache YES to allow image caching.
 */
- (void)setImageCache:(BOOL)cache;

/**
 @abstract enable/disable file caching. By default file caching is enabled.
 @param cache YES to allow file caching.
 */
- (void)setFileCache:(BOOL)cache;

/**---------------------------------------------------------------------------------------
 * @name Save files with built.io
 *  ---------------------------------------------------------------------------------------
 */
/**
 @abstract Upload one or more images/files to built.io
 @param successBlock callback when the file is successfully uploaded.
 @param errorBlock CallBack in case of failure.
 */
- (void)saveOnSuccess:(void (^)(void))successBlock
              onError:(void (^)(NSError *error))errorBlock;

/**
 @abstract the response containing status code and all the raw HTTP response headers
 */
@property (strong, nonatomic, strong) NSHTTPURLResponse *response;

/**---------------------------------------------------------------------------------------
 * @name Creating a BuiltFile Object
 *  ---------------------------------------------------------------------------------------
 */

/**
    @abstract BuiltFile class to upload multiple images and files in built.io
    @return Returns BuiltFile object.
 */
+ (BuiltFile *)file;

/**
 @abstract BuiltFile class to upload multiple images and files in built.io. Internally calls [BuiltFile file].
 @return Returns BuiltFile object.
 */
+ (BuiltFile *)init;


/**
 @abstract Use this method to create an object from the JSON response received for a file field in a BuiltObject.
 @param builtFileResponse the JSON response with which to initialize the object.
 @return Returns BuiltFile object initialized with the JSON response received.
 */
+ (BuiltFile *)builtFileWithResponse:(NSDictionary *)builtFileResponse;

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
 @abstract If you require to upload file/fetch file details belonging to some other application, you can use this method to set the app parameters
 @param apiKey api key of the app
 @param uid appuid of the app
 */
- (void)setApplicationApiKey:(NSString *)apiKey andUid:(NSString *)uid;


/** --------------------------------------------------------------------------------------
 @name Fetch uploads
 -----------------------------------------------------------------------------------------
 */
/**
 @abstract fetch all the uploads
 @param successBlock an array of `BuiltFile`s
 @param errorBlock callBack in case of failure
 */
- (void)fetchAllOnSuccess:(void (^)(NSArray *allFiles))successBlock
                   onError:(void (^)(NSError *error))errorBlock;

/**
 @abstract fetch all the images
 @param successBlock an array of `BuiltFile`s
 @param errorBlock callBack in case of failure
 */
- (void) fetchImagesOnSuccess:(void (^)(NSArray *allImages))successBlock
                      onError:(void (^)(NSError *error))errorBlock;

/**
 @abstract fetch all the videos
 @param successBlock an array of `BuiltFile`s
 @param errorBlock callBack in case of failure
 */
- (void) fetchVideosOnSuccess:(void (^)(NSArray *allVideos))successBlock
                      onError:(void (^)(NSError *error))errorBlock;

/**
 @abstract fetch all the tags for uploads
 @param successBlock an array of tags
 @param errorBlock callBack in case of failure
 */
- (void)fetchAllTagsOnSuccess:(void(^)(NSArray *tags))successBlock
                      onError:(void (^)(NSError *error))errorBlock;


/**
 @abstract Fetches a file when provided UID.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)fetchonSuccess:(void (^) (void))successBlock
               onError:(void (^)(NSError *error))errorBlock;

/**--------------------------------------------------------------------------------------
 @name Paginating results
 -----------------------------------------------------------------------------------------
 */
/**
 @abstract The number of objects to skip before returning any.
 @discussion The skip parameter can be used for pagination. "skip" specifies the number of objects to skip in the response.
 @param number No of objects to skip from returned objects.
 */
- (void)skipObjects:(NSNumber *)number;

/**
 @abstract A limit on the number of objects to return.
 @discussion The limit parameter can be used for pagination. "limit" specifies the number of objects to limit to in the response.
 @param number No of objects to limit.
 */
- (void)limitObjects:(NSNumber *)number;


/**--------------------------------------------------------------------------------------
 @name Include total count of objects
 -----------------------------------------------------------------------------------------
 */
/**
 @abstract Gives total object count alongwith objects returned in response. Access totalCount property to get the count.
 */
- (void)includeCount;

/**
 @abstract Gives total object count only. No uploads are returned. Access totalCount property to get the count.
 */
- (void)count;

/** --------------------------------------------------------------------------------------
 @name Cancel
 -----------------------------------------------------------------------------------------
 */
/**
 @abstract cancel ongoing file uploading network requests
 */
- (void)cancel;


/**--------------------------------------------------------------------------------------
 @name Add file/data/image for uploading
 -----------------------------------------------------------------------------------------
 */

/**
 @abstract Add file to be uploaded
 @param filePath path of the file from NSBundle
 @param key add file against a key.
 */
- (void)setFile:(NSString *)filePath forKey:(NSString *)key;


/**
 @abstract Add data to be uploaded
 @param data `NSData` representation of any object to be uploaded
 @param key add data against a key.
 */
- (void)setData:(NSData *)data forKey:(NSString *)key;


/**
 @abstract Add image to be uploaded
 @param image `UIImage` object to be uploaded
 @param key add image against a key.
 */
- (void)setImage:(UIImage *)image forKey:(NSString *)key;


/**
 @abstract Deletes the upload with specified UID.
 @param successBlock CallBack in case of success.
 @param errorBlock CallBack in case of failure.
 */
- (void)destroyOnSuccess:(void (^) (void))successBlock
                 onError:(void (^) (NSError *error))errorBlock;


/**
 @abstract if an upload contains an image, use this method to download the image.
 @param successBlock on successful download, the success block contains the UIImage object.
 @param errorBlock in case of errors, this block is called.
 */
- (void)downloadImageOnCompletion:(BuiltImageBlock)successBlock onError:(void(^)(NSError *error))errorBlock;

/**
 @abstract if an upload contains a file other than image, use this method to download the file.
 @param successBlock on successful download, the success block contains the NSData object.
 @param errorBlock in case of errors, this block is called.
 */
- (void)downloadDataOnCompletion:(void(^)(NSData *data))successBlock onError:(void(^)(NSError *error))errorBlock;

@end
