/*!
 @file		NSObject+PCLExtensions.m
 @brief		Extensions for the class NSObject
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "NSObject+PCLExtensions.h"

@implementation NSObject (PCLExtensions)

#pragma mark - Validation

- (BOOL)pcl_isNSString {

	return [self isKindOfClass:[NSString class]];
}

- (BOOL)pcl_isNSURL {

	return [self isKindOfClass:[NSURL class]];
}

- (BOOL)pcl_isNSURLOfTypeFile {

	return [self isKindOfClass:[NSURL class]] && [(NSURL*)self isFileURL];
}

- (BOOL)pcl_isNSData {

	return [self isKindOfClass:[NSData class]];
}

- (BOOL)pcl_isUIImage {

	return [self isKindOfClass:[UIImage class]];
}

- (BOOL)pcl_isNSDate {

	return [self isKindOfClass:[NSDate class]];
}

- (BOOL)pcl_isNSDictionary {

	return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)pcl_isNSArray {

	return [self isKindOfClass:[NSArray class]];
}

- (BOOL)pcl_isNSNumber {

	return [self isKindOfClass:[NSNumber class]];
}

- (NSString*)addressAsString {

	NSString * hexAddress = [NSString stringWithFormat:@"%p", self];
	return hexAddress;
}

@end
