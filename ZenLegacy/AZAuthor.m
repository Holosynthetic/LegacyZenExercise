//
//  AZAuthor.m
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZAuthor.h"

@implementation AZAuthor

@synthesize authorID = _authorID;
@synthesize name = _name;
@synthesize userName = _userName;
@synthesize email = _email;

- (void)dealloc
{
    [_authorID release];
    [_name release];
    [_userName release];
    [_email release];
    [super dealloc];
}

- (id)initWithJSONObject:(NSDictionary *)object
{
    self = [super init];
    
    if (self)
    {
        _authorID = [[object objectForKey:@"id"] retain];
        
        _name = [[object objectForKey:@"name"] copy];
        
        _userName = [[object objectForKey:@"userName"] copy];
        
        _email = [[object objectForKey:@"email"] copy];
    }
    
    return self;
}

@end