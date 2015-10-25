/*!
 @file		NSData+PCLExtensions.m
 @brief		Extensions for the class NSData
 @author	Stefan Herold
 @date		2015-07-29
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "NSData+PCLExtensions.h"
#import "UIDevice+PCLExtensions.h"


@implementation NSData (PCLExtensions)


#pragma mark - Encoding and Decoding Base64

- (NSString *)pcl_encodedBase64String
{
	NSString * base64EncodedString = nil;
    base64EncodedString = [self base64EncodedStringWithOptions:kNilOptions];
	return base64EncodedString;
}

+ (NSData *)pcl_decodedDataFromBase64String:(NSString *)base64String
{
	NSData *decodedData = nil;
    decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:kNilOptions];
	return decodedData;
}

@end