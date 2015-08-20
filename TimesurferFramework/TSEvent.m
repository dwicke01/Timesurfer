//
//  TSEvent.m
//  Timesurfer
//
//  Created by Daniel Wickes on 7/17/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSEvent.h"

@interface TSEvent ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *location;

@end

@implementation TSEvent

-(instancetype)initWithTitle:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime location:(NSString*)location {
    if (self = [super init]) {
        _title = title;
        _startTime = startTime;
        _endTime = endTime;
        _location = location;
    }
    return self;
}

-(NSTimeInterval)startTimeAsTimeInterval {
    return [self.startTime timeIntervalSince1970];
}

-(NSTimeInterval)endTimeAsTimeInterval {
    return [self.endTime timeIntervalSince1970];
}

- (NSString *)formatTime:(NSDate*)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *timeString = [formatter stringFromDate:time];
    if ([[timeString substringToIndex:1] isEqualToString:@"0"])
        timeString = [timeString substringFromIndex:1];
    return timeString;
}

- (NSString *)description
{
    NSMutableString *description = [@"" mutableCopy];
    [description appendFormat:@"%@\t%@ - %@",
     self.title,
     [self formatTime:self.startTime],
     [self formatTime:self.endTime]];
    if (self.location && ![self.location isEqualToString:@""])
        [description appendFormat:@"\n%@", self.location];
    return description;
}

@end
