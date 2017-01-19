/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAParentalGate.h"
#import "SABannerAd.h"
#import "SAVideoAd.h"
#import "SAAppWall.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAExtensions.h>)
#import <SAUtils/SAExtensions.h>
#else
#import "SAExtensions.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAEvents/SAEvents.h>)
#import <SAEvents/SAEvents.h>
#else
#import "SAEvents.h"
#endif
#endif

// define a block used by UIAlertActions
typedef void(^actionBlock) (UIAlertAction *action);

// parental gate defines
#define SA_CHALLANGE_ALERTVIEW                      0
#define SA_ERROR_ALLERTVIEW                         1

#define SA_RAND_MIN                                 50
#define SA_RAND_MAX                                 99

#define SA_CHALLANGE_ALERTVIEW_TITLE                @"Parental Gate"
#define SA_CHALLANGE_ALERTVIEW_MESSAGE              @"Please solve the following problem to continue:\n%@ + %@ = ?"
#define SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE    [NSString stringWithFormat:SA_CHALLANGE_ALERTVIEW_MESSAGE, @(_number1), @(_number2)]
#define SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE   @"Cancel"
#define SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE @"Continue"

#define SA_ERROR_ALERTVIEW_TITLE                    @"Oops! That was the wrong answer."
#define SA_ERROR_ALERTVIEW_MESSAGE                  @"Please seek guidance from a responsible adult to help you continue."
#define SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE       @"Ok"

// anonymous extension of SAParentalGate
@interface SAParentalGate ()

@property (nonatomic, strong) SAEvents              *events;

@property (nonatomic,assign) NSInteger              number1;
@property (nonatomic,assign) NSInteger              number2;
@property (nonatomic,assign) NSInteger              solution;

@property (nonatomic, retain) UIAlertView           *challengeAlertView;
@property (nonatomic, retain) UIAlertController     *challangeAlertController;
@property (nonatomic, retain) UIAlertView           *wrongAnswerAlertView;

// weak ref to view
@property (nonatomic, weak) id                      weakAdView;
@property (nonatomic, assign) NSInteger             gameWallPosition;

@end

@implementation SAParentalGate

- (id) initWithWeakRefToView:(id)weakRef
                       andAd:(SAAd *)ad {
    
    if (self = [super init]) {
        _weakAdView = weakRef;
        _events = [[SAEvents alloc] init];
        [_events setAd:ad];
    }
    
    return self;
}


- (id) initWithWeakRefToView:(id)weakRef
                       andAd:(SAAd *)ad
                 andPosition:(NSInteger)position {
    
    if (self = [self initWithWeakRefToView:weakRef andAd:ad]) {
        _gameWallPosition = position;
    }
    
    return self;
}

/**
 * Method that inits the numbers and solution for a new parental gate question
 */
- (void) newQuestion {
    _number1 = [SAUtils randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _number2 = [SAUtils randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _solution = _number1 + _number2;
}

- (void) show {
    [self newQuestion];
    
    // send event
    [_events sendAllEventsForKey:@"pg_open"];
    
    // pause video
    [SAUtils invoke:@"pause" onTarget:_weakAdView];
    
    if (NSClassFromString(@"UIAlertController")) {
        [self showWithAlertController];
    } else {
        [self showWithUIAlertView];
    }
}

- (void) close {
    
    if (NSClassFromString(@"UIAlertController")) {
        [_challangeAlertController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [_challengeAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}
/**
 * MARK: iOS8.0+
 * Method that shows an alert controller
 */
- (void) showWithAlertController {
    // action block #1
    actionBlock cancelBlock = ^(UIAlertAction *action) {
        
        // send event
        [_events sendAllEventsForKey:@"pg_close"];
        
        // resume video
        [SAUtils invoke:@"resume" onTarget:_weakAdView];
    };
    
    // action block #2
    actionBlock continueBlock = ^(UIAlertAction *action) {
        
        // get number from text field
        UITextField *textField = [[_challangeAlertController textFields] firstObject];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *input = [f numberFromString:textField.text];
        [textField resignFirstResponder];
        
        // what happens when you get a right solution
        if([input integerValue] == self.solution){
            [self handlePGSuccess];
        }
        // or a bad solution
        else{
            
            // resume video
            [SAUtils invoke:@"resume" onTarget:_weakAdView];
            
            [self handlePGError];
        }
    };
    
    
    // alert view (controller)
    _challangeAlertController = [UIAlertController alertControllerWithTitle:SA_CHALLANGE_ALERTVIEW_TITLE
                                                                    message:SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    // actions
    UIAlertAction* continueBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE
                                                          style:UIAlertActionStyleDefault
                                                        handler:continueBlock];
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE
                                                        style:UIAlertActionStyleDefault
                                                      handler:cancelBlock];
    
    
    // add actions
    [_challangeAlertController addAction:cancelBtn];
    [_challangeAlertController addAction:continueBtn];
    __block UITextField *localTextField;
    
    [_challangeAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
        localTextField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [_challangeAlertController show];
}

/**
 * MARK: iOS8.0-
 * Method that shows an alert view
 */
- (void) showWithUIAlertView {
    _challengeAlertView = [[UIAlertView alloc] initWithTitle:SA_CHALLANGE_ALERTVIEW_TITLE
                                                     message:SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE
                                                    delegate:self
                                           cancelButtonTitle:SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE
                                           otherButtonTitles:SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE, nil];
    _challengeAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_challengeAlertView show];
}

/**
 * MARK: iOS8.0-
 * Method that is called when an alert view will be presented
 *
 * @param alertView the alert view to be shown
 */
- (void) willPresentAlertView:(UIAlertView*) alertView {
    UITextField *textField = [_challengeAlertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
}

/**
 * MARK: iOS8.0-
 * Method that is called when an alert view button has been clicked
 *
 * @param alertView     the alert view to be shown
 * @param buttonIndex   the button that's just been clicked
 */
- (void) alertView:(UIAlertView*) alertView
clickedButtonAtIndex:(NSInteger) buttonIndex {
    // continue
    if (buttonIndex == 1) {
        UITextField *textField = [_challengeAlertView textFieldAtIndex:0];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *input = [f numberFromString:textField.text];
        
        if ([input integerValue] == _solution) {
            [self handlePGSuccess];
        } else {
            
            // resume video
            [SAUtils invoke:@"resume" onTarget:_weakAdView];
            
            [self handlePGError];
        }
    }
    // cancel
    else if (buttonIndex == 0){
        // send event
        [_events sendAllEventsForKey:@"pg_close"];
        
        // resume video
        [SAUtils invoke:@"resume" onTarget:_weakAdView];
    }
}

/**
 * Internal method that describes what happens in case the parental gate is a
 * success. Mainly "close the alert view" and "goto click url"
 */
- (void) handlePGSuccess {
    
    // send data
    [_events sendAllEventsForKey:@"pg_success"];
    
    // finally advance to URL
    if ([_weakAdView isKindOfClass:[SAAppWall class]]) {
        [SAUtils invoke:@"click:" onTarget:_weakAdView, @(_gameWallPosition)];
    } else {
        [SAUtils invoke:@"click" onTarget:_weakAdView];
    }
}

/**
 * Internal method that describes what happens in case the parental gate is a
 * error. Mainly "close the alert view" and "present error message"
 */
- (void) handlePGError {
    
    // send data
    [_events sendAllEventsForKey:@"pg_fail"];
    
    // ERROR
    _wrongAnswerAlertView = [[UIAlertView alloc] initWithTitle:SA_ERROR_ALERTVIEW_TITLE
                                                       message:SA_ERROR_ALERTVIEW_MESSAGE
                                                      delegate:nil
                                             cancelButtonTitle:SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE
                                             otherButtonTitles:nil];
    _wrongAnswerAlertView.alertViewStyle = UIAlertViewStyleDefault;
    [_wrongAnswerAlertView show];
}

@end
