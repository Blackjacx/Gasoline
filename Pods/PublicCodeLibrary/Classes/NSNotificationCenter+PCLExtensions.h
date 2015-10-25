/*!
 @file		NSNotificationCenter+PCLExtensions.h
 @brief		Extensions for the class NSNotificationCenter
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

@interface NSNotificationCenter (PCLExtensions)

#pragma mark - Post Notifications on the Main Thread
/*!
 @name Post Notifications on the Main Thread
 @{
 */
+ (void)postNotificationOnMainThread:(NSNotification*)notification postingStyle:(NSPostingStyle)postingStyle;
+ (void)postNotificationOnMainThreadWithName:(NSString*)name postingStyle:(NSPostingStyle)postingStyle;
+ (void)postNotificationOnMainThreadWithName:(NSString*)name object:(id)object postingStyle:(NSPostingStyle)postingStyle;
+ (void)postNotificationOnMainThreadWithName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo postingStyle:(NSPostingStyle)postingStyle;
//!@}

@end
