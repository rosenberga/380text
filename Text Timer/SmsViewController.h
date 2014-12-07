//
//  SmsViewController.h
//  Text Timer
//
//  Created by Adam Rosenberg on 11/18/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PhoneContactsTableViewController.h"
#import "MasterViewController.h"
#import "RMPhoneFormat.h"
@interface SmsViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *recNumber;
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSString* number;
@property NSString* text;
@property NSDate* date;
@property int edited;
@end
