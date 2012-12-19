//
//  AZComposeViewController.m
//  ZenLegacy
//
//  Created by John Parron on 12/17/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AZComposeViewController.h"

#import "AZRequest.h"
#import "AZStory.h"

@implementation AZComposeViewController

@synthesize textView = _textView;
@synthesize story = _story;

#pragma mark - Actions

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)createComment
{
    if ([[_textView text] length] > 0)
    {
        NSString *urlPath = [NSString stringWithFormat:@"https://agilezen.com/api/v1/projects/%i/stories/%i/comments", [[_story projectID] integerValue], [[_story storyID] integerValue]];
        
        AZRequest *request = [[AZRequest alloc] initWithURL:[NSURL URLWithString:urlPath] requestMethod:AZRequestMethodPOST];
        
        NSDictionary *commentObject = [NSDictionary dictionaryWithObject:[_textView text] forKey:@"text"];
        
        [request addJSONObject:commentObject];
        
        [request performRequestWithHandler:^(AZRequest *request, NSData *responseData, NSError *error){
            
            if (responseData)
            {
                // Mark the conversations as updated
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setBool:YES forKey:@"kConversationsUpdated"];
                
                [userDefaults synchronize];
                
                // Dismiss view
                
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            
            [request release];
        }];
    }
}

#pragma mark - Controller Lifecycle

- (void)dealloc
{
    [_story release];
    [super dealloc];
}

- (id)initWithStory:(AZStory *)story
{
    self = [super init];
    
    if (self)
    {
        _story = [story retain];
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Compose";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(createComment)];
    self.navigationItem.rightBarButtonItem = postButton;
    [postButton release];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
    textView.contentInset = UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0);
    [self.view addSubview:textView];
    [textView release];
    self.textView = textView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _textView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [_textView becomeFirstResponder];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat kbHeight = CGRectGetHeight([(NSValue *)[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    
    CGRect currentBounds = [[UIScreen mainScreen] applicationFrame];
    
    _textView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(currentBounds), CGRectGetHeight(currentBounds) - (kbHeight + 44.0));
}

@end