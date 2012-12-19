//
//  AZProjectListViewController.m
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZProjectListViewController.h"

#import "AppDelegate.h"
#import "AZConversationListViewController.h"

#import "AZRequest.h"
#import "AZProject.h"
#import "AZAuthor.h"

@implementation AZProjectListViewController

@synthesize tableView = _tableView;
@synthesize projects = _projects;

#pragma mark - Data

- (void)fetchProjects
{
    [_projects removeAllObjects];
    
    AZRequest *request = [[AZRequest alloc] initWithURL:[NSURL URLWithString:@"https://agilezen.com/api/v1/projects"]];
    
    [request setPage:nextPage];
    
    [request performRequestWithHandler:^(AZRequest *request, NSData *responseData, NSError *error){
        
        if (responseData)
        {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            
            if (responseObject)
            {
                currentPage = [(NSNumber *)[responseObject objectForKey:@"page"] integerValue];
                
                if ([(NSNumber *)[responseObject objectForKey:@"totalPages"] integerValue] > currentPage)
                {
                    ++nextPage;
                }
                
                NSArray *userProjects = (NSArray *)[responseObject objectForKey:@"items"];
                
                for (id projectObject in userProjects)
                {
                    AZProject *project = [[AZProject alloc] initWithJSONObject:projectObject];
                    
                    [_projects addObject:project];
                    
                    [project release];
                }
                
                [_tableView reloadData];
            }
        }
        
        [request release];
    }];
}

#pragma mark - Actions

- (void)updateTitle
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = [NSString stringWithFormat:@"Welcome, %@", [[delegate currentUser] userName]];
}

#pragma mark - Controller Lifecycle

- (void)dealloc
{
    [_projects release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _projects = [[NSMutableArray alloc] init];
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
    
    self.title = @"Welcome";
    
    // Setup UI
    
    CGRect currentBounds = [[UIScreen mainScreen] applicationFrame];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(currentBounds), CGRectGetHeight(currentBounds) - 44.0) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    self.tableView = tableView;
    
    // Fetch data
    
    currentPage = 0;
    nextPage = 1;
    
    [self fetchProjects];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [_projects removeAllObjects];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_projects count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Projects";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AZProject *project = (AZProject *)[_projects objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [project name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AZProject *selectedProject = (AZProject *)[_projects objectAtIndex:[indexPath row]];
    
    AZConversationListViewController *conversationList = [[AZConversationListViewController alloc] initWithProject:selectedProject];
    
    [[self navigationController] pushViewController:conversationList animated:YES];
    
    [conversationList release];
}

@end