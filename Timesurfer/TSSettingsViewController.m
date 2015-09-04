#import "TSSettingsViewController.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import "TSSettingsViewController.h"
#import "TSSettingsTableViewCell.h"
#import "TSToggleSettingsManager.h"
#import "TSGoogleCalendarManager.h"
#import "TSEventManager.h"


@class TSViewController;

@interface TSSettingsViewController () <SettingToggleDelegate, UITableViewDelegate, GoogleAuthenticationViewControllerPresentationDelegate>

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSDictionary *settingsDictionary;
@property (nonatomic, strong) NSDictionary *settingsSwitch;
@property (nonatomic, assign) BOOL isSignedInToGoogle;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end

@implementation TSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSettingsDictionarySwitchAndArray];
    [self setupTapGesture];
    [self setupVisualEffectView];
    self.googleCalendarManager = [[TSGoogleCalendarManager alloc] initWithDelegate:self];
    _isSignedInToGoogle = NO;
    self.settingsTableView.delegate = self;
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
                                  @"Use Apple Calendar" : @"toggleAppleCalendar",
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
                                    BOOL settingForAllAnimations = weakSelf.settingsManager.toggleAllAnimations;
                                    weakSelf.settingsManager.toggleAirplaneAnimation = settingForAllAnimations;
                                    weakSelf.settingsManager.toggleCatsAndDogsAnimation = settingForAllAnimations;
                                    weakSelf.settingsManager.toggleHelicopterAnimation = settingForAllAnimations;
                                    weakSelf.settingsManager.toggleSheepAnimation = settingForAllAnimations;
                                    weakSelf.settingsManager.toggleSquirrelAnimation = settingForAllAnimations;
                                    
                                    for (TSSettingsTableViewCell *cell in [self.settingsTableView visibleCells]) {
                                        if (![cell.labelString isEqualToString:@"Use Google Calendar"] && ![cell.labelString isEqualToString:@"Use Apple Calendar"]) {
                                            cell.toggleAnimationSwitch.on = settingForAllAnimations;
                                        }
                                    }
                                },
                                @"Use Apple Calendar" : ^{
                                    TSEventManager *eventManager = [TSEventManager sharedEventManger];
                                    if (!eventManager.eventsAccessRequested) {
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Apple Calendar"
                                                                                                       message:@"Would you like to see your Apple Calendar Events?"
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        [alert addAction:[UIAlertAction actionWithTitle:@"Yes"
                                                                                  style:UIAlertActionStyleDefault
                                                                                handler:^(UIAlertAction *action) {
                                                                                    [eventManager requestAccessToEventsWithCompletion:^{
                                                                                        [weakSelf activateAppleCalendar:eventManager];
                                                                                    }];
                                                                                }]];
                                        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                for (TSSettingsTableViewCell *cell in [weakSelf.settingsTableView visibleCells]) {
                                                    if ([cell.labelString isEqualToString:@"Use Apple Calendar"]) {
                                                        cell.toggleAnimationSwitch.on = NO;
                                                    }
                                                }
                                            }];
                                        }]];
                                        [self presentViewController:alert animated:YES completion:nil];
                                    }
                                    else if (eventManager.eventsAccessGranted) {
                                        [weakSelf activateAppleCalendar:eventManager];
                                    }
                                },
                                @"Use Google Calendar" : ^{
                                    if (!self.isSignedInToGoogle) {
                                        [self.googleCalendarManager authorize];
                                        self.isSignedInToGoogle = YES;
                                    }
                                    
                                    if (weakSelf.settingsManager.toggleAppleCalendar) {
                                        weakSelf.settingsManager.toggleAppleCalendar = NO;
                                        for (TSSettingsTableViewCell *cell in [self.settingsTableView visibleCells]) {
                                            if ([cell.labelString isEqualToString:@"Use Apple Calendar"]) {
                                                cell.toggleAnimationSwitch.on = NO;
                                            }
                                        }
                                    }

                                    
                                    TSEventManager *eventManager = [TSEventManager sharedEventManger];
                                    [eventManager toggleGoogleCalendar];
                                    weakSelf.settingsManager.toggleGoogleCalendar = !weakSelf.settingsManager.toggleGoogleCalendar;
                                }};
    NSMutableArray *temp = [[[self.settingsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    [temp exchangeObjectAtIndex:0 withObjectAtIndex:1];
    self.settingsArray = temp;
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
        [self.delegate updateCalendarLabelOffOfSettingsDismissal];
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

- (void)activateAppleCalendar:(TSEventManager*)eventManager {
    [eventManager toggleAppleCalendar];
    eventManager.eventsAccessGranted = YES;
    eventManager.eventsAccessRequested = YES;
    
    self.settingsManager.toggleAppleCalendar = !self.settingsManager.toggleAppleCalendar;
    
    if (self.settingsManager.toggleGoogleCalendar) {
        self.settingsManager.toggleGoogleCalendar = NO;
        for (TSSettingsTableViewCell *cell in [self.settingsTableView visibleCells]) {
            if ([cell.labelString isEqualToString:@"Use Google Calendar"]) {
                cell.toggleAnimationSwitch.on = NO;
            }
        }
    }

}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.settingsTableView.bounds.size.height / [self.settingsArray count];
}

@end
