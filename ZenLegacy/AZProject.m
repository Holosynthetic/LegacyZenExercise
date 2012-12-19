//
//  AZProject.m
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZProject.h"

#import "AZRequest.h"

@implementation AZProject

@synthesize projectID = _projectID;
@synthesize name = _name;
@synthesize createTime = _createTime;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [_projectID release];
    [_name release];
    [_createTime release];
    [super dealloc];
}

- (id)initWithJSONObject:(NSDictionary *)object
{
    self = [super init];
    
    if (self)
    {
        _projectID = [[object objectForKey:@"id"] retain];
        
        _name = [[object objectForKey:@"name"] copy];
        
        _createTime = [[AZRequest dateFromString:(NSString *)[object objectForKey:@"createTime"]] retain];
    }
    
    return self;
}

@end