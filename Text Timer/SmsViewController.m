//
//  SmsViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 11/18/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "SmsViewController.h"
#define PLACEHOLDER @"Enter message"

@interface SmsViewController ()

@end

@implementation SmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PFUser currentUser] fetchInBackground];
    self.datePicker.minimumDate =
    [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 300 ];
    self.recNumber.text = self.number;
    self.messageText.delegate = self;
    if (self.date) {
        self.datePicker.date = self.date;
    } else {
        self.edited = 0;
    }
    
    if (self.text) {
        self.messageText.text = self.text;
    } else {
        self.messageText.text = PLACEHOLDER;
    }
    
    if(self.edited == 1) {
        self.messageText.textColor = [UIColor blackColor];
    } else {
        self.messageText.textColor = [UIColor lightGrayColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)cancelPressed:(id)sender {
    // pop view controller
    [self popToRoot];
}
- (IBAction)savePressed:(id)sender {
    
    PFUser* user = [PFUser currentUser];
    if([self notValidPhoneWithUser:user]) {
        [self showAlertWithTitle:@"Unable to Send SMS" withMessage:@"Phone number is not verified"];
        return;
    }
    
    // get info
    NSString* message = self.messageText.text;
    NSString* number = self.recNumber.text;
    NSDate* dateToSend = self.datePicker.date;
    
    if([self isEmpty:message]) {
        [self showAlertWithTitle:@"Unable To Send SMS" withMessage:@"Message was empty"];
    } else if([self isEmpty:number]) {
        [self showAlertWithTitle:@"Unable To Send SMS" withMessage:@"Receiver was empty"];
    } else if(!dateToSend) {
        [self showAlertWithTitle:@"Unable To Send SMS" withMessage:@"Date was null"];
    } else if (![self isPhone:number]) {
        [self showAlertWithTitle:@"Unable To Send SMS" withMessage:@"Receiver was invalid"];
    }else {
    
    // save on parse
    PFObject* sms = [PFObject objectWithClassName:@"Sms"];
    sms[@"sendingTo"] = number;
    sms[@"message"] = message;
    sms[@"timeToSend"] = dateToSend;
    sms[@"sender"] = [PFUser currentUser];
    sms[@"sendFrom"] = [[PFUser currentUser] objectForKey:@"additional"];
    [sms saveInBackground];
    
    // pop view controller
    [self popToRoot];
    }
}
-(bool) notValidPhoneWithUser:(PFUser*) user {
    NSString* addition = [user objectForKey:@"additional"];
    NSString* number = [user objectForKey:@"phoneNumber"];
    if(number) {
        if([number isEqualToString:addition]) {
            return NO;
        }
    }
    return YES;
}
-(bool) isPhone:(NSString*) field{
    bool phone = NO;
    RMPhoneFormat *fmt = [[RMPhoneFormat alloc] init];
    NSString *numberString = field;// the phone number to validate
    if([fmt isPhoneNumberValid:numberString]) {
        phone = YES;
    }
    return phone;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PhoneContactsTableViewController* view = [segue destinationViewController];
    view.date = self.datePicker.date;
    view.text = self.messageText.text;
    if([self.messageText.textColor isEqual:[UIColor lightGrayColor]]) {
        self.edited = 0;
    } else {
        self.edited = 1;
    }
    view.edited = self.edited;
}

@end
