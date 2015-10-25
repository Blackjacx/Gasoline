/*!
 @file		NSNotificationCenter+PCLExtensions.m
 @brief		Extensions for the class NSNotificationCenter
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "NSNotificationCenter+PCLExtensions.h"

@implementation NSNotificationCenter (PCLExtensions)

#pragma mark - Post Notifications on the Main Thread

+ (void)postNotificationOnMainThread:(NSNotification*)notification postingStyle:(NSPostingStyle)postingStyle; {

	NSAssert(postingStyle == NSPostASAP ||
			 postingStyle == NSPostNow ||
			 postingStyle == NSPostWhenIdle, @"PostingStyle MUST one of ASAP, Now or Idle!");

	dispatch_async(dispatch_get_main_queue(), ^{

		[[NSNotificationQueue defaultQueue] enqueueNotification:notification
												   postingStyle:postingStyle
												   coalesceMask:NSNotificationNoCoalescing
													   forModes:nil];
	});
}

+ (void)postNotificationOnMainThreadWithName:(NSString*)name postingStyle:(NSPostingStyle)postingStyle {

	NSNotification * notification = [NSNotification notificationWithName:name object:nil];
	[self postNotificationOnMainThread:notification postingStyle:postingStyle];
}

+ (void)postNotificationOnMainThreadWithName:(NSString*)name object:(id)object postingStyle:(NSPostingStyle)postingStyle {

	NSNotification * notification = [NSNotification notificationWithName:name object:object];
	[self postNotificationOnMainThread:notification postingStyle:postingStyle];
}

+ (void)postNotificationOnMainThreadWithName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo postingStyle:(NSPostingStyle)postingStyle {

	NSNotification * notification = [NSNotification notificationWithName:name object:object userInfo:userInfo];
	[self postNotificationOnMainThread:notification postingStyle:postingStyle];
}

@end