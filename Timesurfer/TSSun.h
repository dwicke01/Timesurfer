//
//  TSSun.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 7/19/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSun : UIView

-(void)makeDisplayLinkIfNeeded;
-(void)destroyDisplayLink;

@end
