
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface TSEventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;

+(TSEventManager*)sharedEventManger;
-(NSString*)eventForHourAtIndex:(NSUInteger)index;
-(void)addGoogleCalendarEvents:(NSArray*)googleCalendarEvents;
-(void)toggleGoogleCalendar;

@end
