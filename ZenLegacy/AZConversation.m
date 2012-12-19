//
//  AZConversation.m
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZConversation.h"

#import "AZStory.h"
#import "AZComment.h"

@implementation AZConversation

@synthesize index = _index;
@synthesize story = _story;
@synthesize comments = _comments;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [_index release];
    [_story release];
    [_comments release];
    [super dealloc];
}

- (id)initWithIndex:(int)index
{
    self = [super init];
    
    if (self)
    {
        _index = [[NSNumber numberWithInt:index] retain];
        
        _comments = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end