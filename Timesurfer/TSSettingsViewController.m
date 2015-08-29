#import <Masonry/Masonry.h>
#import "TSSettingsViewController.h"
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
    
    [self setupSettingsDictionaryAndArray];
    [self setupTapGesture];
    [self setupVisualEffectView];
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
                                @"Plane" : ^{
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
    self.settingsArray = [[self.settingsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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

@end
