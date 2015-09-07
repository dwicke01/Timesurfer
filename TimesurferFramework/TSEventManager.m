
#import "TSEventManager.h"
#import "TSEvent.h"
#import <UIKit/UIKit.h>

@implementation TSEventManager {
    NSMutableArray *_localCalendarEventsArray;
    NSArray *_googleCalendarEventsArray;
    BOOL _useAppleCalendar;
    BOOL _useGoogleCalendar;
}

static TSEventManager *_sharedEventManager;
static const double SECONDS_IN_AN_HOUR = 3600;

+(TSEventManager*)sharedEventManger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedEventManager = [[TSEventManager alloc] init];
    });
    return _sharedEventManager;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.eventStore = [[EKEventStore alloc] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.eventsAccessRequested = [userDefaults boolForKey:@"eventsAccessRequested"];
        self.eventsAccessGranted = [userDefaults boolForKey:@"eventsAccessGranted"];
        
        if (self.eventsAccessGranted) {
            [self fetchEvents];
        }

        _useAppleCalendar = [[NSUserDefaults standardUserDefaults] boolForKey:@"appleCalendar"];
        _useGoogleCalendar = [[NSUserDefaults standardUserDefaults] boolForKey:@"googleCalendar"];
        _googleCalendarEventsArray = @[];
    }
    return self;
}

-(void)requestAccessToEventsWithCompletion:(void(^)())completion{
    self.eventsAccessRequested = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"eventsAccessRequested"];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.eventsAccessGranted = granted;
            [[NSUserDefaults standardUserDefaults] setBool:granted forKey:@"eventsAccessGranted"];
            if (granted) {
                completion();
            }
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(NSArray *)getLocalEventCalendars{
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
    
    for (int i=0; i<allCalendars.count; i++) {
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        [localCalendars addObject:currentCalendar];
    }
    
    return (NSArray *)localCalendars;
}

-(void)setEventsAccessGranted:(BOOL)eventsAccessGranted{
    _eventsAccessGranted = eventsAccessGranted;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

-(void) fetchEvents{
    NSDate *startDate = [NSDate date] ;
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
    
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    // We will only search the default calendar for our events
    NSArray *calendarArray = [self getLocalEventCalendars];
    
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
    
    // Fetch all events that match the predicate
    NSArray *ekEventsArray = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
    _localCalendarEventsArray = [@[] mutableCopy];
    
    for (EKEvent *event in ekEventsArray) {
        [_localCalendarEventsArray addObject:[[TSEvent alloc] initWithTitle:event.title startTime:event.startDate endTime:event.endDate location:event.location allDay:event.allDay]];
    }
}

- (NSDate*) previousHourDate:(NSDate*)inDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSCalendarUnitEra|NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate: inDate];
    return [calendar dateFromComponents:comps];
}

-(NSAttributedString*)eventsForHourAtIndex:(NSUInteger)index {
    NSMutableAttributedString *eventsString = [[NSMutableAttributedString alloc] init]; //[@"" mutableCopy];
    if ([self calendarEnabled]) {
        NSArray *useThisCalendarArray;
        if (_useGoogleCalendar) {
            useThisCalendarArray = _googleCalendarEventsArray;
        }
        else {
            if (!_localCalendarEventsArray) {
                [self fetchEvents];
            }
            useThisCalendarArray = _localCalendarEventsArray;
        }
        
        NSTimeInterval desiredStartTimeInterval = [[self previousHourDate:[NSDate date]] timeIntervalSince1970] + index * SECONDS_IN_AN_HOUR;
        NSTimeInterval desiredEndTimeInterval = desiredStartTimeInterval + SECONDS_IN_AN_HOUR;
        
        NSPredicate *allDayPred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            TSEvent *event = evaluatedObject;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *eventComps = [calendar components: NSCalendarUnitDay fromDate: [NSDate dateWithTimeIntervalSince1970:event.startTimeAsTimeInterval]];
            NSDateComponents *nowComps = [calendar components: NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:desiredStartTimeInterval]];
            return event.allDay && ([eventComps day] == [nowComps day]);
        }];
        NSArray *allDayEvents = [useThisCalendarArray filteredArrayUsingPredicate:allDayPred];
        for (TSEvent *event in allDayEvents) {
            [eventsString appendAttributedString: [event attributedDescription]];
            [eventsString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
        
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            TSEvent *event = evaluatedObject;
            return  !event.allDay &&
                    (([event startTimeAsTimeInterval] < desiredEndTimeInterval && [event endTimeAsTimeInterval] >= desiredEndTimeInterval) ||
                     ([event startTimeAsTimeInterval] <= desiredStartTimeInterval && [event endTimeAsTimeInterval] > desiredStartTimeInterval));
                    //[event startTimeAsTimeInterval] <= desiredTimeInterval &&
                    //[event endTimeAsTimeInterval] > desiredTimeInterval &&
                    //!event.allDay;
        }];
        NSArray *filteredHourlyEvents = [useThisCalendarArray filteredArrayUsingPredicate:pred];
        for (TSEvent *event in filteredHourlyEvents) {
            [eventsString appendAttributedString: [event attributedDescription]];
            [eventsString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    NSMutableParagraphStyle *centered = [[NSMutableParagraphStyle alloc] init];
    centered.alignment = NSTextAlignmentCenter;
    [eventsString addAttribute:NSParagraphStyleAttributeName value:centered range:NSMakeRange(0, [eventsString length])];
    
    [eventsString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [eventsString length])];
    
    NSAttributedString *adjustedEventsString = eventsString;
    if ([eventsString length] > 0) {
        adjustedEventsString = [eventsString attributedSubstringFromRange:NSMakeRange(0, [eventsString length]-1)];
    }
    return adjustedEventsString;
}

-(void)addGoogleCalendarEvents:(NSArray*)googleCalendarEvents {
    _googleCalendarEventsArray = googleCalendarEvents;
}

-(BOOL)calendarEnabled {
    return _useAppleCalendar || _useGoogleCalendar;
}

-(void)toggleAppleCalendar {
    _useAppleCalendar = !_useAppleCalendar;
    _useGoogleCalendar = NO;
}

-(void)toggleGoogleCalendar {
    _useGoogleCalendar = !_useGoogleCalendar;
    _useAppleCalendar = NO;
}
@end
