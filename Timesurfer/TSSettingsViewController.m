#import "TSSettingsViewController.h"
#import <Masonry/Masonry.h>

@interface TSSettingsViewController ()

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation TSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
    
    [self.view addGestureRecognizer:recognizer];
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

- (IBAction)dismissVC {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
