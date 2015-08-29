//
//  SettingsTableViewCell.m
//  Timesurfer
//
//  Created by Daniel Wickes on 8/26/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSSettingsTableViewCell.h"

@interface TSSettingsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *settingTypeLabel;

@end

@implementation TSSettingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleSetting:(id)sender {
    [self.delegate toggleSetting:self.settingTypeLabel.text];
}

- (void)setLabelString:(NSString *)labelString {
    _labelString = labelString;
    _settingTypeLabel.text = labelString;
}

@end
