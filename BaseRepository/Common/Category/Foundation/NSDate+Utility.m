//
//  NSDate+Utility.m
//  CodoonSport
//
//  Created by Jinxiao on 9/3/14.
//  Copyright (c) 2014 codoon.com. All rights reserved.
//

#import "NSDate+Utility.h"
#import "CDCalendarManager.h"
#import <mach/mach.h>

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (Utility)

- (BOOL)earlierThan:(NSDate *)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)laterThan:(NSDate *)date
{
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)sameSecondsAs:(NSDate *)date {
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *comp1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    NSDateComponents *comp2 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    return comp1.minute == comp2.minute && comp1.hour == comp2.hour && comp1.day == comp2.day && comp1.month == comp2.month && comp1.year == comp2.year && comp1.second == comp2.second;
}

- (BOOL)sameMinuteAs:(NSDate *)date {
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *comp1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    NSDateComponents *comp2 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    return comp1.minute == comp2.minute && comp1.hour == comp2.hour && comp1.day == comp2.day && comp1.month == comp2.month && comp1.year == comp2.year;
}

- (BOOL)sameDayAs:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *comp1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDateComponents *comp2 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return comp1.day == comp2.day && comp1.month == comp2.month && comp1.year == comp2.year;
}

- (BOOL)sameYearAs:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *comp1 = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *comp2 = [calendar components:NSCalendarUnitYear fromDate:date];
    return comp1.year == comp2.year;
}

- (BOOL)sameWeekAs:(NSDate *)date
{
    NSCalendar *calendar = [[CDCalendarManager sharedInstance] calendarWithFirstWeekday:2];
    NSDateComponents *comp1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:self];
    NSDateComponents *comp2 = [calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:date];
    return comp1.weekOfYear == comp2.weekOfYear && comp1.year == comp2.year;
}

- (BOOL)sameMonthAs:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *comp1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:self];
    NSDateComponents *comp2 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    return comp1.month == comp2.month && comp1.year == comp2.year;
}

- (BOOL)afterDay:(NSDate *)date
{
    return ![self sameDayAs:date] && [self laterThan:date];
}

- (BOOL)beforeDay:(NSDate *)date
{
    return ![self sameDayAs:date] && [self earlierThan:date];
}

- (NSDate *)previousDay
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)nextDay
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)nextWeek
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekOfYear = 1;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)nextMonth
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSInteger)day
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: self];
    return components.day;
}

- (NSInteger)month
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay) fromDate: self];
    return components.month;
}

- (NSInteger)year
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate: self];
    return components.year;
}

- (NSInteger)weekDay
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate: self];

    return components.weekday;
}

- (NSDate *)dateAtStartOfMonth
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    
    NSDate *date = nil;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&date interval:0 forDate:self];
    
    NSDateComponents *components = [calendar components:componentFlags fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfMonth
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.day = range.length;
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfWeek
{
    NSCalendar *calendar = [[CDCalendarManager sharedInstance] calendarWithFirstWeekday:2];
    NSDate *date = nil;
    [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&date interval:nil forDate:self];
    
    NSDateComponents *components = [calendar components:componentFlags fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfWeek
{
    NSCalendar *calendar = [[CDCalendarManager sharedInstance] calendarWithFirstWeekday:2];
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    if (components.weekday != 1)
    {
        components.day += [calendar maximumRangeOfUnit:NSCalendarUnitWeekday].length - components.weekday + 1;
    }
    
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfDay
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfDay
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtStartOfYear
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    
    components.day = 1;
    components.month = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    NSDate *startOfYear = [calendar dateFromComponents:components];
    return startOfYear;
}

- (NSDate *)dateAtEndOfYear
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    components.month = monthRange.length;
    
    NSDate *endMonthOfYear = [calendar dateFromComponents:components];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:endMonthOfYear];
    components.day = dayRange.length;
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    NSDate *endOfYear = [calendar dateFromComponents:components];
    return endOfYear;
}

- (NSDate *)monthAtStartOfYear
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    
    components.day = 1;
    components.month = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    NSDate *startOfYear = [calendar dateFromComponents:components];
    return startOfYear;
}

- (NSDate *)monthAtEndOfYear
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self];
    components.month = monthRange.length;
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    components.day = dayRange.location;
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    NSDate *endOfYear = [calendar dateFromComponents:components];
    return endOfYear;
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = days;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = years;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByIgnoreSeconds
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;

    NSDateComponents *components = [calendar components:componentFlags fromDate:self];
    components.second = 0;
    NSDate *date = [calendar dateFromComponents:components];
    
    return date;
}

- (NSInteger)numberOfYearsFromDate:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:[date dateAtStartOfDay] toDate:[self dateAtStartOfDay] options:0];
    return components.year;
}

- (NSInteger)numberOfMonthsFromDate:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:[date dateAtStartOfMonth] toDate:[self dateAtStartOfMonth] options:0];
    return components.month;
}

- (NSInteger)numberOfDaysFromDate:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:[date dateAtStartOfDay] toDate:[self dateAtStartOfDay] options:0];
    return components.day;
}

- (NSInteger)numberOfHoursFromDate:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:date toDate:self options:0];
    return components.hour;
}

- (NSInteger)numberOfSecondsFromDate:(NSDate *)date
{
    NSCalendar *calendar = [CDCalendarManager sharedInstance].defaultCalendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:date toDate:self options:0];
    return components.second;
}

@end

#include <sys/param.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/sysctl.h>
#include <sys/proc.h>
#include <sys/socket.h>

@implementation NSDate (MachineTime)

+ (NSTimeInterval)machineAbsoluteTime {
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    (void)time(&now);

    if(sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = now - boottime.tv_sec;
    }

    return uptime;
}

@end


@implementation NSDate (Range)

- (BOOL)inRangeFrom:(NSDate *)from to:(NSDate *)to {
    if(from == nil) {
        from = [NSDate distantPast];
    }

    if(to == nil) {
        to = [NSDate distantFuture];
    }

    return self.timeIntervalSince1970 >= from.timeIntervalSince1970 && self.timeIntervalSince1970 <= to.timeIntervalSince1970;
}

@end
