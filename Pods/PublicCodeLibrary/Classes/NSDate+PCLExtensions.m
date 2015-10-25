/*!
 @file		NSDate+PCLExtensions.m
 @brief		Extensions for the class NSDate
 @author	Stefan Herold
 @date		2012-12-16
 @copyright	Copyright © 2015 Stefan Herold. All rights reserved.
 */

#import "NSDate+PCLExtensions.h"

@implementation NSDate(PCLExtensions)

- (NSDateFormatter *)dateFormatter {

	static NSDateFormatter * dateFormatter = nil;

	if ( dateFormatter == nil ) {

		dateFormatter =  [[NSDateFormatter alloc] init];
	}
	return dateFormatter;
}

- (NSString *)stringWithDefaultFormat:(NSDateFormatterStyle)dateFormat {

	[[self dateFormatter] setDateStyle:dateFormat];
	return [[self dateFormatter] stringFromDate:self];
}

- (NSString *)stringWithCustomFormatString:(NSString *)formatString {

	// Get format String for key from localization string table.
	[[self dateFormatter] setDateFormat:formatString];
	return [[self dateFormatter] stringFromDate:self];	
}

- (NSString *)stringWithCustomFormatFromLocalizationWithKey:(NSString *)formatKey fromBundle:(NSBundle*)bundle {

	// Get format String for key from localization string table.
	[[self dateFormatter] setDateFormat:NSLocalizedStringFromTableInBundle(formatKey, nil, bundle, @"")];
	return [[self dateFormatter] stringFromDate:self];	
}

+ (NSDate *)dateFromUTCString:(NSString *)timeString
{
	NSDate * result = nil;
	NSScanner * const scanner = [[NSScanner alloc] initWithString:timeString];

	NSInteger year = 0;
	NSInteger month = 0;
	NSInteger day = 0;
	NSInteger hour = 0;
	NSInteger minute = 0;
	NSInteger second = 0;

	if ( ![scanner scanInteger:&year] )               return result;
	if ( ![scanner scanString:@"-" intoString:NULL] ) return result;
	if ( ![scanner scanInteger:&month] )              return result;
	if ( ![scanner scanString:@"-" intoString:NULL] ) return result;
	if ( ![scanner scanInteger:&day] )                return result;
	if ( ![scanner scanString:@"T" intoString:NULL] ) return result;
	if ( ![scanner scanInteger:&hour] )               return result;
	if ( ![scanner scanString:@":" intoString:NULL] ) return result;
	if ( ![scanner scanInteger:&minute] )             return result;
	if ( ![scanner scanString:@":" intoString:NULL] ) return result;
	if ( ![scanner scanInteger:&second] )             return result;

	NSDateComponents * const dateComponents = [NSDateComponents new];
	[dateComponents setYear:year];
	[dateComponents setMonth:month];
	[dateComponents setDay:day];
	[dateComponents setHour:hour];
	[dateComponents setMinute:minute];
	[dateComponents setSecond:second];

	// Create new calendar and get components from it.
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//[calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	result = [calendar dateFromComponents:dateComponents];

	return result;
}

@end
