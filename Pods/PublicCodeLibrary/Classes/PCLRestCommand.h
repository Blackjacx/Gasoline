//
//  PCLRestCommand.h
//  OperationExample
//
//  Created by Stefan Herold on 9/12/11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//


#pragma mark - Delegate Protocol Declaration

@protocol PCLRestCommandDelegate;

@interface PCLRestCommand : NSOperation

@property(nonatomic, weak) id<PCLRestCommandDelegate> delegate;
@property(nonatomic, readonly) NSHTTPURLResponse * URLResponse;
@property(nonatomic, readonly) NSString * identifier;
@property(nonatomic, readonly) NSString * userAgent;
@property(nonatomic, readonly, getter = isAuthenticationRequired) BOOL authenticationRequired;

- (id)initWithRootURLString:(NSString *)rootURL
		path:(NSString *)urlPath
		getParameters:(NSDictionary*)getParameters
		identifier:(NSString*)anIdentifier
		authenticationRequired:(BOOL)requiresAuthentication;
		
- (NSData*)result;
- (void)executeInBackground;
- (void)executeOnMainThread;

@end


#pragma mark - Delegate Protocol Definition

@protocol PCLRestCommandDelegate <NSObject>

@required

- (void)PCLRestCommandDidFinish:(PCLRestCommand*)command;
- (void)PCLRestCommandDidFail:(PCLRestCommand*)command withError:(NSError*)anError;

@end