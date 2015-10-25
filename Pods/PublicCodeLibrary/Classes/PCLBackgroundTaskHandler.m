/*!
 @file		PCLBackgroundTaskHandler.h
 @brief		Easy management of background tasks
 @author	Stefan Herold
 @date		2011-10-24
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "PCLBackgroundTaskHandler.h"
#import "NSObject+PCLExtensions.h"

@interface PCLBackgroundTaskHandler ()

@property(retain, nonatomic)NSMutableSet * registeredObjects;
@property(assign, nonatomic)UIBackgroundTaskIdentifier backgroundTaskID;
@property(retain, nonatomic)NSTimer * backgroundTaskTimer;

@end

@implementation PCLBackgroundTaskHandler

#pragma mark - Singleton pattern

+ (PCLBackgroundTaskHandler *)sharedInstance {
    static dispatch_once_t predicate;
	static PCLBackgroundTaskHandler * instance = nil;

	dispatch_once(&predicate, ^{
		instance = [[super allocWithZone:NULL] init];
	});

	return instance;	
}

- (id)init {

	// Do not instantiate if multitasking is not supported
	if( [[UIDevice currentDevice] isMultitaskingSupported] ) {

		return nil;
	}
	
    if ( self = [super init] ) {
		
		self.registeredObjects = [NSMutableSet set];
		self.backgroundTaskID = UIBackgroundTaskInvalid;
		self.backgroundTaskTimer = nil;		
    }
	return self;
}

#pragma mark - Handling Background Tasks

- (void)registerObjectForBackgroundExecution:(id)anObject
{
	NSString * objectID = [self idForObject:anObject];
	
	if( !anObject || !objectID )
		return;

	[_registeredObjects addObject:objectID];
		
//	NSLog("parameter address: 0x%lx   objects in list (%d): \n%@", anObject, [_registeredObjects count], _registeredObjects);
//	NSLog(@"parameter type: %@   objects in list (%d)", NSStringFromClass([anObject class]), [_registeredObjects count]);

	// We got new commands in the list - so dont end the background task.
	[self stopBackgroundTaskTimer];
}

- (void)unregisterObjectForBackgroundExecution:(id)anObject
{	
	if( !anObject )
		return;
	
	NSString * ID = [self idForObject:anObject];
	[_registeredObjects removeObject:ID];
	
//	NSLog(@"parameter address: %p   objects in list (%d): \n%@", anObject, [_registeredObjects count], _registeredObjects);
//	NSLog(@"parameter type: %@   objects in list (%d)", NSStringFromClass([anObject class]), [_registeredObjects count]);

	// No more objects in queue, so end the background task
	// Wait some seconds to be shure that nothing else needs this task.
	if( ![self hasObjectsRegisteredToRunInBackground] && [self isBackgroundTaskRunning] ) 
	{
		CGFloat secondsToWait = 3.0f;
		[self stopBackgroundTaskTimer];
		self.backgroundTaskTimer = [NSTimer timerWithTimeInterval:secondsToWait 
				target:self 
				selector:@selector(fireDelayedKillOfBackgroundTask:) 
				userInfo:nil 
				repeats:NO];
				
		[[NSRunLoop mainRunLoop] addTimer:self.backgroundTaskTimer forMode:NSDefaultRunLoopMode];
		
//		NSLog(@"timer scheduled for in %.1f sec.", secondsToWait);
	}
}

- (NSString *)idForObject:(NSObject*)anObject
{
	if( !anObject ) {
		return nil;
	}		
	Class objectsClass = [anObject class];
	NSString * hexAddress = [anObject addressAsString];
	NSString * ID = [NSString stringWithFormat:@"[%@]_[%@]", hexAddress, NSStringFromClass(objectsClass)];
	return ID;
}

- (void)startBackgroundTask {

	// No need to start background task - return
	if( ![self hasObjectsRegisteredToRunInBackground] ) {

		return;
	}
		
	self.backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{

		[self killBackgroundTask];
	}];
		
//	// Start the long-running task and return immediately
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//		NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
//		NSTimeInterval nextActionTime = 0;
//		NSTimeInterval actionCycle = 0.5;
//		
//		do
//		{
//			@autoreleasepool {
//
//				NSDate * nextRunDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0.1f];
//				NSTimeInterval runTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
//				BOOL itsActionTime = runTime > nextActionTime;
//								
//				@try 
//				{									
//					// Run this run loop to be able to register/unregister events
//					[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:nextRunDate];
//				
//					// Run the main run loop to receive the timer event
//					[[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:nextRunDate];
//				}
//				@finally 
//				{
//					// Don't take action every cycle
//					if(  itsActionTime  ) {
//
//						NSLog(@"MainThread: %d     Time Remaining: %.1f     ",
//							  [NSThread isMainThread],
//							  [[UIApplication sharedApplication] backgroundTimeRemaining]);
//
//						nextActionTime = runTime + actionCycle;
//					}
//				}
//			}
//		}
//		while ( [self isBackgroundTaskRunning] );
//		
//		[self killBackgroundTask];
//    });
}

- (void)killBackgroundTask {

	[self stopBackgroundTaskTimer];

    if ( [self isBackgroundTaskRunning] ) {

		[[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskID];
		self.backgroundTaskID = UIBackgroundTaskInvalid;
	}
}

- (BOOL)isBackgroundTaskRunning {
	
	return self.backgroundTaskID != UIBackgroundTaskInvalid;
}

- (void)fireDelayedKillOfBackgroundTask:(NSTimer *)timer {

	[self killBackgroundTask];
}

- (BOOL)hasObjectsRegisteredToRunInBackground {

	NSUInteger registeredObjectsCount = [_registeredObjects count];
	return registeredObjectsCount > 0;	
}

- (void)stopBackgroundTaskTimer {

	[self.backgroundTaskTimer invalidate];
	self.backgroundTaskTimer = nil;
}

@end