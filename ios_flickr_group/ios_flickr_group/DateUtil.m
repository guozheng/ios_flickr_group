//
//  DateUtil.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 8/17/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)getAgeFromDateCreate:(int)dateCreate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateCreate];
    NSTimeInterval interval = - [date timeIntervalSinceNow];

    NSTimeInterval const SECONDS_IN_A_MINUTE = 60.0;
    NSTimeInterval const SECONDS_IN_AN_HOUR = 3600.0;
    NSTimeInterval const SECONDS_IN_A_DAY = 86400.0;

    NSString *age = nil;

    if (interval < SECONDS_IN_A_MINUTE) {
        age = [NSString stringWithFormat:@"%.0fs", interval];
    } else if (interval < SECONDS_IN_AN_HOUR){
        age = [NSString stringWithFormat:@"%.0fm", interval/SECONDS_IN_A_MINUTE];
    } else if (interval < SECONDS_IN_A_DAY) {
        age = [NSString stringWithFormat:@"%.0fh", interval/SECONDS_IN_AN_HOUR];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"MM/dd/yy";
        age = [format stringFromDate:date];
    }

    return age;
}

@end
