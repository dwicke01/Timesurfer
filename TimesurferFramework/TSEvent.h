
#import <Foundation/Foundation.h>

@interface TSEvent : NSObject

-(instancetype)initWithTitle:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime location:(NSString*)location allDay:(BOOL)allDay;
-(NSTimeInterval)startTimeAsTimeInterval;
-(NSTimeInterval)endTimeAsTimeInterval;

@property (nonatomic, assign, readonly) BOOL allDay;

@end
