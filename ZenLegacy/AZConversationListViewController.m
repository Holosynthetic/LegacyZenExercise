//
//  AZConversationListViewController.m
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZConversationListViewController.h"
#import "AZStoryCommentsViewController.h"

#import "AZRequest.h"
#import "AZProject.h"
#import "AZStory.h"
#import "AZComment.h"
#import "AZAuthor.h"
#import "AZConversation.h"

@implementation AZConversationListViewController

@synthesize tableView = _tableView;
@synthesize conversations = _conversations;
@synthesize project = _project;

#pragma mark - Data

- (void)fetchConversations
{
    self.title = @"Loading";
    
    [_conversations removeAllObjects];
    
    NSString *urlPath = [NSString stringWithFormat:@"https://agilezen.com/api/v1/projects/%i/stories", [[_project projectID] integerValue]];
    
    AZRequest *request = [[AZRequest alloc] initWithURL:[NSURL URLWithString:urlPath] enrichments:[NSArray arrayWithObject:@"comments"]];
    
    [request setPageSize:500];
    
    [request performRequestWithHandler:^(AZRequest *request, NSData *responseData, NSError *error){
        
        if (responseData)
        {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            
            if (responseObject)
            {
                NSMutableArray *storyArray = [[NSMutableArray alloc] init];
                
                NSMutableArray *commentArray = [[NSMutableArray alloc] init];
                
                // Format Story and Comment objects
                
                NSArray *projectStories = (NSArray *)[responseObject objectForKey:@"items"];
                
                for (NSDictionary *storyObject in projectStories)
                {
                    AZStory *story = [[AZStory alloc] initWithJSONObject:storyObject];
                    
                    NSArray *storyComments = (NSArray *)[storyObject objectForKey:@"comments"];
                    
                    for (NSDictionary *commentObject in storyComments)
                    {
                        AZComment *comment = [[AZComment alloc] initWithJSONObject:commentObject];
                        
                        [comment setStoryID:[story storyID]];
                        
                        [commentArray addObject:comment];
                        
                        [comment release];
                    }
                    
                    [storyArray addObject:story];
                    
                    [story release];
                }
                
                // Sort Comments from most recent to oldest
                
                NSSortDescriptor *sortByDate01 = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
                
                [commentArray sortUsingDescriptors:[NSArray arrayWithObject:sortByDate01]];
                
                [sortByDate01 release];
                
                // Create Conversation objects
                
                AZConversation *currentConversation = [[AZConversation alloc] initWithIndex:0];
                
                for (int i = 0; i < [commentArray count]; ++i)
                {
                    AZComment *comment = (AZComment *)[commentArray objectAtIndex:i];
                    
                    if ([currentConversation story] && [[[currentConversation story] storyID] integerValue] != [[comment storyID] integerValue])
                    {
                        [_conversations addObject:currentConversation];
                        
                        [currentConversation release];
                        
                        currentConversation = [[AZConversation alloc] initWithIndex:[_conversations count]];
                    }
                    
                    if (![currentConversation story])
                    {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storyID == %i", [[comment storyID] integerValue]];
                        
                        NSArray *filteredStories = [storyArray filteredArrayUsingPredicate:predicate];
                        
                        if ([filteredStories count])
                        {
                            [currentConversation setStory:(AZStory *)[filteredStories objectAtIndex:0]];
                        }
                    }
                    
                    [[currentConversation comments] addObject:comment];
                }
                
                if (currentConversation)
                {
                    [_conversations addObject:currentConversation];
                    
                    [currentConversation release];
                }
                
                [commentArray release];
                
                [storyArray release];
                
                // Sort the comments within a conversation from oldest to most recent
                
                for (AZConversation *conversation in _conversations)
                {
                    if ([[conversation comments] count] > 1)
                    {
                        NSSortDescriptor *sortByDate02 = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
                        
                        [[conversation comments] sortUsingDescriptors:[NSArray arrayWithObject:sortByDate02]];
                        
                        [sortByDate02 release];
                    }
                }
                
                // Update the table view
                
                self.title = [_project name];
                
                [_tableView reloadData];
            }
        }
        
        [request release];
    }];
}

#pragma mark - Controller Lifecycle

- (void)dealloc
{
    [_conversations release];
    [_project release];
    [super dealloc];
}

- (id)initWithProject:(AZProject *)project
{
    self = [super init];
    
    if (self)
    {
        _conversations = [[NSMutableArray alloc] init];
        
        _project = [project retain];
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
    
    CGRect currentBounds = [[UIScreen mainScreen] applicationFrame];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(currentBounds), CGRectGetHeight(currentBounds) - 44.0) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    self.tableView = tableView;
    
    [self fetchConversations];
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:@"kConversationsUpdated"] == YES)
    {
        [self fetchConversations];
        
        [userDefaults setBool:NO forKey:@"kConversationsUpdated"];
        
        [userDefaults synchronize];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [_conversations removeAllObjects];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_conversations count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AZConversation *conversation = (AZConversation *)[_conversations objectAtIndex:section];
    
    return [[conversation comments] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    AZStory *story = [(AZConversation *)[_conversations objectAtIndex:section] story];
    
    return [NSString stringWithFormat:@"[%@] -%@", [story phaseName], [story text]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AZConversation *conversation = (AZConversation *)[_conversations objectAtIndex:[indexPath section]];
    
    AZComment *comment = (AZComment *)[[conversation comments] objectAtIndex:[indexPath row]];
    
    cell.textLabel.textColor = [comment hasBeenViewed] ? [UIColor blackColor] : [UIColor blueColor];
    
    cell.textLabel.text = [comment text];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [comment formattedDate], [[comment author] name]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AZConversation *selectedConversation = (AZConversation *)[_conversations objectAtIndex:[indexPath section]];
    
    AZStoryCommentsViewController *commentViewController = [[AZStoryCommentsViewController alloc] initWithStory:[selectedConversation story]];
    
    [[self navigationController] pushViewController:commentViewController animated:YES];
    
    [commentViewController release];
}

@end