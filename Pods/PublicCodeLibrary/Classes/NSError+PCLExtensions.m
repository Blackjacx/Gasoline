//
//  NSError+PCLExtensions.m
//  PublicCodeLibrary
//
//  Created by Stefan Herold on 10/24/11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "NSError+PCLExtensions.h"
#import "PCLStrings.h"

PCL_DEFINE_STRING(NSErrorExtensionLocalizedStringReturnValueModifierForFailureReason,		@"FR_");
PCL_DEFINE_STRING(NSErrorExtensionLocalizedStringReturnValueModifierForErrorDescription,	@"ED_");
PCL_DEFINE_STRING(NSErrorExtensionLocalizedStringReturnValueModifierForRecoveryOptions,		@"RO_");
PCL_DEFINE_STRING(NSErrorExtensionLocalizedStringReturnValueModifierForRecoverySuggestions, @"RS_");

@implementation NSError (PCLExtensions)

#pragma mark - Getting Localized Strings

+ (NSString *)localizedStringForDomain:(NSString *)domain 
		code:(NSInteger)code 
		returnValueModifier:(NSString *)returnValueModifier
{	
	NSString * alternativeLocalizedMessage = nil;
	
	// --- input checking
	
	NSAssert([domain length], @"Expected domain to be non-empty.");
	NSAssert([returnValueModifier length], @"Expected returnValueModifier to be non-empty.");
	
	// --- get localized message for unknwon error occurred in given domain
	// --- offer this value only as an alternative if the return modifier equals the error description
	// --- other return modifiers are obsolete
	
	if( [returnValueModifier isEqualToString:NSErrorExtensionLocalizedStringReturnValueModifierForErrorDescription] )
	{
		// --- in this case the alternative message MUST be present in string table
		
		NSString * const stringTableKeyForUnknownError = 
		[NSString stringWithFormat:@"%@%ld",
			NSErrorExtensionLocalizedStringReturnValueModifierForErrorDescription,
			(long)PCLErrorCodeUnknown];
	
		alternativeLocalizedMessage = [[NSBundle mainBundle]
			localizedStringForKey:stringTableKeyForUnknownError
			value:nil
			table:domain];
			
		if( [alternativeLocalizedMessage isEqualToString:stringTableKeyForUnknownError] ) {
			alternativeLocalizedMessage = nil;
		}
		
		NSAssert(alternativeLocalizedMessage, @"Every string table used for "
			"localized error strings MUST contain the description key for an unknown error: "
			"%@!!!",
			stringTableKeyForUnknownError);
	}
	
	// --- get strings from respective string tables

	NSString * const stringTableKey =
		[NSString stringWithFormat:@"%@%ld", returnValueModifier, (long)code];
	
	NSString * result = [[NSBundle mainBundle]
				  localizedStringForKey:stringTableKey
				  value:alternativeLocalizedMessage
				  table:domain];
	
	// --- return nil for the localized string if it is not present in string table
	if( [result isEqualToString:stringTableKey] )
		result = nil;

	return result;
}

#pragma mark - Initialization

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code
{
	NSMutableDictionary * const newUserInfo = [NSMutableDictionary dictionary];
	
	NSString * const failureReason = [[self class] 
			localizedStringForDomain:domain 
			code:code 
			returnValueModifier:NSErrorExtensionLocalizedStringReturnValueModifierForFailureReason];
	
	NSString * const errorDescription = [[self class] 
			localizedStringForDomain:domain 
			code:code 
			returnValueModifier:NSErrorExtensionLocalizedStringReturnValueModifierForErrorDescription];			
			
	NSString * const recoveryOptions = [[self class] 
			localizedStringForDomain:domain 
			code:code 
			returnValueModifier:NSErrorExtensionLocalizedStringReturnValueModifierForRecoveryOptions];
			
	NSString * const recoverySuggestion = [[self class] 
			localizedStringForDomain:domain 
			code:code 
			returnValueModifier:NSErrorExtensionLocalizedStringReturnValueModifierForRecoverySuggestions];
	
	// --- set non optional values
	newUserInfo[NSLocalizedDescriptionKey] = errorDescription;
	
	// --- set optional values
	if( failureReason ) {
		newUserInfo[NSLocalizedFailureReasonErrorKey] = failureReason;
	}
	if( recoveryOptions ) {
		newUserInfo[NSLocalizedRecoveryOptionsErrorKey] = recoveryOptions;
	}
	if( recoverySuggestion ) {
		newUserInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion;
	}
	
	// --- initialization goes to the end
	return [self initWithDomain:domain code:code userInfo:newUserInfo];
}

+ (NSError *)pcl_errorWithDomain:(NSString *)domain code:(NSInteger)code {
	NSError * error = [[self alloc] initWithDomain:domain code:code];
	return error;
}

@end
