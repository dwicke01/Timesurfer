#import "TSSettingsViewController.h"
#import <Masonry/Masonry.h>
#import "TSSettingsViewController.h"
#import "TSSettingsTableViewCell.h"
#import "TSToggleSettingsManager.h"
#import "TSGoogleCalendarManager.h"
#import "TSEventManager.h"
#import "GTMOAuth2ViewControllerTouch.h"

@class TSViewController;

@interface TSSettingsViewController () <SettingToggleDelegate, GoogleAuthenticationViewControllerPresentationDelegate>

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSDictionary *settingsDictionary;
@property (nonatomic, strong) NSDictionary *settingsSwitch;
@property (nonatomic, assign) BOOL isSignedInToGoogle;

@end

@implementation TSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSettingsDictionarySwitchAndArray];
    [self setupTapGesture];
    [self setupVisualEffectView];
    self.googleCalendarManager = [[TSGoogleCalendarManager alloc] initWithDelegate:self];
    _isSignedInToGoogle = NO;
}

- (void) setupVisualEffectView {
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    [self.view insertSubview:self.visualEffectView atIndex:0];
    
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void) setupTapGesture {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.view addGestureRecognizer:recognizer];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.googleCalendarManager = [[TSGoogleCalendarManager alloc] initWithDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.settingsManager saveEverything];
    [super viewWillDisappear:animated];
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
                                    if (!self.isSignedInToGoogle) {
                                        [self.googleCalendarManager authorize];
                                        self.isSignedInToGoogle = YES;
                                    }
                                    TSEventManager *eventManager = [TSEventManager sharedEventManger];
                                    [eventManager toggleGoogleCalendar];
                                    weakSelf.settingsManager.toggleGoogleCalendar = !weakSelf.settingsManager.toggleGoogleCalendar;
                                }};
    self.settingsArray = [[self.settingsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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

- (void)tapHandler:(UITapGestureRecognizer *)sender {
    
    UIView *containerView = [sender view];
   
    // Shrink tappable area to prevent dismissing settings when tapping switches
    CGRect bounds = CGRectMake(0, 0, containerView.bounds.size.width - 100, containerView.bounds.size.height);
    
    if (CGRectContainsPoint(bounds, [sender locationInView:containerView])) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
