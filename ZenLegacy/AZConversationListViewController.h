//
//  AZConversationListViewController.h
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZProject;

@interface AZConversationListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_conversations;
    AZProject *_project;
}
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *conversations;
@property (nonatomic, retain) AZProject *project;

- (id)initWithProject:(AZProject *)project;

@end