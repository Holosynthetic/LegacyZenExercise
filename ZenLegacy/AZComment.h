//
//  AZComment.h
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZAuthor;

@interface AZComment : NSObject
{
    NSNumber *_commentID;
    NSString *_text;
    NSDate *_createTime;
    
    NSNumber *_storyID;
    AZAuthor *_author;
    
    NSString *_formattedDate;
}
@property (nonatomic, retain, readonly) NSNumber *commentID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain, readonly) NSDate *createTime;

@property (nonatomic, retain) NSNumber *storyID;
@property (nonatomic, retain) AZAuthor *author;

@property (nonatomic, copy, readonly) NSString *formattedDate;
@property (nonatomic, readonly) BOOL hasBeenViewed;

- (id)initWithJSONObject:(NSDictionary *)object;

@end