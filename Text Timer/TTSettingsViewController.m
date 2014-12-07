//
//  TTSettingsViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/5/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "TTSettingsViewController.h"

@interface TTSettingsViewController ()

@end

@implementation TTSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)emailClicked:(id)sender {
    NSString* cEmail = [[PFUser currentUser] objectForKey:@"email"];
    NSString* sMessage = [NSString stringWithFormat:@"New verification email sent to %@", cEmail];
    [[PFUser currentUser] setObject:@"pretzelsandpi@gmail.com" forKey:@"email"];
    // this is my old email address
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [[PFUser currentUser] setObject:cEmail forKey:@"email"];
            [[PFUser currentUser] saveInBackground];
            [self showAlertWithTitle:@"Success" withMessage:sMessage];
        }
        if(error) {
            [self showAlertWithTitle:@"Error" withMessage:@"Email failed to send"];
        }
    }];
}
- (IBAction)textClicked:(id)sender {
    [PFCloud callFunctionInBackground:@"sendVerificationCode"
                       withParameters:@{@"phoneNumber": [[PFUser currentUser] objectForKey:@"additional"]}
                                block:^(NSNumber *ratings, NSError *error) {
                                    if (error) {
                                        [self showAlertWithTitle:@"Error" withMessage:@"Code failed to send"];
                                    } else {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Verification Code" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
                                        alertView.tag = 2;
                                        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                                        [alertView show];
                                    }
                                }];
}
- (IBAction)codeClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Verification Code" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}
- (IBAction)passwordClicked:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:[[PFUser currentUser] objectForKey:@"email"] block:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [self showAlertWithTitle:@"Success" withMessage:@"An email has been sent to your account with instructions on how to change your password"];
        } else {
            [self showAlertWithTitle:@"Error" withMessage:@"We were not able to send you a password reset email"];
        }
    }];
}
- (IBAction)deleteClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm account deletion" message:@"This will also delete all scheduled message" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] ;
    alertView.tag = 2;
    [alertView show];
}

-(void) showAlertWithTitle:(NSString*) title withMessage:(NSString*)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.tag = 1;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if([alertView.title isEqualToString:@"Enter Verification Code"] ) {
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            if (buttonIndex == 1 && alertTextField.text.length > 0) {
                [PFCloud callFunctionInBackground:@"verifyPhoneNumber"
                                   withParameters:@{@"phoneVerificationCode": alertTextField.text,
                                                    @"phoneNumber" : [[PFUser currentUser] objectForKey:@"additional"]}
                                            block:^(NSNumber *ratings, NSError *error) {
                                                if (error) {
                                                    [self showAlertWithTitle:@"Error" withMessage:@"Unable to verify phone number"];
                                                } else {
                                                    [self showAlertWithTitle:@"Success" withMessage:@"Phone number verified"];
                                                }
                                            }];
            }
        } else if([alertView.title isEqualToString:@"Confirm account deletion"]) {
            if (buttonIndex == 1) {
                [self deleteSms];
                [self deleteEmail];
                [self deleteFacebook];
                [self deleteTwitter];
                [self deleteUserAndLogOut];
            }
        } else {
            return;
        }
}
- (void)popToRoot{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MasterViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
    
}
- (void) deleteUserAndLogOut {
    PFUser* user = [PFUser currentUser];
    [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [self popToRoot];
        }
        if (error) {
            if(error) {
                [self showAlertWithTitle:@"Error" withMessage:@"Account failed to delete"];
            }
            [self popToRoot];
        }
    }];
}
- (void) deleteSms {
    [self deleteColumnWithClass:@"Sms" keyInTable:@"sendFrom" keyInUser:@"additional"];
}
- (void) deleteEmail {
    [self deleteColumnWithClass:@"email" keyInTable:@"sendFrom" keyInUser:@"email"];
}
- (void) deleteFacebook {
    [self deleteColumnWithClass:@"Facebook" keyInTable:@"email" keyInUser:@"email"];
}
- (void) deleteTwitter {
    [self deleteColumnWithClass:@"Twitter" keyInTable:@"email" keyInUser:@"email"];
}

- (void) deleteColumnWithClass:(NSString*)class keyInTable:(NSString*)tableKey keyInUser:(NSString*) userKey {
    PFQuery *query = [PFQuery queryWithClassName:class];
    [query whereKey:tableKey equalTo:[[PFUser currentUser] objectForKey:userKey]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject* obj in objects) {
                [obj deleteInBackground];
            }
        }
    }];
}
- (IBAction)userLogoff:(id)sender {
    [PFUser logOut];
    [self popToRoot];
}
@end
