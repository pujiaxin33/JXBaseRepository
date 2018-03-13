//
//  NSTimer+Callback.h
//  CodoonBluetoothKit
//
//  Created by CHEN on 15/7/24.
//  Copyright (c) 2015年 com.codoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(Callback)

/** Creates and returns a block-based NSTimer object and schedules it on the current run loop.
 @param inTimeInterval The number of seconds between firings of the timer.
 @param inBlock The block that the NSTimer fires.
 @param inRepeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
 @return A new NSTimer object, configured according to the specified parameters.
 */
+ (NSTimer *)cd_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))inBlock repeats:(BOOL)inRepeats;

/** Creates and returns a block-based NSTimer initialized with the specified block.
 You must add the new timer to a run loop, using `-addTimer:forMode:`. Then,
 after seconds seconds have elapsed, the timer fires the block.  If the timer
 is configured to repeat, there is no need to subsequently re-add the timer.
 @param inTimeInterval The number of seconds between firings of the timer.
 @param inBlock The block that the NSTimer fires.
 @param inRepeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
 @return A new NSTimer object, configured according to the specified parameters.
 */
+ (NSTimer *)cd_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))inBlock repeats:(BOOL)inRepeats;

@end
