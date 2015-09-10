
#import "NSDate+Utilities.h"
#import "TSConstants.h"

@implementation NSDate (Utilities)

- (NSString *) timeStringWithGMTOffset:(NSInteger)offset militaryTime:(BOOL)militaryTime {
    
    NSTimeZone *localTimeZone = [NSTimeZone timeZoneForSecondsFromGMT: offset * SECONDS_IN_AN_HOUR];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:localTimeZone];
    
    if (militaryTime) {
        [dateFormatter setDateFormat:@"H:mm"];
        
    } else {
        [dateFormatter setDateFormat:@"h:mm a"];
    }
    
    return [dateFormatter stringFromDate:self];
}

- (CGFloat) militaryHourWithGMTOffset:(NSInteger)offset {
    
    NSTimeZone *localTimeZone = [NSTimeZone timeZoneForSecondsFromGMT: offset * SECONDS_IN_AN_HOUR];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:localTimeZone];
    
    [dateFormatter setDateFormat:@"H"];
    
    NSString *hourString = [dateFormatter stringFromDate:self];
    
    return hourString.floatValue;
}

- (NSAttributedString *) longDateWithGMTOffset:(NSUInteger)offset {
    
    NSTimeZone *localTimeZone = [NSTimeZone timeZoneForSecondsFromGMT: offset * SECONDS_IN_AN_HOUR];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:localTimeZone];
    
    [dateFormatter setDateFormat:@"EEEE, MMMM"];
    
    NSMutableString *longDate = [[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self]] mutableCopy];
    
    [dateFormatter setDateFormat:@"d"];
    
    NSString *day = [dateFormatter stringFromDate:self];
    
    [longDate appendString:[NSString stringWithFormat:@" %@",[self daySuffixForDate:day.integerValue]]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[longDate copy]];
    
    return [attrString copy];
}

- (NSString *)daySuffixForDate:(NSInteger)dayOfMonth {
    
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return [NSString stringWithFormat:@"%lust",(long)dayOfMonth];
        case 2:
        case 22: return [NSString stringWithFormat:@"%lund",(long)dayOfMonth];;
        case 3:
        case 23: return [NSString stringWithFormat:@"%lurd",(long)dayOfMonth];;
        default: return [NSString stringWithFormat:@"%luth",(long)dayOfMonth];;
    }
}

@end
