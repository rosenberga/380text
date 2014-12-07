//
//  TTEmailHistoryQueryTableViewController.m
//  Text Timer
//
//  Created by Adam Rosenberg on 12/6/14.
//  Copyright (c) 2014 Transient Turtle. All rights reserved.
//

#import "TTEmailHistoryQueryTableViewController.h"
#define CLASS @"email"
#define CELL @"emailHistoryCell"
#define DATEKEY @"timeToSend"
#define USERKEY1 @"sendFrom"
#define USERKEY2 @"email"
#define SEND @"sendTo"
#define SUBJECT @"subject"
@interface TTEmailHistoryQueryTableViewController ()

@end

@implementation TTEmailHistoryQueryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TTMessageDetailsViewController* view = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    PFObject* o = [self objectAtIndexPath:indexPath];
    view.cellMessage = [o objectForKey:@"message"];
    view.cellSubject = [o objectForKey:SUBJECT];
    view.cellMessageType = CLASS;
    view.cellRec = [o objectForKey:SEND];
    NSDate* d = [o objectForKey:DATEKEY];
    view.cellDate = [NSDateFormatter localizedStringFromDate:d dateStyle:NSDateFormatterShortStyle
                                                   timeStyle:NSDateFormatterShortStyle];
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = CLASS;
        self.textKey = @"objectId";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
    }
    return self;
}

#pragma mark - Table View

-(PFQuery *) queryForTable
{
    PFQuery *query  = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:USERKEY1 equalTo:[[PFUser currentUser] objectForKey:USERKEY2]];
    [query whereKey:DATEKEY lessThan:[NSDate date]];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"createdAt"];
    return query;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    UITableViewCell* cel = [tableView dequeueReusableCellWithIdentifier:CELL];
    if(cel == nil) {
        cel = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
    }
    cel.textLabel.text = [object objectForKey:@"message"];
    return cel;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *o = [self objectAtIndexPath:indexPath];
        [o deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                [self loadObjects];
            }
        }];
    }
}


@end
