//
//  TwitterViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/2/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "TwitterViewController.h"
#define PLACEHOLDER @"Enter message"
@interface TwitterViewController ()

@end

@implementation TwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageDate.minimumDate =
    [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 300 ];
    
    if(self.date) {
        self.messageDate.date = self.date;
    } else {
        self.messageDate.date = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 300 ];
    }
    
    if(self.mes) {
        self.messageText.text = self.mes;
    } else {
        self.messageText.text = PLACEHOLDER;
    }
    self.messageText.delegate = self;
    if(self.edited == 1) {
        self.messageText.textColor = [UIColor blackColor];
    } else {
        self.messageText.textColor = [UIColor lightGrayColor];
    }
    
    if(self.acc) {
        self.accountText.text = self.acc;
    }
    
    [self.accountText setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelPressed:(id)sender {
    [self popToRoot];
}
- (IBAction)savePressed:(id)sender {
    NSString* inputAcc = self.accountText.text;
    NSString* inputMes = self.messageText.text;
    NSDate* inputDate = self.messageDate.date;
    
    if([self isEmpty:inputAcc]) {
        [self showAlertWithTitle:@"Could not save Tweet" withMessage:@"Account is empty"];
    } else if([self isEmpty:inputMes]) {
        [self showAlertWithTitle:@"Could not save Tweet" withMessage:@"Message is empty"];
    } else if(!inputDate) {
        [self showAlertWithTitle:@"Could not save Tweet" withMessage:@"Date is null"];
    } else {
        PFObject* tweet = [PFObject objectWithClassName:@"Twitter"];
        tweet[@"message"] = inputMes;
        tweet[@"twitterName"] = inputAcc;
        tweet[@"sendDate"] = inputDate;
        tweet[@"email"] = [[PFUser currentUser] objectForKey:@"email"];
        tweet[@"user"] = [PFUser currentUser];
        [tweet saveInBackground];
        
        // pop view controller
        [self popToRoot];
    }
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

-(void) showAlertWithTitle:(NSString*)title withMessage:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([self.messageText.textColor isEqual:[UIColor lightGrayColor]]) {
        self.edited = 0;
    } else {
        self.edited = 1;
    }
    
    TTTwitterAccountTableViewController* view = [segue destinationViewController];
    view.acc = self.accountText.text;
    view.date = self.messageDate.date;
    view.mes = self.messageText.text;
    view.edited = self.edited;
    
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

#pragma mark - UITextViewDelegate
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
    } else if(self.messageText.text.length > 160) {
        // tweets can only be 160 characters
        return NO;
    } else if(self.messageText.text.length+text.length > 160) {
        return NO;
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
