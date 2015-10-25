//
//  UIApplication+PCLExtension.m
//  PublicCodeLibrary
//
//  Created by Stefan Herold on 6/24/12.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "UIApplication+PCLExtensions.h"
#import "NSString+PCLExtensions.h"

@implementation UIApplication (PCLExtensions)

+ (NSString*)pcl_appVersion {
	
	id bundleVerObj = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	NSString * bundleVer = [NSString stringWithFormat:@"%@", bundleVerObj];
	NSString * bundleVerTrimmed = [bundleVer pcl_trim];
	return bundleVerTrimmed;
}

+ (NSString*)pcl_applicationName {
	
	id appNameObj = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	NSString * appName = [NSString stringWithFormat:@"%@", appNameObj];
	return appName;
}

@end
