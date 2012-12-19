//
//  AZStory.h
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AZStoryColorGrey,
    AZStoryColorBlue,
    AZStoryColorRed,
    AZStoryColorGreen,
    AZStoryColorOrange,
    AZStoryColorYellow,
    AZStoryColorPurple,
    AZStoryColorTeal,
} AZStoryColor;

@interface AZStory : NSObject
{
    NSNumber *_storyID;
    NSString *_text;
    AZStoryColor _color;
    
    NSNumber *_phaseID;
    NSString *_phaseName;
    
    NSNumber *_projectID;
}
@property (nonatomic, retain, readonly) NSNumber *storyID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) AZStoryColor color;

@property (nonatomic, retain, readonly) NSNumber *phaseID;
@property (nonatomic, copy) NSString *phaseName;

@property (nonatomic, retain, readonly) NSNumber *projectID;

- (id)initWithJSONObject:(NSDictionary *)object;

@end