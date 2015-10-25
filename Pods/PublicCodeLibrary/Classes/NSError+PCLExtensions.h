//
//  NSError+PCLExtensions.h
//  PublicCodeLibrary
//
//  Created by Stefan Herold on 10/24/11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PCLErrorCode) {
	/*! 
		@brief Unknwon Error code
		@details Can occur in every situation.
	 */
	PCLErrorCodeUnknown = 999999
};

@interface NSError (PCLExtensions)

/*! 
	@brief Creates an NSError object based simply on domain and code.
	@details The creation algorithm is based on available, localized string 
				tables in the main project. They provide the localizable 
				messages contained in this error object. @see { 
				@c NSLocalizedFailureReasonErrorKey
				@c NSLocalizedDescriptionKey }
*/
+ (NSError *)pcl_errorWithDomain:(NSString *)domain code:(NSInteger)code;

@end
