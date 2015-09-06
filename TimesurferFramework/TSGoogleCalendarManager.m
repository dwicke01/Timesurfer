#import "TSEventManager.h"
#import "TSEvent.h"
#import "TSGoogleCalendarManager.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"
#import "TSGoogleAuthenticationViewController.h"
#import "TSConstants.h"
#import "GTMOAuth2SignIn.h"

@interface TSGoogleCalendarManager ()

@property (nonatomic, strong) GTLServiceCalendar *service;

@end

@implementation TSGoogleCalendarManager

-(instancetype)initWithDelegate:(id<GoogleAuthenticationViewControllerPresentationDelegate>)delegate {
    if (self = [super init]) {
        // Initialize the Google Calendar API service & load existing credentials from the keychain if available.
        self.delegate = delegate;
        self.service = [[GTLServiceCalendar alloc] init];
        //[self.service.authorize];
        self.service.authorizer = [TSGoogleAuthenticationViewController authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kClientID
                                                          clientSecret:kClientSecret];
        
        //[self authorize];
    }
    return self;
}

// When the view appears, ensure that the Google Calendar API service is authorized, and perform API calls.
-(void)authorizeWithCalendarDelegate:(id<GoogleCalendarDelegate>)delegate {
    self.googleCalendarDelegate = delegate;

    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self.delegate doMeAFavorAndPresentThisViewControllerNowWouldYou:[self createAuthControllerWithCalendarDelegate:delegate]];
        //[self presentViewController:[self createAuthController] animated:YES completion:nil];
        
    } else {
        [self fetchEvents];
    }
}

// Construct a query and get a list of upcoming events from the user calendar.
- (void)fetchEvents {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"primary"];
    query.timeMin = [GTLDateTime dateTimeWithDate:[NSDate date]
                                         timeZone:[NSTimeZone localTimeZone]];;
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    query.timeMax = [GTLDateTime dateTimeWithDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60]
                                         timeZone:[NSTimeZone localTimeZone]];
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

- (void)displayResultWithTicket:(GTLServiceTicket *)ticket
             finishedWithObject:(GTLCalendarEvents *)events
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *eventString = [[NSMutableString alloc] init];
        if (events.items.count > 0) {
            TSEventManager *eventManager = [TSEventManager sharedEventManger];
            NSMutableArray *tsEvents = [@[] mutableCopy];
            for (GTLCalendarEvent *event in events) {
                GTLDateTime *start = event.start.dateTime ?: event.start.date;
                NSString *startString = [NSDateFormatter localizedStringFromDate:[start date]   
                                               dateStyle:NSDateFormatterShortStyle
                                               timeStyle:NSDateFormatterShortStyle];
                
                [eventString appendFormat:@"%@ - %@\n", startString, event.summary];
                
                BOOL isAllDay = event.start.dateTime == nil;
                NSDate *startTime = event.start.dateTime.date;
                NSDate *endTime = event.end.dateTime.date;
                if (isAllDay) {
                    startTime = event.start.date.date;
                }
                
                TSEvent *tsEvent = [[TSEvent alloc] initWithTitle:event.summary startTime:startTime endTime:endTime location:event.location allDay:isAllDay];
                
                [tsEvents addObject:tsEvent];
            }
            [eventManager addGoogleCalendarEvents:tsEvents];
        } else {
            [eventString appendString:@"No upcoming events found."];
        }
        NSLog(@"%@", eventString);
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];   ///// UNTESTED!!!!!!!! /////////
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self.delegate doMeAFavorAndPresentThisViewControllerNowWouldYou:alert];
    }
}



// Creates the auth controller for authorizing access to Google Calendar API.
- (GTMOAuth2ViewControllerTouch *)createAuthControllerWithCalendarDelegate:(id<GoogleCalendarDelegate>)delegate {
    TSGoogleAuthenticationViewController *authController;
    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeCalendarReadonly, nil];
    authController = [[TSGoogleAuthenticationViewController alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kClientID
                      clientSecret:kClientSecret
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    authController.googleCalendarDelegate = delegate;
    return authController;
}

// Handle completion of the authorization process, and update the Google Calendar API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        [self fetchEvents];
        [self.googleCalendarDelegate heyMisterDelegatePleaseActivateGoogleCalendar];
        [self.delegate thanksDearOneLastThingWouldYouKindlyDismissThatSameViewControllerForMe];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

@end
