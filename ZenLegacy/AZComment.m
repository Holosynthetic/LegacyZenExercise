//
//  AZComment.m
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZComment.h"

#import "AZRequest.h"

#import "AZAuthor.h"

@implementation AZComment

@synthesize commentID = _commentID;
@synthesize text = _text;
@synthesize createTime = _createTime;

@synthesize storyID = _storyID;
@synthesize author = _author;

@synthesize formattedDate = _formattedDate;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [_commentID release];
    [_text release];
    [_createTime release];
    [_storyID release];
    [_author release];
    [_formattedDate release];
    [super dealloc];
}

- (id)initWithJSONObject:(NSDictionary *)object
{
    self = [super init];
    
    if (self)
    {
        _commentID = [[object objectForKey:@"id"] retain];
        
        _text = [[object objectForKey:@"text"] copy];
        
        _createTime = [[AZRequest dateFromString:(NSString *)[object objectForKey:@"createTime"]] retain];
        
        _author = [[AZAuthor alloc] initWithJSONObject:(NSDictionary *)[object objectForKey:@"author"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        
        _formattedDate = [[formatter stringFromDate:_createTime] copy];
        
        [formatter release];
    }
    
    return self;
}

#pragma mark - Core Methods

- (BOOL)hasBeenViewed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *previousSessionDate = (NSDate *)[userDefaults objectForKey:@"previousSessionDate"];
    
    if (!previousSessionDate || (previousSessionDate && [[self createTime] timeIntervalSinceDate:previousSessionDate] > 0))
    {
        return NO;
    }
    
    return YES;
}

@end