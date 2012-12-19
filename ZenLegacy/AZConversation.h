//
//  AZConversation.h
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZStory;

@interface AZConversation : NSObject
{
    NSNumber *_index;
    AZStory *_story;
    NSMutableArray *_comments;
}
@property (nonatomic, retain) NSNumber *index;
@property (nonatomic, retain) AZStory *story;
@property (nonatomic, retain) NSMutableArray *comments;

- (id)initWithIndex:(int)index;

@end