//
//  FLCDateFormatter.h
//  flincCommon
//
//  Created by Stefan Herold on 17/08/15.
//  Copyright (c) 2015 flinc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, FLCDateFormat) {
    
    FLCDateFormat_NoTime_ShortWeekdayName,
    FLCDateFormat_NoTime_ShortDate,
    FLCDateFormat_NoTime_MediumDateNoYear,
    FLCDateFormat_NoTime_MediumDateWithDayname,
    
    
    FLCDateFormat_NoTime_MediumDate_Relative,
    
    FLCDateFormat_ShortTime_ShortDate,
    
    
    // The official date formatter that should be STANDARD and works on every platform
    FLCDateFormat_RFC3339,
    FLCDateFormat_ISO8601,
    FLCDateFormat_ISO8601_NoTime_LongDate,
    FLCDateFormat_GMT_NoTime_MediumDate,
    // "Thu, 28 Oct 2010 16:39:32 GMT"
    FLCDateFormat_GMT_en_US_Locale,
    // local timezone in effect, but conversion pattern does not contain any timezone info
    FLCDateFormat_Zulu_DefaultTimeZone,
    // zulu timezone in effect, but conversion pattern does not contain any timezone info
    FLCDateFormat_Zulu_NoTimeZone,
    FLCDateFormat_Zulu,
    FLCDateFormat_UTC,

    FLCDateFormat_MAX,
};

@interface FLCDateFormatter : NSObject

/**
 */
+ (nullable NSString*)stringFromDate:(nullable NSDate*)date usingFormat:(FLCDateFormat)format locale:(nullable NSLocale*)locale;
/**
 * Converts a given date to a NSString using the given format. This method runs thread safe.
 * @param date Date to convert from.
 * @param The format used for the current conversion. @see FLCDateFormat
 * @return A NSString object representing the @c date.
 */
+ (nullable NSString*)stringFromDate:(nullable NSDate*)date usingFormat:(FLCDateFormat)format;
/**
 */
+ (nullable NSDate*)dateFromString:(nullable NSString*)dateString usingFormat:(FLCDateFormat)format locale:(nullable NSLocale*)locale;
/**
 * Converts a given date string to a NSDate using the given format. This method runs thread safe.
 * @param dateString NSString to convert from.
 * @param The format used for the current conversion. @see FLCDateFormat
 * @return A NSDate object representing the given @c dateString.
 */
+ (nullable NSDate*)dateFromString:(nullable NSString*)dateString usingFormat:(FLCDateFormat)format;

@end