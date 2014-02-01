//
//  CUBRootViewController.m
//  TapCounter
//
//  Created by Harshad on 31/01/2014.
//  Copyright (c) 2014 Laughing Buddha Software. All rights reserved.
//

#import "CUBRootViewController.h"
#import <notify.h>

NSString *const TapCountFilePath = @"/var/mobile/Library/Preferences/com.lbs.tapCounter";

@interface CUBRootViewController () {
    __weak UILabel *_tapLabel;
    long long _taps;
}

- (void)didBecomeActive:(NSNotification *)notification;

@end

@implementation CUBRootViewController

- (void)didBecomeActive:(NSNotification *)notification {
    [self readTaps];
    [self updateLabel];
}

- (void)updateLabel {
    [_tapLabel setText:[NSString stringWithFormat:@"%lld", _taps]];
}

- (void)touchReset {
    _taps = 0;
    [self updateLabel];
    notify_post("com.laughing-buddha-software.tapCounter.reset");
}

- (void)readTaps {
    NSString *taps = [NSString stringWithContentsOfFile:TapCountFilePath encoding:NSUTF8StringEncoding error:nil];
    _taps = [taps longLongValue];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _taps = 0;
    
    [self setTitle:@"TapCounter"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width - 20, 50)];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    _tapLabel = label;
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton setFrame:CGRectMake((self.view.bounds.size.width - 100) / 2, 170, 100, 45)];
    [self.view addSubview:resetButton];
    [resetButton addTarget:self action:@selector(touchReset) forControlEvents:UIControlEventTouchUpInside];
    
    int incrementToken;
    notify_register_dispatch("com.laughing-buddha-software.tapCounter.changed",
                             &incrementToken,
                             dispatch_get_main_queue(), ^(int t) {
                                 _taps++;
                                 [self updateLabel];
                             });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self readTaps];
    [self updateLabel];
}


@end
