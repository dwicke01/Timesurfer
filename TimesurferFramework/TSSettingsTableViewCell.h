//
//  SettingsTableViewCell.h
//  Timesurfer
//
//  Created by Daniel Wickes on 8/26/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSViewController.h"

@protocol SettingToggleDelegate <NSObject>

-(void)toggleSetting:(NSString*)setting;

@end

@interface TSSettingsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SettingToggleDelegate> delegate;
@property (nonatomic, strong) NSString *labelString;

@end
