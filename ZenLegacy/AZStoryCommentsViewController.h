//
//  AZStoryCommentsViewController.h
//  ZenLegacy
//
//  Created by John Parron on 12/17/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZStory;

@interface AZStoryCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_comments;
    AZStory *_story;
}
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *comments;
@property (nonatomic, retain) AZStory *story;

- (id)initWithStory:(AZStory *)story;

@end