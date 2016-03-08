//
//  FLCDateFormatter.m
//  flincCommon
//
//  Created by Stefan Herold on 17/08/15.
//  Copyright (c) 2015 flinc. All rights reserved.
//

#import "FLCDateFormatter.h"

static NSDateFormatter *FLCGlobalDateFormatter;
static dispatch_queue_t FLCGlobaldateFormatterSerialDispatchQueue;


@implementation FLCDateFormatter

+ (void)initialize {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        FLCGlobalDateFormatter = [[NSDateFormatter alloc] init];
        FLCGlobalDateFormatter.AMSymbol = @"am";
        FLCGlobalDateFormatter.PMSymbol = @"pm";
        
        FLCGlobaldateFormatterSerialDispatchQueue = dispatch_queue_create("de.flincCore.globalDateFormatterSerialQueue", DISPATCH_QUEUE_SERIAL);
    });
}

+ (void)reset {
    FLCGlobalDateFormatter.doesRelativeDateFormatting = NO;
    FLCGlobalDateFormatter.dateFormat = nil;
    FLCGlobalDateFormatter.timeStyle = NSDateFormatterNoStyle;
    FLCGlobalDateFormatter.dateStyle = NSDateFormatterNoStyle;
    FLCGlobalDateFormatter.locale = [NSLocale currentLocale];
    FLCGlobalDateFormatter.timeZone = [NSTimeZone defaultTimeZone];
}

+ (void)configureForDateFormat:(FLCDateFormat)format locale:(NSLocale*)locale {
    
    [self reset];
    
    if (locale) {
        FLCGlobalDateFormatter.locale = locale;
    }
    
    switch (format) {            
        case FLCDateFormat_NoTime_ShortWeekdayName: {
            FLCGlobalDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E" options:0 locale:[NSLocale currentLocale]];
            break;
        }
        case FLCDateFormat_NoTime_ShortDate: {
            FLCGlobalDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"d.M.yyyy" options:0 locale:[NSLocale currentLocale]];
            break;
        }
        case FLCDateFormat_NoTime_MediumDateNoYear: {
            FLCGlobalDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"dd.MM." options:0 locale:[NSLocale currentLocale]];
            break;
        }
        case FLCDateFormat_NoTime_MediumDateWithDayname: {
            FLCGlobalDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EE, dd.MM." options:0 locale:[NSLocale currentLocale]];
            break;
        }
            
            
        case FLCDateFormat_NoTime_MediumDate_Relative: {
            FLCGlobalDateFormatter.doesRelativeDateFormatting = YES;
            FLCGlobalDateFormatter.timeStyle = NSDateFormatterNoStyle;
            FLCGlobalDateFormatter.dateStyle = NSDateFormatterMediumStyle;
            break;
        }
            
        case FLCDateFormat_ShortTime_ShortDate: {
            FLCGlobalDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"d.M.yyyy', 'HH':'mm" options:0 locale:[NSLocale currentLocale]];
            break;
        }
            
           
        // TODO [STH]: Reduce server communication date formats to exactly one! 1) Write tests! 2) Reduce formats 3) Validate correct behaviour through test results!
            
        case FLCDateFormat_RFC3339: {
            FLCGlobalDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            FLCGlobalDateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
            FLCGlobalDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            break;
        }
        case FLCDateFormat_ISO8601: {
            FLCGlobalDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            break;
        }
        case FLCDateFormat_ISO8601_NoTime_LongDate: {
            FLCGlobalDateFormatter.dateFormat = @"yyyy-MM-dd";
            break;
        }
        case FLCDateFormat_GMT_NoTime_MediumDate: {
            FLCGlobalDateFormatter.dateFormat = @"yyyy-MM-dd";
            FLCGlobalDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            break;
        }
        case FLCDateFormat_GMT_en_US_Locale: {
            FLCGlobalDateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZZ";
            FLCGlobalDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            break;
        }
        case FLCDateFormat_Zulu_DefaultTimeZone: {
            FLCGlobalDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
            FLCGlobalDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            break;
        }
        case FLCDateFormat_Zulu_NoTimeZone: {
            FLCGlobalDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
            FLCGlobalDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            FLCGlobalDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            break;
        }
        case FLCDateFormat_Zulu: {
            FLCGlobalDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
            FLCGlobalDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            FLCGlobalDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            break;
        }
        case FLCDateFormat_UTC: {
            FLCGlobalDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            break;
        }
            
            
        case FLCDateFormat_MAX: {
            // Just let the reset from above do its work...
            break;
        }
    }
}


#pragma mark - Public

+ (NSString*)stringFromDate:(NSDate*)date usingFormat:(FLCDateFormat)format {
    return [self stringFromDate:date usingFormat:format locale:nil];
}

+ (NSString*)stringFromDate:(NSDate*)date usingFormat:(FLCDateFormat)format locale:(NSLocale*)locale {
    __block NSString *dateString;
    
    dispatch_sync(FLCGlobaldateFormatterSerialDispatchQueue, ^{
        [self configureForDateFormat:format locale:locale];
        dateString = [FLCGlobalDateFormatter stringFromDate:date];
    });

    return dateString;
}

+ (NSDate*)dateFromString:(NSString*)dateString usingFormat:(FLCDateFormat)format {
    return [self dateFromString:dateString usingFormat:format locale:nil];
}

+ (NSDate*)dateFromString:(NSString*)dateString usingFormat:(FLCDateFormat)format locale:(NSLocale*)locale {
    __block NSDate *date;
    
    dispatch_sync(FLCGlobaldateFormatterSerialDispatchQueue, ^{
        [self configureForDateFormat:format locale:locale];
        date = [FLCGlobalDateFormatter dateFromString:dateString];
    });
    
    return date;
}

@end
