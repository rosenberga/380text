//
//  TTTwitterAccountTableViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/6/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "TTTwitterAccountTableViewController.h"

@interface TTTwitterAccountTableViewController ()

@end

@implementation TTTwitterAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAccounts];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) loadAccounts {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            self.accounts = [accountStore accountsWithAccountType:accountType];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twitterCell" forIndexPath:indexPath];
    ACAccount *twitterAccount = [self.accounts objectAtIndex:indexPath.row];
    cell.textLabel.text = twitterAccount.username;
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
    ACAccount *twitterAccount = [self.accounts objectAtIndex:path.row];
    self.acc = twitterAccount.username;
    TwitterViewController* view = [segue destinationViewController];
    view.edited = self.edited;
    view.date = self.date;
    view.mes = self.mes;
    view.acc = self.acc;
}

@end
