
#import "TSEvent.h"

@interface TSEvent ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign, readwrite) BOOL allDay;

@end

@implementation TSEvent

-(instancetype)initWithTitle:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime location:(NSString*)location allDay:(BOOL)allDay {
    if (self = [super init]) {
        _title = title;
        _startTime = startTime;
        _endTime = endTime;
        _location = location;
        _allDay = allDay;
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
    [description appendFormat:@"%@", self.title];
    if (!self.allDay) {
        NSString *times = [NSMutableString stringWithFormat:@"%@ - %@",
                           [self formatTime:self.startTime],
                           [self formatTime:self.endTime]];
        times = [times stringByReplacingOccurrencesOfString:@":00" withString:@""];
        [description appendString:[NSString stringWithFormat:@"  %@",times]];
    }
    return description;
}

@end
