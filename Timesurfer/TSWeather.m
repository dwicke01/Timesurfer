//
//  TSWeather.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/25/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSWeather.h"

@interface TSWeather()

@property (nonatomic, strong) NSDictionary *incomingDictionary;

@end

@implementation TSWeather


- (instancetype)initWithDictionary:(NSDictionary *)incomingDictionary{
    
    self = [super init];
    
    if (self) {
        _incomingDictionary = incomingDictionary;
    }
    
    return self;
}


@end
