//
//  TSAirplane.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 7/21/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSAirplane.h"
#import "TSGraphics.h"
@implementation TSAirplane


- (void)drawRect:(CGRect)rect{
    
    
    [TSGraphics drawPrivateJetWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
}


@end
