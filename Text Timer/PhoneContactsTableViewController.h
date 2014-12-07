//
//  PhoneContactsTableViewController.h
//  Text Timer
//
//  Created by Adam Rosenberg on 11/23/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SmsViewController.h"

@interface PhoneContactsTableViewController : UITableViewController
@property NSMutableArray* contactList;
@property NSString* number;
@property NSString* text;
@property NSDate* date;
@property int edited;
@end
