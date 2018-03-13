//
//  NSDate+Utility.h
//  CodoonSport
//
//  Created by Jinxiao on 9/3/14.
//  Copyright (c) 2014 codoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

- (BOOL)earlierThan:(NSDate *)date;
- (BOOL)laterThan:(NSDate *)date;
- (BOOL)sameMinuteAs:(NSDate *)date;
- (BOOL)sameDayAs:(NSDate *)date;
- (BOOL)sameYearAs:(NSDate *)date;
- (BOOL)sameWeekAs:(NSDate *)date;
- (BOOL)sameMonthAs:(NSDate *)date;
- (BOOL)sameSecondsAs:(NSDate *)date;

- (BOOL)afterDay:(NSDate *)date;
- (BOOL)beforeDay:(NSDate *)date;

- (NSDate *)previousDay;
- (NSDate *)nextDay;

- (NSDate *)nextWeek;

- (NSDate *)nextMonth;

- (NSInteger)year;

//for sportCircle
- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)weekDay;

- (NSDate *)dateAtStartOfWeek;
- (NSDate *)dateAtEndOfWeek;

- (NSDate *)dateAtStartOfDay;
- (NSDate *)dateAtEndOfDay;

- (NSDate *)dateAtStartOfMonth;
- (NSDate *)dateAtEndOfMonth;

- (NSDate *)dateAtStartOfYear;
- (NSDate *)dateAtEndOfYear;

- (NSDate *)monthAtStartOfYear;
- (NSDate *)monthAtEndOfYear;

- (NSDate *)dateByIgnoreSeconds;


- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingYears:(NSInteger)years;

- (NSInteger)numberOfYearsFromDate:(NSDate *)date;
- (NSInteger)numberOfMonthsFromDate:(NSDate *)date;
- (NSInteger)numberOfDaysFromDate:(NSDate *)date;
- (NSInteger)numberOfHoursFromDate:(NSDate *)date;
- (NSInteger)numberOfSecondsFromDate:(NSDate *)date;

@end

@interface NSDate (MachineTime)

+ (NSTimeInterval)machineAbsoluteTime;

@end

@interface NSDate (Range)

- (BOOL)inRangeFrom:(NSDate *)from to:(NSDate *)to;

@end
