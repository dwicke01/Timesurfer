
#import "TodayViewController.h"
#define AF_APP_EXTENSIONS
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController()

@property (nonatomic, assign) NSUInteger hourIndex;

@property (weak, nonatomic) IBOutlet UIView *leftChevronFrame;
@property (weak, nonatomic) IBOutlet UIView *rightChevronFrame;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


@end

@implementation TodayViewController {
    NSInteger _time;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *leftTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapped:)];
    
    [self.leftButton addGestureRecognizer:leftTapGesture];
    
    UITapGestureRecognizer *rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapped:)];
    
    [self.rightButton addGestureRecognizer:rightTapGesture];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startUpdatingLocation];
    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, 200);
    
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 8, 8, 0);
}


- (void)leftTapped:(UITapGestureRecognizer *)recognizer {
    
    NSLog(@"Tapped");
    
    if (self.hourIndex > 0) {
            self.hourIndex--;
    }
    
    [self updateWeatherLabelsWithIndex:self.hourIndex % 24];
}

- (void)rightTapped:(UITapGestureRecognizer *)recognizer {
    
    NSLog(@"Tapped");
    
    if (self.hourIndex < 23) {
        self.hourIndex++;
    }
    
    [self updateWeatherLabelsWithIndex:self.hourIndex % 24];
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
