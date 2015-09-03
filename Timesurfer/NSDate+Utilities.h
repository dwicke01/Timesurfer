
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Utilities)

- (NSString *) timeStringWithGMTOffset:(NSInteger)offset militaryTime:(BOOL)militaryTime;
- (CGFloat) militaryHourWithGMTOffset:(NSInteger)offset;
- (NSString *) longDateWithGMTOffset:(NSUInteger)offset;

@end
