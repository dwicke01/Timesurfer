//
//  TSSettingsViewController.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 8/15/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSToggleSettingsManager, TSGoogleCalendarManager;

@interface TSSettingsViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, assign) BOOL darkTransparency;
@property (nonatomic, strong) TSToggleSettingsManager *settingsManager;
@property (nonatomic, strong) TSGoogleCalendarManager *googleCalendarManager;

@end
