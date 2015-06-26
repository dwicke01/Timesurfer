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

- (instancetype) initWithDictionary:(NSDictionary *)incomingDictionary sunRiseString:(NSString *)sunRiseString sunSetString:(NSString *)sunSetString;

@property (nonatomic, strong) UIImage *weatherImage;
@property (nonatomic, strong) NSString *currentDate;
@property (nonatomic, strong) NSString *weatherTemperature;
@property (nonatomic, strong) NSString *percentRainString;
@property (nonatomic, assign) BOOL sunRiseHour;
@property (nonatomic, assign) BOOL sunSetHour;
@property (nonatomic, assign) NSUInteger percentRainInt;
@property (nonatomic, assign) NSUInteger cloudCoverInt;
@property (nonatomic, assign) NSUInteger precipIntensity;

@end
