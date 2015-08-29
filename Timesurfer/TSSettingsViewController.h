
#import <UIKit/UIKit.h>

@class TSToggleSettingsManager, TSGoogleCalendarManager;

@interface TSSettingsViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) TSToggleSettingsManager *settingsManager;
@property (nonatomic, strong) TSGoogleCalendarManager *googleCalendarManager;

@end
