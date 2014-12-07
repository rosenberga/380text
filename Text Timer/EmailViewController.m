//
//  EmailViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 11/18/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "EmailViewController.h"
#define PLACEHOLDER @"Enter message"

@interface EmailViewController ()

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PFUser currentUser] fetchInBackground];
    self.datePicker.minimumDate =
    [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 300 ];
    self.messageText.delegate = self;
    self.messageText.text = PLACEHOLDER;
    self.messageText.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)cancelPressed:(id)sender {
    // pop view controller
    [self popToRoot];
}
- (IBAction)savePressed:(id)sender {
    PFUser* user = [PFUser currentUser];
    bool valid = YES;
    if (![[user objectForKey:@"emailVerified"] boolValue]) {
        // Refresh to make sure the user did not recently verify
        [user fetch];
        if (![[user objectForKey:@"emailVerified"] boolValue]) {
            valid = NO;
        }
    }
    if(!valid) {
        [self showAlertWithTitle:@"Unable To Send Email" withMessage:@"Your email address is not verified"];
    } else {
        
        // get info
        NSString* message = self.messageText.text;
        NSString* number = self.recipient.text;
        NSDate* dateToSend = self.datePicker.date;
        NSString* sub = self.subject.text;
        
        if([self isEmpty:message]) {
            [self showAlertWithTitle:@"Unable To Send Email" withMessage:@"Message was empty"];
        } else if([self isEmpty:number]) {
            [self showAlertWithTitle:@"Unable To Send Email" withMessage:@"Receiver was empty"];
        } else if([self isEmpty:sub]) {
            [self showAlertWithTitle:@"Unable To Send Email" withMessage:@"Subject was empty"];
        } else if(!dateToSend) {
            [self showAlertWithTitle:@"Unable To Send Email" withMessage:@"Date was nil"];
        } else if(![self isValidEmail:number]) {
            [self showAlertWithTitle:@"Unable To Send Email" withMessage:@"Receiver had an invalid email"];
        } else {
            
            // save on parse
            PFObject* email = [PFObject objectWithClassName:@"email"];
            email[@"sendTo"] = number;
            email[@"message"] = message;
            email[@"timeToSend"] = dateToSend;
            email[@"sender"] = [PFUser currentUser];
            email[@"subject"] = sub;
            email[@"sendFrom"] = [[PFUser currentUser] objectForKey:@"email"];
            [email saveInBackground];
            
            // pop view controller
            [self popToRoot];
        }
    }
}
-(bool) isValidEmail:(NSString*)rec {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:rec];
}

-(void) showAlertWithTitle:(NSString*)title withMessage:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}
-(bool) isEmpty:(NSString*)str {
    if(str) {
        if(str.length > 0) {
            if([str isEqualToString:PLACEHOLDER]) {
                if([self.messageText.textColor isEqual:[UIColor lightGrayColor]]) {
                    return YES;
                } else {
                    NSLog(@"%@", str);
                }
            }
            return NO;
        }
    }
    return YES;
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
-(void) textViewDidBeginEditing:(UITextView *)textView {
    [self.messageText setSelectedRange:NSMakeRange(0,0)];
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    if ([self.messageText.text isEqualToString:@""]) {
        self.messageText.text = PLACEHOLDER;
        self.messageText.textColor = [UIColor lightGrayColor];
    }
    [self.messageText resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if(self.messageText.text.length > 1 &&
       [self.messageText.text isEqualToString:PLACEHOLDER]) {
        self.messageText.text = @"";
        self.messageText.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.messageText.text.length != 0
       && [[self.messageText.text substringFromIndex:1] isEqualToString:PLACEHOLDER]
       && [self.messageText.text isEqual:[UIColor lightGrayColor]]) {
        self.messageText.textColor = [UIColor blackColor];
        self.messageText.text = [self.messageText.text substringToIndex:1];
    } else if(self.messageText.text.length == 0) {
        self.messageText.textColor = [UIColor lightGrayColor];
        self.messageText.text = PLACEHOLDER;
        [self.messageText setSelectedRange:NSMakeRange(0, 0)];
    }
}

-(void) textViewDidChangeSelection:(UITextView *)textView {
    if([self.messageText.text isEqualToString:PLACEHOLDER] && [self.messageText.textColor isEqual:[UIColor lightGrayColor]]) {
        [self.messageText setSelectedRange:NSMakeRange(0,0)];
    }
}

@end
