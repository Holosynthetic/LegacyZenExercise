//
//  AZProject.h
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZProject : NSObject
{
    NSNumber *_projectID;
    NSString *_name;
    NSDate *_createTime;
}
@property (nonatomic, retain, readonly) NSNumber *projectID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain, readonly) NSDate *createTime;

- (id)initWithJSONObject:(NSDictionary *)object;

@end