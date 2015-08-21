#import "TSClouds.h"
#import "TSGraphics.h"

@interface TSClouds()

@end

@implementation TSClouds

- (void)drawRect:(CGRect)rect {
    
    if (self.weatherData != nil) {

        [self drawClouds];
    }
    
}

- (void)drawClouds{
    
    CGFloat xWidth = (self.frame.size.width/25) * 1.2;
    CGFloat yHeight = self.frame.size.height;
    CGFloat xAxis = (self.frame.size.width/25);
    CGFloat xAxisOffset = 30;
    
    for (int i = 0; i < 25; i++) {
        
        TSWeather *weather = [self.weatherData weatherForHour:i];
//            NSLog(@"Clouds %f Rain %f Intense %f Hour %lu",weather.cloudCoverFloat, weather.percentRainFloat, weather.precipIntensityFloat, weather.currentHourInt);
        
        if (weather.percentRainFloat <= 30) {
            
            if (weather.cloudCoverFloat >= 0.69) {
                [TSGraphics drawHeavyCloudsWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
                
            } else if (weather.percentRainFloat == 30 || weather.cloudCoverFloat >= 0.49) {
                [TSGraphics drawMediumCloudsWithFrame:CGRectMake(xAxis * i + 10, 0, xAxis, yHeight)];
                
            }
        }
        
        if (weather.percentRainFloat >= 90) {
            [TSGraphics drawHeaviestRainCloudsWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        } else if (weather.percentRainFloat >= 80) {
            [TSGraphics drawHeavyRainCloudsWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        } else if (weather.percentRainFloat >= 70) {
            [TSGraphics drawHeavyCloudsHeavyRainWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        } else if (weather.percentRainFloat >= 50) {
            [TSGraphics drawHeavyCloudsMediumRainWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        } else if (weather.percentRainFloat >= 40) {
            [TSGraphics drawHeavyCloudsLightRainWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        }
    }
}

- (void) setWeatherData:(TSWeatherManager *)weatherData {
    
    _weatherData = weatherData;
    [self setNeedsDisplay];
}

@end
