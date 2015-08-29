#import "TSSettingsViewController.h"
#import <Masonry/Masonry.h>
#import "TSSettingsTableViewCell.h"
#import "TSToggleSettingsManager.h"
#import "TSGoogleCalendarManager.h"
#import "GTMOAuth2ViewControllerTouch.h"


@class TSViewController;

@interface TSSettingsViewController () <SettingToggleDelegate, GoogleAuthenticationViewControllerPresentationDelegate>

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSDictionary *settingsDictionary;
@property (nonatomic, strong) NSDictionary *settingsSwitch;

@end

@implementation TSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
    
    [self.view addGestureRecognizer:recognizer];

    [self setupSettingsDictionarySwitchAndArray];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.googleCalendarManager = [[TSGoogleCalendarManager alloc] initWithDelegate:self];
}

- (void)setupSettingsDictionarySwitchAndArray {
    __weak TSSettingsViewController *weakSelf = self;
    self.settingsDictionary = @{
                                  @"Squirrels" : @"toggleSquirrelAnimation",
                                  @"Cats and Dogs" : @"toggleCatsAndDogsAnimation",
                                  @"Sheep" : @"toggleSheepAnimation",
                                  @"Airplane" : @"toggleAirplaneAnimation",
                                  @"Helicopter" : @"toggleHelicopterAnimation",
                                  @"All Animations" : @"toggleAllAnimations",
                                  @"Use Google Calendar" : @"toggleGoogleCalendar"};
    self.settingsSwitch = @{
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
                                @"Use Google Calendar" : ^{
                                    weakSelf.settingsManager.toggleGoogleCalendar = !weakSelf.settingsManager.toggleGoogleCalendar;
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
    cell.delegate = self;
    NSNumber *settingState = [self.settingsManager valueForKey:self.settingsDictionary[cell.labelString]];
    cell.toggleAnimationSwitch.on = [settingState boolValue];
    return cell;
}

-(void)toggleSetting:(NSString *)setting {
    void (^settingToggleBlock)() = self.settingsSwitch[setting];
    settingToggleBlock();
}

- (IBAction)dismissVC {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)doMeAFavorAndPresentThisViewControllerNowWouldYou:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)thanksDearOneLastThingWouldYouKindlyDismissThatSameViewControllerForMe {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
