//
//  TSWeather.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/25/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TSWeather : NSObject

- (instancetype) initWithDictionary:(NSDictionary *)incomingDictionary;

@property (nonatomic, strong) UIImage *weatherImage;
@property (nonatomic, strong) NSString *weatherTemperature;
@property (nonatomic, assign) BOOL *dayTime;

@end
