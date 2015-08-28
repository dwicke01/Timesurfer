#import "TSSettingsViewController.h"
#import <Masonry/Masonry.h>
#import "TSSettingsTableViewCell.h"
#import "TSToggleSettingsManager.h"


@class TSViewController;

@interface TSSettingsViewController () <SettingToggleDelegate>

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSDictionary *settingsDictionary;

@end

@implementation TSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
    
    [self.view addGestureRecognizer:recognizer];

    [self setupSettingsDictionaryAndArray];
}

- (void)setupSettingsDictionaryAndArray {
    __weak TSSettingsViewController *weakSelf = self;
    self.settingsDictionary = @{
                                @"Squirrels" : ^{
                                    weakSelf.settingsManager.toggleSquirrelAnimation = !weakSelf.settingsManager.toggleSquirrelAnimation;
                                },
                                @"Cats and Dogs" : ^{
                                    weakSelf.settingsManager.toggleCatsAndDogsAnimation = !weakSelf.settingsManager.toggleCatsAndDogsAnimation;
                                },
                                @"Sheep" : ^{
                                    weakSelf.settingsManager.toggleSheepAnimation = !weakSelf.settingsManager.toggleSheepAnimation;
                                },
                                @"Airplane" : ^{
                                    weakSelf.settingsManager.toggleAirplaneAnimation = !weakSelf.settingsManager.toggleAirplaneAnimation;
                                },
                                @"Helicopter" : ^{
                                    weakSelf.settingsManager.toggleHelicopterAnimation = !weakSelf.settingsManager.toggleHelicopterAnimation;
                                },
                                @"All Animations" : ^{
                                    weakSelf.settingsManager.toggleAllAnimations = !weakSelf.settingsManager.toggleAllAnimations;
                                },
                                @"Use Google Calendar" : ^{ weakSelf.settingsManager.toggleGoogleCalendar = !weakSelf.settingsManager.toggleGoogleCalendar;
                                }};
    self.settingsArray = [self.settingsDictionary allKeys];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (self.darkTransparency) {
        
        [self.visualEffectView removeFromSuperview];
        self.visualEffectView = nil;
        
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        
        [self.view insertSubview:self.visualEffectView atIndex:0];
        
        [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
    } else {
        [self.visualEffectView removeFromSuperview];
        self.visualEffectView = nil;
        
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        
        [self.view insertSubview:self.visualEffectView atIndex:0];
        
        [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toggleSettingCell" forIndexPath:indexPath];
    cell.labelString = [self.settingsArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)toggleSetting:(NSString *)setting {
    void (^settingToggleBlock)() = self.settingsDictionary[setting];
    settingToggleBlock();
}

- (IBAction)dismissVC {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
