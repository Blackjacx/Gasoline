/*!
 @file		NSURL+PCLExtensions.h
 @brief		Extensions for the class NSURL
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

@interface NSURL (PCLExtensions)

// MARK URL Creation

+ (NSURL *)pcl_URLWithRoot:(NSString *)root
					  path:(NSString *)path
			 getParameters:(NSDictionary *)getParameters;
		
@end
