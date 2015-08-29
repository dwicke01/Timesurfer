
#import <UIKit/UIKit.h>

@class TSToggleSettingsManager;

@interface TSSettingsViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) TSToggleSettingsManager *settingsManager;

@end
