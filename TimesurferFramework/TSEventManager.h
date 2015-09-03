
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface TSEventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;
@property (nonatomic, assign) BOOL eventsAccessRequested;

+(TSEventManager*)sharedEventManger;
-(NSString*)eventForHourAtIndex:(NSUInteger)index;
-(void)addGoogleCalendarEvents:(NSArray*)googleCalendarEvents;
-(void)toggleAppleCalendar;
-(void)toggleGoogleCalendar;
-(void)requestAccessToEventsWithCompletion:(void(^)())completion;
-(BOOL)calendarEnabled;

@end
