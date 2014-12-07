//
//  MasterViewController.h
//  test
//
//  Created by Adam Rosenberg on 11/15/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TTLogInViewController.h"
#import "TTSignUpViewController.h"
#import "RMPhoneFormat.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
@interface MasterViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate>
@property NSString* signUpNumber;
@end

