//
//  TSEvent.h
//  Timesurfer
//
//  Created by Daniel Wickes on 7/17/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSEvent : NSObject

-(instancetype)initWithTitle:(NSString*)title startTime:(NSDate*)startTime endTime:(NSDate*)endTime location:(NSString*)location;
-(NSTimeInterval)startTimeAsTimeInterval;
-(NSTimeInterval)endTimeAsTimeInterval;

@end
