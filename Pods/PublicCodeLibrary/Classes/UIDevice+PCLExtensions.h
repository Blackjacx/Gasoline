/*!
 @file		UIDevice+PCLExtension.h
 @brief		Extensions for the class UIDevice
 @author	Stefan Herold
 @date		2015-07-29
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

@interface UIDevice (PCLExtensions)

+ (BOOL)pcl_isPad;
+ (BOOL)pcl_isPhone;
+ (BOOL)pcl_isIOS7OrHigher;
+ (BOOL)pcl_isIOS8OrHigher;
+ (BOOL)pcl_isIOS9OrHigher;
+ (NSUInteger)pcl_majorOSVersion;
- (NSString *)pcl_machine;

@end
