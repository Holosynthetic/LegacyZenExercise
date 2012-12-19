//
//  AZRequest.m
//  ZenLegacy
//
//  Created by John Parron on 12/15/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZRequest.h"

@implementation AZRequest

@synthesize url = _url;
@synthesize page = _page;
@synthesize pageSize = _pageSize;
@synthesize enrichments = _enrichments;
@synthesize requestMethod = _requestMethod;

static NSString *const API_KEY = @"YOUR_API_KEY";

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [_url release];
    [_enrichments release];
    [_jsonData release];
    [super dealloc];
}

- (id)initWithURL:(NSURL *)url
{
    self = [self initWithURL:url enrichments:nil requestMethod:AZRequestMethodGET];
    
    return self;
}

- (id)initWithURL:(NSURL *)url enrichments:(NSArray *)enrichments
{
    self = [self initWithURL:url enrichments:enrichments requestMethod:AZRequestMethodGET];
    
    return self;
}

- (id)initWithURL:(NSURL *)url requestMethod:(AZRequestMethod)requestMethod
{
    self = [self initWithURL:url enrichments:nil requestMethod:requestMethod];
    
    return self;
}

- (id)initWithURL:(NSURL *)url enrichments:(NSArray *)enrichments requestMethod:(AZRequestMethod)requestMethod
{
    self = [super init];
    
    if (self)
    {
        _url = [url retain];
        
        _page = 1;
        
        _pageSize = 100;
        
        _enrichments = [enrichments retain];
        
        _requestMethod = requestMethod;
    }
    
    return self;
}

#pragma mark - Core Methods

- (void)performRequestWithHandler:(AZRequestHandler)handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSMutableString *urlPath = [[NSMutableString alloc] initWithString:[_url absoluteString]];
        
        if (_requestMethod == AZRequestMethodGET)
        {
            [urlPath appendFormat:@"?page=%i&pageSize=%i", _page, _pageSize];
            
            if (_enrichments && [_enrichments count])
            {
                [urlPath appendFormat:@"&with=%@", [_enrichments componentsJoinedByString:@","]];
            }
        }
        
        NSMutableURLRequest *apiRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath]];
        
        [urlPath release];
        
        [apiRequest addValue:API_KEY forHTTPHeaderField:@"X-Zen-ApiKey"];
        
        [apiRequest setHTTPMethod:[self stringForRequestMethod:_requestMethod]];
        
        if ((_requestMethod == AZRequestMethodPOST || _requestMethod == AZRequestMethodPUT) && _jsonData)
        {
            [apiRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [apiRequest setHTTPBody:_jsonData];
        }
        
        NSURLResponse *returnedResponse;
        
        NSError *errorResponse = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:apiRequest returningResponse:&returnedResponse error:&errorResponse];
        
        [apiRequest release];
        
        if (handler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                handler(self, responseData, errorResponse);
                
            });
        }
    });
}

- (void)addJSONObject:(id)jsonObject
{
    [_jsonData release];
    
    _jsonData = nil;
    
    if ([NSJSONSerialization isValidJSONObject:jsonObject])
    {
        _jsonData = [[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONReadingMutableLeaves error:nil] retain];
    }
}

#pragma mark - Getter Methods

- (NSArray *)enrichments
{
    return [NSArray arrayWithArray:_enrichments];
}

#pragma mark - Private Methods

- (NSString *)stringForRequestMethod:(AZRequestMethod)requestMethod
{
    switch (requestMethod)
    {
        case AZRequestMethodGET:
            return @"GET";
            break;
            
        case AZRequestMethodPOST:
            return @"POST";
            break;
            
        case AZRequestMethodPUT:
            return @"PUT";
            break;
            
        case AZRequestMethodDELETE:
            return @"DELETE";
            break;
    }
}

#pragma mark - Shared Methods

+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    return [formatter dateFromString:string];
}

@end