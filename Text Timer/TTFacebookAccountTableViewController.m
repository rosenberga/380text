//
//  TTFacebookAccountTableViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/6/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "TTFacebookAccountTableViewController.h"

@interface TTFacebookAccountTableViewController ()

@end

@implementation TTFacebookAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAccounts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) loadAccounts {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options1 = @{ACFacebookAppIdKey : @"311105909096999",
                              ACFacebookPermissionsKey : @[@"email"],
                               ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    NSDictionary *options2 = @{ACFacebookAppIdKey : @"311105909096999",
                              ACFacebookPermissionsKey : @[@"publish_actions"],
                              ACFacebookAudienceKey:ACFacebookAudienceFriends};
    [accountStore requestAccessToAccountsWithType:accountType options:options1 completion:^(BOOL granted, NSError *error) {
        if(granted) {
            [accountStore requestAccessToAccountsWithType:accountType options:options2 completion:^(BOOL granted, NSError *error) {
                if(granted) {
                    self.accounts = [accountStore accountsWithAccountType:accountType];
                } else {
                    NSLog(@"%@",error);
                }
            }];
        }
        if(error) {
            NSLog(@"%@", error);
        }
    }];
    self.accounts = [accountStore accountsWithAccountType:accountType];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facebookCell" forIndexPath:indexPath];
    ACAccount *account = [self.accounts objectAtIndex:indexPath.row];
    cell.textLabel.text = account.username;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    ACAccount *account = [self.accounts objectAtIndex:path.row];
    self.acc = account.username;
    FacebookViewController* view = [segue destinationViewController];
    view.edited = self.edited;
    view.date = self.date;
    view.mes = self.mes;
    view.acc = self.acc;
}@end
