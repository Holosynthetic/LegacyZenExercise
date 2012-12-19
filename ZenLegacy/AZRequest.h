//
//  AZRequest.h
//  ZenLegacy
//
//  Created by John Parron on 12/15/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AZRequest;

typedef enum {
    AZRequestMethodGET,
    AZRequestMethodPOST,
    AZRequestMethodPUT,
    AZRequestMethodDELETE,
} AZRequestMethod;

typedef void (^AZRequestHandler)(AZRequest *request, NSData *responseData, NSError *error);

@interface AZRequest : NSObject
{
    NSURL *_url;
    NSInteger _page;
    NSInteger _pageSize;
    NSArray *_enrichments;
    AZRequestMethod _requestMethod;
    NSData *_jsonData;
}
@property (nonatomic, retain) NSURL *url;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic, retain, readonly) NSArray *enrichments;
@property (nonatomic) AZRequestMethod requestMethod;

- (id)initWithURL:(NSURL *)url;

- (id)initWithURL:(NSURL *)url enrichments:(NSArray *)enrichments;

- (id)initWithURL:(NSURL *)url requestMethod:(AZRequestMethod)requestMethod;

- (id)initWithURL:(NSURL *)url enrichments:(NSArray *)enrichments requestMethod:(AZRequestMethod)requestMethod;

- (void)addJSONObject:(id)jsonObject;

- (void)performRequestWithHandler:(AZRequestHandler)handler;

+ (NSDate *)dateFromString:(NSString *)string;

@end