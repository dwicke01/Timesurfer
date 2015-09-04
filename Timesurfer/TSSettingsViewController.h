
#import <UIKit/UIKit.h>

@protocol CalendarEventLabelHidingDelegate <NSObject>

-(void)updateCalendarLabelOffOfSettingsDismissal;

@end

@class TSToggleSettingsManager, TSGoogleCalendarManager;

@interface TSSettingsViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) TSToggleSettingsManager *settingsManager;
@property (nonatomic, strong) TSGoogleCalendarManager *googleCalendarManager;
@property (nonatomic, weak) id<CalendarEventLabelHidingDelegate> delegate;

@end
