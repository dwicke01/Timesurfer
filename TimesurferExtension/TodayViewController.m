
#import "TodayViewController.h"
#define AF_APP_EXTENSIONS
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController()

@property (nonatomic, assign) NSUInteger hourIndex;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TodayViewController {
    NSInteger _time;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(extensionTapped:)];
    
    [self.containerView addGestureRecognizer:tapGesture];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startUpdatingLocation];
    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 200);
    
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)extensionTapped:(id)sender {
    
    [self updateWeatherLabelsWithIndex:self.hourIndex % 23];
    
    self.hourIndex++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

@end
