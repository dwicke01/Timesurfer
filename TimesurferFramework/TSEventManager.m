//
//  TSEventManager.m
//  Timesurfer
//
//  Created by Daniel Wickes on 7/15/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSEventManager.h"
#import "TSEvent.h"

@implementation TSEventManager

static TSEventManager *_sharedEventManager;


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
        [self requestAccessToEvents];

        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Check if the access granted value for the events exists in the user defaults dictionary.
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
            // The value exists, so assign it to the property.
            self.eventsAccessGranted = [[userDefaults valueForKey:@"eventkit_events_access_granted"] intValue];
        }
        else{
            // Set the default value.
            self.eventsAccessGranted = NO;
        }
    }
    return self;
}

-(void)requestAccessToEvents{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.eventsAccessGranted = granted;
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
        //if (currentCalendar.type == EKCalendarType) {
            [localCalendars addObject:currentCalendar];
        //}
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
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
    EKEvent *event = events[0];
    TSEvent *event1 = [[TSEvent alloc] initWithTitle:event.title startTime:event.startDate endTime:event.endDate location:event.location];
    
    NSLog(@"%@", [event1 description]);
}

@end
