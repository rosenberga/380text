//
//  MasterViewController.m
//  test
//
//  Created by Adam Rosenberg on 11/15/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) { // No user logged in
        [self loginAndSignUp];
    } else {
        NSString *email = [[PFUser currentUser] objectForKey:@"email"];
        if(!email) {
            [self loginAndSignUp];
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"email" equalTo:[[PFUser currentUser] objectForKey:@"email"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if((int)objects.count < 1) {
                        [PFUser logOut];
                        [self loginAndSignUp];
                    }
                } else {
                    [PFUser logOut];
                    [self loginAndSignUp];
                }
            }];
        }
    }
}

- (void) loginAndSignUp {
    // Create the log in view controller
    TTLogInViewController *logInViewController = [[TTLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    TTSignUpViewController *signUpViewController = [[TTSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.s
- (BOOL)logInViewController:(TTLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(TTLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(TTLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(TTLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(TTSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    BOOL phone = NO;
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        } else if ([key isEqualToString:@"additional"]){
            RMPhoneFormat *fmt = [[RMPhoneFormat alloc] init];
            NSString *numberString = field;// the phone number to validate
            if(![fmt isPhoneNumberValid:numberString]) {
                informationComplete = NO;
                phone = YES;
                break;
            } else {
                self.signUpNumber = numberString;
            }
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        if(phone) {
            [[[UIAlertView alloc] initWithTitle:@"Invalid phone number"
                                        message:@"The entered phone number is invalid!"
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                        message:@"Make sure you fill out all of the information!"
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
        }
    }
    
    return informationComplete;
}
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self verifyUser];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) verifyUser {
    [PFCloud callFunctionInBackground:@"sendVerificationCode"
                       withParameters:@{@"phoneNumber": self.signUpNumber}
                                block:^(NSNumber *ratings, NSError *error) {
                                    if (error) {
                                        [self unableToVerifyPhone];
                                    } else {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Verification Code" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
                                        alertView.tag = 2;
                                        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                                        [alertView show];
                                    }
                                }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(![alertView.title isEqualToString:@"Enter Verification Code"]) {
        return;
    }
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 1 && alertTextField.text.length > 0) {
        [PFCloud callFunctionInBackground:@"verifyPhoneNumber"
                           withParameters:@{@"phoneVerificationCode": alertTextField.text,
                                            @"phoneNumber" : self.signUpNumber}
                                    block:^(NSNumber *ratings, NSError *error) {
                                        if (error) {
                                            [self unableToVerifyPhone];
                                        } else {
                                            [self phoneVerified];
                                        }
                                    }];
    } else {
    }
}

-(void) unableToVerifyPhone {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to verify phone number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.tag = 1;
    [alertView show];
}

-(void) phoneVerified {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank You" message:@"Phone number verified" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.tag = 1;
    [alertView show];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}
@end
