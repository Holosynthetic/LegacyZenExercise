//
//  AZAuthor.h
//  ZenLegacy
//
//  Created by John Parron on 12/16/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZAuthor : NSObject
{
    NSNumber *_authorID;
    NSString *_name;
    NSString *_userName;
    NSString *_email;
}
@property (nonatomic, retain, readonly) NSNumber *authorID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;

- (id)initWithJSONObject:(NSDictionary *)object;

@end