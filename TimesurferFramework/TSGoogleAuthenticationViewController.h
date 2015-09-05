//
//  TSGoogleAuthenticationViewController.h
//  Timesurfer
//
//  Created by Daniel Wickes on 8/31/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "GTMOAuth2ViewControllerTouch.h"

@protocol GoogleCalendarDelegate <NSObject>

@required
-(void)turnOffTheSwitch;
-(void)heyMisterDelegatePleaseActivateGoogleCalendar;

@end

@interface TSGoogleAuthenticationViewController : GTMOAuth2ViewControllerTouch

@property (nonatomic, weak) id<GoogleCalendarDelegate> googleCalendarDelegate;

@end
