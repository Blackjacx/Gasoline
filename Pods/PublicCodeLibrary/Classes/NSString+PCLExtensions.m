/*!
 @file		NSSTring+PCLExtensions.m
 @brief		Extensions for the class NSString
 @author	Stefan Herold
 @date		2015-07-29
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "NSString+PCLExtensions.h"
#import "UIApplication+PCLExtensions.h"
#import "UIDevice+PCLExtensions.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (PCLExtensions)


#pragma mark - Lorem Ipsum Generation

+ (NSString*)pcl_loremIpsumWithValue:(NSUInteger)aLengthOrCount type:(NSStringLoremIpsumType)aType
{
	NSString * result;
	NSString * const separationString = @" ";
	static NSString * loremIpsumBaseString = @"Lorem ipsum dolor sit amet, cons"
		"ectetuer adipiscing elit. Nam cursus. Morbi ut mi. Nullam enim leo, eg"
		"estas id, condimentum at, laoreet mattis, massa. Sed eleifend nonummy "
		"diam. Praesent mauris ante, elementum et, bibendum at, posuere sit ame"
		"t, nibh. Duis tincidunt lectus quis dui viverra vestibulum. Suspendiss"
		"e vulputate aliquam dui. Nulla elementum dui ut augue. Aliquam vehicul"
		"a mi at mauris. Maecenas placerat, nisl at consequat rhoncus, sem nunc"
		" gravida justo, quis eleifend arcu velit quis lacus. Morbi magna magna"
		", tincidunt a, mattis non, imperdiet vitae, tellus. Sed odio est, auct"
		"or ac, sollicitudin in, consequat vitae, orci. Fusce id felis. Vivamus"
		" sollicitudin metus eget eros.";
		
    if (aLengthOrCount == 0) {
        return @"";
    }
    
	if ( NSStringLoremIpsumTypeMaxLength == aType || NSStringLoremIpsumTypeMaxWords == aType )
    {
		// Generate a random number between 1 (!) and the max length | count
		aLengthOrCount = (arc4random() % aLengthOrCount) + 1;
	}
	
	switch (aType) 
	{
		case NSStringLoremIpsumTypeLength:
		case NSStringLoremIpsumTypeMaxLength:
        {
			if( aLengthOrCount > loremIpsumBaseString.length )
            {
				NSString * tmpString = [[loremIpsumBaseString stringByAppendingString:separationString] pcl_repeat:(NSUInteger)(aLengthOrCount / loremIpsumBaseString.length + 1)];
				result = [tmpString substringToIndex:aLengthOrCount];
			}
			else
            {
				result = [loremIpsumBaseString substringToIndex:aLengthOrCount];
			}
		}    
		break;
		
		case NSStringLoremIpsumTypeWords:
		case NSStringLoremIpsumTypeMaxWords:
        {
			NSMutableArray * resultingWordList = [[NSMutableArray alloc] initWithCapacity:aLengthOrCount];
			NSArray * loremIpsumExploded = [loremIpsumBaseString componentsSeparatedByString:separationString];
			NSUInteger wordCount = loremIpsumExploded.count;
			
            for (NSUInteger i=0; i<aLengthOrCount; i++)
            {
				// Modulo for the case: requested count > word count
				[resultingWordList addObject:loremIpsumExploded[(i % wordCount)]];
			}
			result = [resultingWordList componentsJoinedByString:separationString];
		}    
		break;
	}
	return result;
}

+ (NSString*)pcl_loremIpsumWithLength:(NSUInteger)aLength
{
	return [self pcl_loremIpsumWithValue:aLength type:NSStringLoremIpsumTypeLength];
}

+ (NSString*)pcl_loremIpsumWithMaxLength:(NSUInteger)aLength
{
	return [self pcl_loremIpsumWithValue:aLength type:NSStringLoremIpsumTypeMaxLength];
}

+ (NSString*)pcl_loremIpsumWithWords:(NSUInteger)aCount
{
	return [self pcl_loremIpsumWithValue:aCount type:NSStringLoremIpsumTypeWords];
}

+ (NSString*)pcl_loremIpsumWithMaxWords:(NSUInteger)aCount
{
	return [self pcl_loremIpsumWithValue:aCount type:NSStringLoremIpsumTypeMaxWords];
}


#pragma mark - Repeating Strings

- (NSString*)pcl_repeat:(NSUInteger)times {
	NSMutableString * mutableResult = [self mutableCopy];
	
    for( NSUInteger i=0; i<times; i++ )
    {
		[mutableResult appendString:self];
	}
	return [mutableResult copy];
}


#pragma mark - URL Encoding

- (NSString *)pcl_URLEncodedString
{
    if (self == nil)
    {
        return nil;
    }
		
	CFStringRef preprocessedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef) self, CFSTR(""), kCFStringEncodingUTF8);
    CFStringRef resultRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, preprocessedString, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
	NSString * result = (__bridge NSString*)resultRef;
																
	CFRelease(resultRef);
	CFRelease(preprocessedString);
	return result;
}

- (NSString *)pcl_URLDecodedString
{
	CFStringRef resultRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
	NSString * result = (__bridge NSString*)resultRef;
	CFRelease(resultRef);
	return result;
}


#pragma mark - UDID Generation

+ (NSString*)pcl_uniqueID
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef uuidStringRef = CFUUIDCreateString(kCFAllocatorDefault,uuidRef);
	NSString * uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
	CFRelease(uuidRef);
	CFRelease(uuidStringRef);
	return uuid;
}


#pragma mark - Comparison

- (BOOL)pcl_isNotEqualToString:(NSString*)aString
{
    return [self compare:aString] != NSOrderedSame;
}

- (BOOL)pcl_isLowerToString:(NSString*)aString
{
    return [self compare:aString] == NSOrderedAscending;
}

- (BOOL)pcl_isLowerEqualToString:(NSString*)aString
{
    return [self compare:aString] != NSOrderedDescending;
}


#pragma mark - Truncation

- (NSString*)pcl_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)pcl_truncatedToWidth:(CGFloat)width attributes:(NSDictionary*)attributes
{
    NSMutableString * result  = [self mutableCopy];
    NSString * const ellipsis = @"...";
    
    if( [self sizeWithAttributes:attributes].width > width )
    {
        width -= [ellipsis sizeWithAttributes:attributes].width;
        
        NSRange resultRange = {[result length] - 1, 1};
        
        while ( [result sizeWithAttributes:attributes].width > width )
        {
            [result deleteCharactersInRange:resultRange];
            resultRange.location--;
        }
        
        [result replaceCharactersInRange:resultRange withString:ellipsis];
    }
    return result;
}


#pragma mark - Length Related

+ (BOOL)pcl_isStringEmpty:(NSString *)string
{
    // string is nil or empty
    if ( !string || string.length == 0 )
    {
        return YES;
    }
    
    return NO;
}


#pragma mark - File Paths

- (NSString*)pcl_concatWithDocumentsDirectoryPath
{
    NSString * result = nil;    
    NSError * anError = nil;
    NSURL * const documentsDirectroryUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:NULL create:YES error:&anError];
    
    if( !anError && documentsDirectroryUrl )
    {
        result = [[documentsDirectroryUrl absoluteString] stringByAppendingPathComponent:self];
    }    
    
    return result;
}

- (NSString*)pcl_concatWithTemporaryDirectoryPath
{
    NSString * result = nil;    
    NSError * anError = nil;
    NSURL * const temporaryDirectroryUrl = [[NSFileManager defaultManager] URLForDirectory:NSItemReplacementDirectory inDomain:NSUserDomainMask appropriateForURL:NULL create:YES error:&anError];
    
    if( !anError && temporaryDirectroryUrl )
    {
        result = [[temporaryDirectroryUrl absoluteString] stringByAppendingPathComponent:self];
    }    
    
    return result;    
}


#pragma mark - Regular Expression Checking / Validation

- (BOOL)pcl_matchesRegularExpression:(NSString*)regexPattern
{
	NSError * error = nil;
	
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:&error];
			
	// --- regex creation generated error
	if( error )
    {
		return NO;
	}
	
	NSRange expectedRangeOfMatch = NSMakeRange(0, [self length]);
	NSRange actualRangeOfMatch = [regex rangeOfFirstMatchInString:self options:0 range:expectedRangeOfMatch];
	BOOL regexMatched = [NSStringFromRange(expectedRangeOfMatch) isEqualToString:NSStringFromRange(actualRangeOfMatch)];
	
	// --- regex didn't match
	if( !regexMatched )
    {
		return NO;
	}
	
	// --- everything worked fine
	return YES;
}

- (BOOL)pcl_isValidEmail
{
	// This one is better than the one from the net below.
	// It declines domains with more than 4 characters.
	// The below one does this not (but it should - there must be an error).
	NSString * const emailRegex = @"([A-Z0-9a-z_%+-]|([A-Z0-9a-z_%+-]+[A-Z0-9a-z._%+-]*[^.]))@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

	// --- found at: http://www.regular-expressions.info/email.html (read the discussion)
	//	NSString * const emailRegex = @"^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$";

	BOOL result = [self pcl_matchesRegularExpression:emailRegex];

	if( result )
    {
		// --- check for multiple dots
		NSString * const multipleDotsRegex = @"^.*[.]{2,}.*$";
		result = ![self pcl_matchesRegularExpression:multipleDotsRegex];
	}

    if (result)
    {
        // --- check for @@
        NSString * twoAt = @"@@";
        NSRange range = [self rangeOfString:twoAt];
        result = !(range.length > 0);
    }
	return result;
}


#pragma mark - SHA512 Hash Generation

- (NSString*)pcl_sha512HashFromUTF8String
{
	NSData * const stringData = [self dataUsingEncoding:NSUTF8StringEncoding
								   allowLossyConversion:NO];
	// Create a SHA512 digest and store it in digest
	uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
	CC_SHA512(stringData.bytes, (CC_LONG)stringData.length, digest);

	// Now convert to NSData structure to make it usable again
    NSData * const hashedData = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
	NSString * hashString = [hashedData description];
	hashString = [hashString stringByReplacingOccurrencesOfString:@" " withString:@""];
    hashString = [hashString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hashString = [hashString stringByReplacingOccurrencesOfString:@">" withString:@""];

	return hashString;
}


#pragma mark - Formatting

+ (NSString *)pcl_stringByConvertingBytesToHumanReadableFormat:(PCLFileSize)bytes {

	NSString * result = @"";

	// > 1 TB
	if ( bytes > 0x10000000000 )
    {
		result = [NSString stringWithFormat:@"%.2f TB", bytes / (double)0x10000000000];
	}
	// > 1 GB
	else if( bytes > 0x40000000 )
    {
		result = [NSString stringWithFormat:@"%.2f GB", bytes / (double)0x40000000];
	}
	// > 1 MB
	else if( bytes > 0x100000 )
    {
		result = [NSString stringWithFormat:@"%.2f MB", bytes / (double)0x100000];
	}
	// > 1 kB
	else if( bytes > 0x400 )
    {
		result = [NSString stringWithFormat:@"%lld kB", bytes / 0x400];
	}
	else
    {
		result = [NSString stringWithFormat:@"%lld Byte", bytes];
	}
	return result;
}

+ (NSString*)pcl_stringFromTimeInSeconds:(NSTimeInterval)timeInSeconds includeHoursInMinutesIfUnderAnHour:(BOOL)includeHoursInMinutes;
{
	NSString * result = nil;

	if( timeInSeconds > 0 )
    {
		unsigned long timeIntervalAsInteger = (unsigned long)timeInSeconds;
		unsigned long hours 				= timeIntervalAsInteger / 3600;
		unsigned long minutes 				= (timeIntervalAsInteger - (hours*3600)) / 60;
		unsigned long minutesWithHours 		= timeIntervalAsInteger / 60;
		unsigned long seconds 				= timeIntervalAsInteger % 60;

        if ( includeHoursInMinutes && ( minutesWithHours < 60 ) )
        {
            result = [NSString stringWithFormat:@"%02lu:%02lu", minutesWithHours, seconds];
        }
        else
        {
            result = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", hours, minutes, seconds];
        }
	}
	else
    {
		result = includeHoursInMinutes ? @"00:00" : @"00:00:00";
	}

	return result;
}


#pragma mark - User Agent Generation

+ (NSString*)pcl_userAgentString
{
	NSString *result = [NSString stringWithFormat:@"%@/%@/iOS/%@/%@",
						[[UIApplication pcl_applicationName] stringByReplacingOccurrencesOfString:@" " withString:@"_"],
						[[UIApplication pcl_appVersion] stringByReplacingOccurrencesOfString:@" "  withString:@"_"],
						[[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@" " withString:@"_"],
						[[[UIDevice currentDevice] pcl_machine] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];

	return result;
}


@end
