
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Utilities)

- (NSString *) timeStringWithGMTOffset:(NSInteger)offset militaryTime:(BOOL)militaryTime;
- (CGFloat) militaryHourWithGMTOffset:(NSInteger)offset;
- (NSAttributedString *) longDateWithGMTOffset:(NSUInteger)offset;

@end
