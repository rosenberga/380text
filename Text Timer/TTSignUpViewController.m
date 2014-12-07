//
//  TTSignUpViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/2/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "TTSignUpViewController.h"

@interface TTSignUpViewController ()

@end

@implementation TTSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signUpView.logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
