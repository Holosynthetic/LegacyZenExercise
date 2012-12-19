//
//  AZProjectListViewController.h
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZProjectListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_projects;
    
    NSInteger currentPage;
    NSInteger nextPage;
}
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *projects;

- (void)updateTitle;

@end