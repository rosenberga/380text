//
//  TTMessageDetailsViewController.h
//  Text Timer
//
//  Created by Adam Rosenberg on 12/6/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMessageDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *messageType;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *recLabel;
@property NSString* cellMessageType;
@property NSString* cellSubject;
@property NSString* cellDate;
@property NSString* cellMessage;
@property NSString* cellRec;
@end
