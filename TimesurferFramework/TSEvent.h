
#import <Foundation/Foundation.h>

@interface TSEvent : NSObject

-(instancetype)initWithTitle:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime location:(NSString*)location;
-(NSTimeInterval)startTimeAsTimeInterval;
-(NSTimeInterval)endTimeAsTimeInterval;

@end
