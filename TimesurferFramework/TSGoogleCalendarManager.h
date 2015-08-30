
#import <Foundation/Foundation.h>

@class UIViewController;

@protocol GoogleAuthenticationViewControllerPresentationDelegate <NSObject>

-(void)doMeAFavorAndPresentThisViewControllerNowWouldYou:(UIViewController*)controller;
-(void)thanksDearOneLastThingWouldYouKindlyDismissThatSameViewControllerForMe;

@end

@interface TSGoogleCalendarManager : NSObject

@property (nonatomic, weak) id<GoogleAuthenticationViewControllerPresentationDelegate> delegate;

-(instancetype)initWithDelegate:(id<GoogleAuthenticationViewControllerPresentationDelegate>)delegate;
-(void)authorize;

@end
