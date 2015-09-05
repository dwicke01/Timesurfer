//
//  TSGoogleAuthenticationViewController.m
//  Timesurfer
//
//  Created by Daniel Wickes on 8/31/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSGoogleAuthenticationViewController.h"
#import <Masonry/Masonry.h>

@interface TSGoogleAuthenticationViewController ()

@end

@implementation TSGoogleAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavigation];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@   {NSForegroundColorAttributeName : [UIColor blueColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 63)];
    [self.view addSubview:naviBarObj];
    
    UIView *superview = self.view;
    [naviBarObj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@63);
    }];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Cancel", nil)] style:UIBarButtonItemStylePlain target:self
                                                                 action:@selector(cancelGdriveSignIn:)];
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Google Calendar"];
    navigItem.rightBarButtonItem = cancelItem;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelGdriveSignIn:(id)sender
{
    [self.googleCalendarDelegate turnOffTheSwitch];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end