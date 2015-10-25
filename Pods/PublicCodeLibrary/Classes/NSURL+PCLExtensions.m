/*!
 @file		NSURL+PCLExtensions.m
 @brief		Extensions for the class NSURL
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "NSURL+PCLExtensions.h"
#import "NSString+PCLExtensions.h"

@implementation NSURL (PCLExtensions)

// MARK URL Creation

+ (NSURL *)pcl_URLWithRoot:(NSString *)root
					  path:(NSString *)path
			 getParameters:(NSDictionary *)getParameters
{	
	NSMutableString * URLAsString = [NSMutableString stringWithString:root];
	
	if ( [path length] > 0 ) {
		NSString * urlWithPath = [URLAsString stringByAppendingPathComponent:path];
		URLAsString = [NSMutableString stringWithString:urlWithPath];
	}
	
	NSArray * const parameterKeys = [getParameters allKeys];
	BOOL isFirstParameter = YES;
	
	for ( NSString * key in parameterKeys )
	{
		NSString * const parameter = getParameters[key];
		NSString * const escapedParameter = [parameter pcl_URLEncodedString];
		
		if ( isFirstParameter ) {
			isFirstParameter = NO;
			[URLAsString appendString:@"?"];
		}
		else {
			[URLAsString appendString:@"&"];
		}
		
		[URLAsString appendFormat:@"%@=%@", key, escapedParameter];
	}
	
	return [NSURL URLWithString:URLAsString];
}

@end
