//
//  TTFacebookAccountTableViewController.h
//  Text Timer
//
//  Created by Adam Rosenberg on 12/6/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "FacebookViewController.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
@interface TTFacebookAccountTableViewController : UITableViewController
@property NSString* acc;
@property NSString* mes;
@property NSDate* date;
@property int edited;
@property NSArray* accounts;
@end
