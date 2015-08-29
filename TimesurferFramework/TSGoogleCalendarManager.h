//
//  TSGoogleCalendarManager.h
//  Timesurfer
//
//  Created by Daniel Wickes on 7/17/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@protocol GoogleAuthenticationViewControllerPresentationDelegate <NSObject>

-(void)doMeAFavorAndPresentThisViewControllerNowWouldYou:(UIViewController*)controller;
-(void)thanksDearOneLastThingWouldYouKindlyDismissThatSameViewControllerForMe;

@end

@interface TSGoogleCalendarManager : NSObject

@property (nonatomic, weak) id<GoogleAuthenticationViewControllerPresentationDelegate> delegate;

-(instancetype)initWithDelegate:(id<GoogleAuthenticationViewControllerPresentationDelegate>)delegate;

@end
