//
//  main.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@import TimesurferFramework;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [TSViewController class];
        [TSBackgroundView class];
        [TSStarField class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
