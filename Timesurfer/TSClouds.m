#import "TSClouds.h"
#import "TSGraphics.h"

@interface TSClouds()

@end

@implementation TSClouds

- (void)drawRect:(CGRect)rect {
    
    if (self.weatherManager != nil) {

        [self drawClouds];
    }
    
}

- (void)drawClouds{
    
    CGFloat xWidth = (self.frame.size.width/25) * 1.2;
    CGFloat yHeight = self.frame.size.height;
    CGFloat xAxis = (self.frame.size.width/25);
    CGFloat xAxisOffset = 30;
    
    for (int i = 0; i < 25; i++) {
        
        TSWeather *weather = [self.weatherManager weatherForHour:i];
//            NSLog(@"Clouds %f Rain %f Intense %f Hour %lu",weather.cloudCoverFloat, weather.percentRainFloat, weather.precipIntensityFloat, i);
        
        if (weather.weatherPercentRain < 30) {
            
            if (weather.weatherCloudCover >= 0.69) {
                [TSGraphics drawHeavyCloudsWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
                
            }
        }
        
        if (weather.weatherPercentRain >= 90) {
            [TSGraphics drawHeaviestRainCloudsWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        } else if (weather.weatherPercentRain >= 80) {
            [TSGraphics drawHeavyRainCloudsWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        } else if (weather.weatherPercentRain >= 60) {
            [TSGraphics drawHeavyCloudsMediumRainWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        } else if (weather.weatherPercentRain >= 30) {
            [TSGraphics drawHeavyCloudsMayRainWithFrame:CGRectMake(xAxis * i - xAxisOffset, 0, xWidth, yHeight)];
            
        }
    }
}

- (void) setWeatherManager:(TSWeatherManager *)weatherManager {
    
    _weatherManager = weatherManager;
    [self setNeedsDisplay];
}

@end
