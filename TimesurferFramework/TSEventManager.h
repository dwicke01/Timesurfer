
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface TSEventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;
@property (nonatomic, assign) BOOL eventsAccessRequested;

+(TSEventManager*)sharedEventManger;
-(NSString*)eventsForHourAtIndex:(NSUInteger)index;
-(void)addGoogleCalendarEvents:(NSArray*)googleCalendarEvents;
-(void)toggleAppleCalendar;
-(void)toggleGoogleCalendar;
-(void)fetchEvents;
-(void)requestAccessToEventsWithCompletion:(void(^)())completion;
-(BOOL)calendarEnabled;

@end
