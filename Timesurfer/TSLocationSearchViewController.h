
#import <UIKit/UIKit.h>

@protocol TSLocationSearchViewDelegate <NSObject>

- (void)updateWeatherWithLocation:(NSString *)location;

@end

@interface TSLocationSearchViewController : UIViewController

@property (nonatomic, weak) id<TSLocationSearchViewDelegate> delegate;

@end
