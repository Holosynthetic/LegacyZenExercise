//
//  AZComposeViewController.h
//  ZenLegacy
//
//  Created by John Parron on 12/17/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZStory;

@interface AZComposeViewController : UIViewController
{
    UITextView *_textView;
    AZStory *_story;
}
@property (nonatomic, assign) UITextView *textView;
@property (nonatomic, retain) AZStory *story;

- (id)initWithStory:(AZStory *)story;

@end