
#import <Foundation/Foundation.h>
#import "TSGoogleAuthenticationViewController.h"

@class UIViewController;

@protocol GoogleAuthenticationViewControllerPresentationDelegate <NSObject>

-(void)doMeAFavorAndPresentThisViewControllerNowWouldYou:(UIViewController*)controller;
-(void)thanksDearOneLastThingWouldYouKindlyDismissThatSameViewControllerForMe;

@end

@interface TSGoogleCalendarManager : NSObject

@property (nonatomic, weak) id<GoogleAuthenticationViewControllerPresentationDelegate> delegate;
@property (nonatomic, weak) id<GoogleCalendarDelegate> googleCalendarDelegate;

-(instancetype)initWithDelegate:(id<GoogleAuthenticationViewControllerPresentationDelegate>)delegate;
-(void)authorizeWithCalendarDelegate:(id<GoogleCalendarDelegate>)delegate;

@end
