/*!
 @file		NSObject+PCLExtensions.h
 @brief		Extensions for the class NSObject
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

@interface NSObject (PCLExtensions)

#pragma mark - Validation
/*!
 @name Validation
 @{
 */
- (BOOL)pcl_isNSString;
- (BOOL)pcl_isNSURL;
- (BOOL)pcl_isNSURLOfTypeFile;
- (BOOL)pcl_isNSData;
- (BOOL)pcl_isUIImage;
- (BOOL)pcl_isNSDate;
- (BOOL)pcl_isNSDictionary;
- (BOOL)pcl_isNSArray;
- (BOOL)pcl_isNSNumber;
//!@}

- (NSString*)addressAsString;
@end
