/*!
 @file		NSSTring+PCLExtensions.h
 @brief		Extensions for the class NSString
 @author	Stefan Herold
 @date		2015-07-29
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "PCLTypeDefs.h"

/*!
 @typedef NSStringLoremIpsumType
 @brief Input types to generate a lorem ipsum text
 */
typedef NS_ENUM(NSUInteger, NSStringLoremIpsumType) {
	NSStringLoremIpsumTypeLength,
	NSStringLoremIpsumTypeMaxLength,
	NSStringLoremIpsumTypeWords,
	NSStringLoremIpsumTypeMaxWords
};

@interface NSString (PCLExtensions)


#pragma mark - Lorem Ipsum Generation
/*!
 @name Lorem Ipsum Generation
 @{
 */
+ (NSString*)pcl_loremIpsumWithValue:(NSUInteger)aValue type:(NSStringLoremIpsumType)aType;
+ (NSString*)pcl_loremIpsumWithLength:(NSUInteger)aLength;
+ (NSString*)pcl_loremIpsumWithMaxLength:(NSUInteger)aLength;
+ (NSString*)pcl_loremIpsumWithWords:(NSUInteger)aCount;
+ (NSString*)pcl_loremIpsumWithMaxWords:(NSUInteger)aCount;
//!@}


#pragma mark - Repeating Strings
/*!
 @name Repeating Strings
 @{
 */
- (NSString*)pcl_repeat:(NSUInteger)times;
//!@}


#pragma mark - URL Encoding
/*!
 @name URL Encoding
 @{
 */
- (NSString *)pcl_URLEncodedString;
- (NSString *)pcl_URLDecodedString;
//!@}


#pragma mark - UDID Generation
/*!
 @name UDID Generation
 @{
 */
+ (NSString*)pcl_uniqueID;
//!@}


#pragma mark - Comparison
/*!
 @name Comparison
 @{
 */
- (BOOL)pcl_isNotEqualToString:(NSString*)aString;
- (BOOL)pcl_isLowerToString:(NSString*)aString;
- (BOOL)pcl_isLowerEqualToString:(NSString*)aString;
//!@}


#pragma mark - Truncation

/**
 Removes whitespaces and newline characters from the beginning and the end of the receiver.
 @return The trimmed string.
 */
- (NSString*)pcl_trim;

/**
 Removes characters from the string until it matches the given width minus an ellipsis that is added to the string. This method is used for strings displayed on one line.
 @param width Width the string should be truncated to.
 @param attributes Attributed the string should be displayed with.
 @return The truncated string.
 */
- (NSString*)pcl_truncatedToWidth:(CGFloat)width attributes:(NSDictionary*)attributes;


#pragma mark - Length Related
/*!
 @name Length Related
 @{
 */
+ (BOOL)pcl_isStringEmpty:(NSString *)string;
//!@}


#pragma mark - File Paths
/*!
 @name File Paths
 @{
 */
- (NSString*)pcl_concatWithDocumentsDirectoryPath;
- (NSString*)pcl_concatWithTemporaryDirectoryPath;
//!@}


#pragma mark - Regular Expression Checking / Validation
/*!
 @name Regular Expression Checking / Validation
 @{
 */
- (BOOL)pcl_matchesRegularExpression:(NSString*)regexPattern;
- (BOOL)pcl_isValidEmail;
//!@}


#pragma mark - Hash Generation
/*!
 @name Hash Generation
 @{
 */
- (NSString *)pcl_sha512HashFromUTF8String;
//!@}


#pragma mark - Formatting
/*!
 @name Formatting
 @{
 */
+ (NSString *)pcl_stringByConvertingBytesToHumanReadableFormat:(PCLFileSize)bytes;
+ (NSString*)pcl_stringFromTimeInSeconds:(NSTimeInterval)timeInSeconds includeHoursInMinutesIfUnderAnHour:(BOOL)includeHoursInMinutes;
//!@}


#pragma mark - User Agent Generation
/*!
 @name User Agent Generation
 @{
 */
+ (NSString*)pcl_userAgentString;
//!@}

@end
