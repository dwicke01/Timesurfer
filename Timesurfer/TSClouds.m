//
//  TSSheepClouds.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 7/12/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSClouds.h"
#import "TSGraphics.h"


@interface TSClouds()


@end

@implementation TSClouds

- (void)drawRect:(CGRect)rect {
    
    if (self.weatherData != nil) {

        [self doABarrelRoll];
    }
    
}


- (void)doABarrelRoll{
    
    CGFloat xWidth = (self.frame.size.width/24);
    CGFloat yHeight = self.frame.size.height;
    
    for (int i = 1; i <= 24; i++) {
        
        TSWeather *weather = [self.weatherData weatherForHour:i];
           // NSLog(@"Clouds %f Rain %f Intense %f Hour %lu",weather.cloudCoverFloat, weather.percentRainFloat, weather.precipIntensityFloat, weather.currentHourInt);
        
        if (weather.percentRainFloat <= 30) {
            
            if (weather.cloudCoverFloat >= .7) {
                [TSGraphics drawHeavyCloudsWithFrame:CGRectMake(xWidth * i, 0, xWidth * 1.08, yHeight)];
                
            }
        }
        
        if (weather.percentRainFloat >= 80) {
            [TSGraphics drawHeavyRainCloudsWithFrame:CGRectMake(xWidth * i, 0, xWidth * 1.08, yHeight)];
            
        } else if (weather.percentRainFloat >= 70) {
            [TSGraphics drawHeavyCloudsHeavyRainWithFrame:CGRectMake(xWidth * i, 0, xWidth * 1.08, yHeight)];
            
        } else if (weather.percentRainFloat >= 50) {
            [TSGraphics drawHeavyCloudsMediumRainWithFrame:CGRectMake(xWidth * i, 0, xWidth * 1.08, yHeight)];
            
        } else if (weather.percentRainFloat >= 40) {
            [TSGraphics drawHeavyCloudsLightRainWithFrame:CGRectMake(xWidth * i, 0, xWidth * 1.08, yHeight)];
            
        }
    }
}

- (void) setWeatherData:(TSWeatherData *)weatherData {
    
    _weatherData = weatherData;
    [self setNeedsDisplay];
}

@end
