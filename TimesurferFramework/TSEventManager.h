//
//  TSEventManager.h
//  Timesurfer
//
//  Created by Daniel Wickes on 7/15/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface TSEventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;

+(TSEventManager*)sharedEventManger;
-(void) fetchEvents;
@end
