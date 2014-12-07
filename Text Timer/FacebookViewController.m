//
//  FacebookViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/2/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "FacebookViewController.h"
#define PLACEHOLDER @"Enter message"
@interface FacebookViewController ()

@end

@implementation FacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendDate.minimumDate =
    [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 300 ];
    if(self.date) {
        self.sendDate.date = self.date;
    } else {
        self.sendDate.date = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 300 ];
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


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelPressed:(id)sender {
    [self popToRoot];
}
- (IBAction)savePressed:(id)sender {
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
