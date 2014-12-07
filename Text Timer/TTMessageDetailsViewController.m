//
//  TTMessageDetailsViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/6/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "TTMessageDetailsViewController.h"

@interface TTMessageDetailsViewController ()

@end

@implementation TTMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.cellMessageType) {
        self.messageType.text = self.cellMessageType;
    } else {
        self.messageType.text = @"";
    }
    
    if(self.cellSubject) {
        self.subjectLabel.text = self.cellSubject;
    } else {
        self.subjectLabel.text = @"";
    }
    
    if(self.cellDate) {
        self.dateLabel.text = self.cellDate;
    } else {
        self.dateLabel.text = @"";
    }
    
    if(self.cellMessage) {
        self.messageLabel.text = self.cellMessage;
        
        [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.messageLabel.numberOfLines = 0;
        [self.messageLabel sizeToFit];
    } else {
        self.messageLabel.text = @"";
    }
    
    if(self.cellRec) {
        self.recLabel.text = self.cellRec;
    } else {
        self.recLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
