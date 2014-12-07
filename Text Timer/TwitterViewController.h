//
//  TwitterViewController.h
//  Text Timer
//
//  Created by Adam Rosenberg on 12/2/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import <Accounts/Accounts.h>
#import <Parse/Parse.h>
#import "TTTwitterAccountTableViewController.h"
@interface TwitterViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UIDatePicker *messageDate;
@property NSString* mes;
@property NSDate* date;
@property NSString* acc;
@property int edited;
@end
