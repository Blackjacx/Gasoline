/*!
 @file		NSURLRequest+PCLExtensions.m
 @brief		Extensions for the class NSURLRequest
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "NSURLRequest+PCLExtensions.h"

@implementation NSURLRequest (PCLExtensions)

#pragma mark - Extended Description

- (NSString *)pcl_extendedDescription {

	NSString * description = [self description];
	
	// Add header fields.
	NSDictionary * const HTTPHeaderFields = [self allHTTPHeaderFields];
	NSArray * const fieldKeys = [HTTPHeaderFields allKeys];
	
	for ( NSString * fieldKey in fieldKeys ) {

		@autoreleasepool {

			description = [description stringByAppendingFormat:@"%@ = %@\n",
						   fieldKey,
						   [HTTPHeaderFields objectForKey:fieldKey]];
		}
	}
	description = [description stringByAppendingFormat:@"\n HTTP Method is %@", [self HTTPMethod]];
	description = [description stringByAppendingFormat:@"\n HTTP Body is %@", [self HTTPBody]];
	
	return description;
}

@end
