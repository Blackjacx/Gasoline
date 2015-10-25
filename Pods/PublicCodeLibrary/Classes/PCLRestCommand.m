//
//  PCLRestCommand.m
//  OperationExample
//
//  Created by Stefan Herold on 9/12/11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "PCLRestCommand.h"
#import "PCLStrings.h"
#import "NSString+PCLExtensions.h"
#import "NSURL+PCLExtensions.h"
#import "UIApplication+PCLExtensions.h"
#import "UIDevice+PCLExtensions.h"

static CGFloat const PCLRestOperationDefaultTimeout = 30.0;

PCL_DEFINE_KEY_WITH_VALUE(PCLRestCommandOperationIsFinishedKeyPath, @"isFinished");


static NSOperationQueue * backgroundQueue;

@interface PCLRestCommand ()

@property(nonatomic, readwrite) NSString * userAgent;

// Private

@property(nonatomic, copy) NSString * rootURL;
@property(nonatomic, copy) NSString * urlPath;
@property(nonatomic, copy) NSDictionary * getParameters;
@property(nonatomic, copy) NSMutableData * receivedData;
@property(nonatomic, strong) NSError * commandError;
@property(nonatomic, assign) BOOL connectionFinished;

@end

@implementation PCLRestCommand

#pragma mark - Initialization & Deallocation & Reset

+ (void)initialize {
	if(!backgroundQueue) {
		backgroundQueue = [[NSOperationQueue alloc] init];
	}
}

- (id)init {
	// Should not be called!
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id)initWithRootURLString:(NSString *)aRootURL
					   path:(NSString *)anUrlPath
			  getParameters:(NSDictionary*)theGetParameters
				 identifier:(NSString*)anIdentifier
	 authenticationRequired:(BOOL)requiresAuthentication
{
	self = [super init];
	
	if( self ) {
		
		_rootURL = [aRootURL copy];
		_urlPath = [anUrlPath copy];
		_getParameters = theGetParameters;
		
		_connectionFinished = NO;
		_identifier = [anIdentifier copy];
		_authenticationRequired = requiresAuthentication;
		
		[self addObserver:self
			   forKeyPath:PCLRestCommandOperationIsFinishedKeyPath
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	}
	return self;
}

- (void)dealloc {

	[self removeObserver:self
			  forKeyPath:PCLRestCommandOperationIsFinishedKeyPath];
}

#pragma mark - Request Creation

- (NSURLRequest*)URLRequest {
	
	NSURL * URL = [NSURL pcl_URLWithRoot:_rootURL
									path:_urlPath
						   getParameters:_getParameters];
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:URL];
	
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setTimeoutInterval:PCLRestOperationDefaultTimeout];
	
	[request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
	
	if( self.isAuthenticationRequired ) {
		// TODO: Add an authentication token
		//		[request setValue:tokenValue forHTTPHeaderField:@"Authorization"];
	}
	
	// --- set default header parameter
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	
	[request setHTTPMethod:@"GET"];
	
	return request;
}

- (NSString *)userAgent {
	if( !_userAgent ) {
		
		_userAgent = [NSString stringWithFormat:@"%@/%@ %@/%@ %@",
					  [[UIApplication pcl_applicationName]
					   stringByReplacingOccurrencesOfString:@" "
					   withString:@"_"],
					  [[UIApplication pcl_appVersion]
					   stringByReplacingOccurrencesOfString:@" "
					   withString:@"_"],
					  [[[UIDevice currentDevice] systemName]
					   stringByReplacingOccurrencesOfString:@" "
					   withString:@"_"],
					  [[[UIDevice currentDevice] systemVersion]
					   stringByReplacingOccurrencesOfString:@" "
					   withString:@"_"],
					  [[[UIDevice currentDevice] pcl_machine]
					   stringByReplacingOccurrencesOfString:@" "
					   withString:@"_"]];
	}
	return _userAgent;
}

#pragma mark - Execution

- (void)executeInBackground {
	[backgroundQueue addOperation:self];
}

- (void)executeOnMainThread {
	[[NSOperationQueue mainQueue] addOperation:self];
}

- (void)main {
	
	@autoreleasepool {
		
		NSURLConnection * connection = nil;
		
		@try {
			if ( self.isCancelled ) return;
			
			// --- init the connection
			connection = [NSURLConnection
						  connectionWithRequest:[self URLRequest]
						  delegate:self];
			
			if( !connection ) {
				// TODO: Set error object here...!
				NSAssert(NO, @"Connection could not be initialized");
				return;
			}
			
			if ( self.isCancelled ) return;
			
			NSRunLoop * const currentRunloop = [NSRunLoop  currentRunLoop];
			
			if ( self.isCancelled )
				return;
			
			BOOL isDone = NO;
			
			do {
				
				@autoreleasepool {
					
					NSDate * const aFutureDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
					isDone = ![currentRunloop runMode:NSDefaultRunLoopMode beforeDate:aFutureDate];
				}
				
			} while ( !isDone && currentRunloop && !self.isCancelled && !_connectionFinished );
		}
		@catch (NSException *exception) {
			// Do not rethrow exception...
		}
		@finally {
		}
	}
}

#pragma mark - NSURLConnection - Delegate (Connection Data and Responses)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSAssert([response isKindOfClass:[NSHTTPURLResponse class]],
			 @"response expected to be kind of class %@", [NSHTTPURLResponse class]);
	
	NSAssert(_URLResponse == nil,
			 @"URLResponse expected to be nil");
	
	_URLResponse = (NSHTTPURLResponse*)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// --- initialize data object if not done yet
	if ( !_receivedData ) {
		_receivedData = [[NSMutableData alloc] init];
	}
	
	[_receivedData appendData:data];
}

#pragma mark - NSURLConnection - Delegate (Connection Completion)

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSInteger statusCode = _URLResponse.statusCode;
	
	if( statusCode >= 400 ) {
		
		//TODO: evaluate the received data here and generate an error
		//		depending on http status code and receivedData content.
		
		_commandError = [NSError
						 errorWithDomain:NSStringFromClass( [self class] )
						 code:statusCode
						 userInfo:nil];
	}
	_connectionFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	_commandError = error;
	_connectionFinished = YES;
}

#pragma mark - Finish Command

- (void)finish
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
				   {
					   NSAssert(self.isFinished, @"Operation expected to be finished here!");
					   
					   // --- evaluate success or failure and notify the delegate
					   SEL selector = nil;
					   if( _commandError )
						   selector = @selector(PCLRestCommandDidFail:withError:);
					   else
						   selector = @selector(PCLRestCommandDidFinish:);
					   
					   if( [_delegate respondsToSelector:selector] )
					   {
						   NSMethodSignature * signature = [[_delegate class]
															instanceMethodSignatureForSelector:selector];
						   
						   NSInvocation * invocation = [NSInvocation
														invocationWithMethodSignature:signature];
						   
						   NSInteger argumentIndex = 2;
						   NSArray * argumentList = [[NSArray alloc] initWithObjects:
													 self,
													 _commandError,	// ends array initialization if nil
													 nil];
						   
						   // --- setting other parameters given
						   for (__unsafe_unretained id obj in argumentList) {
							   [invocation setArgument:&obj atIndex:argumentIndex++];
						   }
						   
						   [invocation setTarget:_delegate];
						   [invocation setSelector:selector];
						   
						   [invocation invoke];
					   }
				   });
}

#pragma mark - Finish Command - Observe Completion via KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if( [keyPath isEqualToString:PCLRestCommandOperationIsFinishedKeyPath] ) {
		[self finish];
	}
}

#pragma mark -  Getting the Result

- (NSData*)result {
	if( _connectionFinished && self.isFinished && !self.isCancelled ) {
		return _receivedData;
	}
	return nil;
}


@end
