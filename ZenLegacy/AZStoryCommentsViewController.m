//
//  AZStoryCommentsViewController.m
//  ZenLegacy
//
//  Created by John Parron on 12/17/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZStoryCommentsViewController.h"

#import "AppDelegate.h"
#import "AZComposeViewController.h"

#import "AZRequest.h"
#import "AZStory.h"
#import "AZComment.h"
#import "AZAuthor.h"

@implementation AZStoryCommentsViewController

@synthesize tableView = _tableView;
@synthesize comments = _comments;
@synthesize story = _story;

#pragma mark - Data

- (void)fetchComments
{
    [_comments removeAllObjects];
    
    NSString *urlPath = [NSString stringWithFormat:@"https://agilezen.com/api/v1/projects/%i/stories/%i/comments", [[_story projectID] integerValue], [[_story storyID] integerValue]];
    
    AZRequest *request = [[AZRequest alloc] initWithURL:[NSURL URLWithString:urlPath]];
    
    [request setPageSize:500];
    
    [request performRequestWithHandler:^(AZRequest *request, NSData *responseData, NSError *error){
        
        if (responseData)
        {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            
            if (responseObject)
            {
                // Assign controller title
                
                NSInteger totalComments = [(NSNumber *)[responseObject objectForKey:@"totalItems"] integerValue];
                
                self.title = [NSString stringWithFormat:@"%i Comment%@", totalComments, totalComments == 1 ? @"" : @"s"];
                
                // Format Comment objects
                
                NSArray *storyComments = (NSArray *)[responseObject objectForKey:@"items"];
                
                for (NSDictionary *commentObject in storyComments)
                {
                    AZComment *comment = [[AZComment alloc] initWithJSONObject:commentObject];
                    
                    [comment setStoryID:[_story storyID]];
                    
                    [_comments addObject:comment];
                    
                    [comment release];
                }
                
                // Sort the comments from oldest to most recent
                
                NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
                
                [_comments sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
                
                [sortByDate release];
            
                // Update the table view
                
                [_tableView reloadData];
            }
        }
        
        [request release];
    }];
}

#pragma mark - Actions

- (void)compose:(UIBarButtonItem *)sender
{
    AZComposeViewController *composeViewController = [[AZComposeViewController alloc] initWithStory:_story];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    
    [composeViewController release];
    
    [self presentViewController:navController animated:YES completion:NULL];
    
    [navController release];
}

#pragma mark - Controller Lifecycle

- (void)dealloc
{
    [_comments release];
    [_story release];
    [super dealloc];
}

- (id)initWithStory:(AZStory *)story
{
    self = [super init];
    
    if (self)
    {
        _comments = [[NSMutableArray alloc] init];
        
        _story = [story retain];
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose:)];
    self.navigationItem.rightBarButtonItem = composeButton;
    [composeButton release];
    
    CGRect currentBounds = [[UIScreen mainScreen] applicationFrame];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(currentBounds), CGRectGetHeight(currentBounds) - 44.0) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    self.tableView = tableView;
    
    [self fetchComments];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:NO];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kConversationsUpdated"] == YES)
    {
        [self fetchComments];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [_comments removeAllObjects];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_comments count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"[%@] -%@", [_story phaseName], [_story text]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AZComment *comment = (AZComment *)[_comments objectAtIndex:[indexPath row]];
    
    cell.textLabel.textColor = [comment hasBeenViewed] ? [UIColor blackColor] : [UIColor blueColor];
    
    cell.textLabel.text = [comment text];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [comment formattedDate], [[comment author] name]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    AZAuthor *author = [(AZComment *)[_comments objectAtIndex:[indexPath row]] author];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [[author userName] compare:[[delegate currentUser] userName] options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the comment from the story
        
        AZComment *selectedComment = (AZComment *)[_comments objectAtIndex:[indexPath row]];
        
        NSString *urlPath = [NSString stringWithFormat:@"https://agilezen.com/api/v1/projects/%i/stories/%i/comments/%i", [[_story projectID] integerValue], [[_story storyID] integerValue], [[selectedComment commentID] integerValue]];
        
        AZRequest *request = [[AZRequest alloc] initWithURL:[NSURL URLWithString:urlPath] requestMethod:AZRequestMethodDELETE];
        
        [request performRequestWithHandler:^(AZRequest *request, NSData *responseData, NSError *error){
            
            if (responseData)
            {
                // Mark the conversations as updated
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setBool:YES forKey:@"kConversationsUpdated"];
                
                [userDefaults synchronize];
                
                // Update controller title
                
                [_comments removeObjectAtIndex:[indexPath row]];
                
                self.title = [NSString stringWithFormat:@"%i Comment%@", [_comments count], [_comments count] == 1 ? @"" : @"s"];
                
                // Remove the cell from the table view
                
                [tableView beginUpdates];
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [tableView endUpdates];
            }
            
            [request release];
        }];
    }
}

@end