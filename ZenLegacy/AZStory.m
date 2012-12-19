//
//  AZStory.m
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZStory.h"

@implementation AZStory

@synthesize storyID = _storyID;
@synthesize text = _text;
@synthesize color = _color;

@synthesize phaseID = _phaseID;
@synthesize phaseName = _phaseName;

@synthesize projectID = _projectID;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [_storyID release];
    [_text release];
    [_phaseID release];
    [_phaseName release];
    [_projectID release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _color = AZStoryColorGrey;
    }
    
    return self;
}

- (id)initWithJSONObject:(NSDictionary *)object
{
    self = [super init];
    
    if (self)
    {
        _storyID = [[object objectForKey:@"id"] retain];
        
        _text = [[object objectForKey:@"text"] copy];
        
        _color = [self storyColorFromString:[object objectForKey:@"color"]];
        
        NSDictionary *phase = (NSDictionary *)[object objectForKey:@"phase"];
        
        _phaseID = [[phase objectForKey:@"id"] retain];
        
        _phaseName = [[phase objectForKey:@"name"] copy];
        
        NSDictionary *project = (NSDictionary *)[object objectForKey:@"project"];
        
        _projectID = [[project objectForKey:@"id"] retain];
    }
    
    return self;
}

#pragma mark - Private Methods

- (AZStoryColor)storyColorFromString:(NSString *)string
{
    if ([string compare:@"blue" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return AZStoryColorBlue;
    }
    else if ([string compare:@"red" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return AZStoryColorRed;
    }
    else if ([string compare:@"green" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return AZStoryColorGreen;
    }
    else if ([string compare:@"orange" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return AZStoryColorOrange;
    }
    else if ([string compare:@"yellow" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return AZStoryColorYellow;
    }
    else if ([string compare:@"purple" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return AZStoryColorPurple;
    }
    else if ([string compare:@"teal" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return AZStoryColorTeal;
    }
    
    return AZStoryColorGrey;
}

@end