/*!
 @file		NSDate+PCLExtensions.h
 @brief		Extensions for the class NSDate
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

@interface NSDate (PCLExtensions) 

- (NSString *)stringWithDefaultFormat:(NSDateFormatterStyle)dateFormat;
- (NSString *)stringWithCustomFormatString:(NSString *)formatString;
- (NSString *)stringWithCustomFormatFromLocalizationWithKey:(NSString *)formatKey fromBundle:(NSBundle*)bundle;

/*!
 @brief Converts the given UTC time string to an \c NSDate object.
 @param timeString A string which is expected to have the format <tt>yyyy-MM-dd'T'HH:mm:ss.000Z</tt>.
 @return An \c NSDate object or \c nil when failing.
 */
+ (NSDate *)dateFromUTCString:(NSString *)timeString;


@end
