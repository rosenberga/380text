//
//  EmailViewController.h
//  Text Timer
//
//  Created by Adam Rosenberg on 11/18/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MasterViewController.h"

@interface EmailViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *recipient;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextView *messageText;

@end
