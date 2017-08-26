//
//  ViewController.m
//  AXStateButtonExample
//
//  Created by Alex Hill on 8/24/17.
//  Copyright © 2017 Alex Hill. All rights reserved.
//

#import "ViewController.h"
@import AXStateButton;

@interface ViewController ()

@property AXStateButton *materialButton;
@property AXStateButton *tryAgainButton;
@property AXStateButton *loadingButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Sample material button
    self.materialButton = [self createMaterialButton];
    [self.view addSubview:self.materialButton];
    
    // Try again button
    self.tryAgainButton = [self createTryAgainButton];
    [self.view addSubview:self.tryAgainButton];
    
    // Sample loading button
    self.loadingButton = [self createLoadingButton];
    [self.view addSubview:self.loadingButton];
}

- (AXStateButton *)createMaterialButton {
    AXStateButton *button = [AXStateButton button];
    button.controlStateAnimationDuration = 0.1;
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"+"
                                                               attributes:@{
                                                                            NSFontAttributeName: [UIFont boldSystemFontOfSize:28],
                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                            }]
                      forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    
    [button setTransformRotationZ:0 forState:UIControlStateNormal];
//    [button setTransformRotationZ:M_PI_4 forState:UIControlStateHighlighted];
    
    [button setTransformScale:1.0 forState:UIControlStateNormal];
    [button setTransformScale:0.95 forState:UIControlStateHighlighted];
    
    [button setShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setShadowOpacity:0.2 forState:UIControlStateNormal];
    [button setShadowOffset:CGSizeMake(2, 2) forState:UIControlStateNormal];
    [button setShadowOpacity:0.4 forState:UIControlStateHighlighted];
    
    [button setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:216. / 255. green:0.0 blue:0.0 alpha:1.0]
                      forState:UIControlStateHighlighted];
    
    CGSize buttonSize = CGSizeMake(56, 56);
    [button setCornerRadius:buttonSize.height / 2 forState:UIControlStateNormal];
    button.frame = (CGRect){ CGPointZero, buttonSize };
    
    return button;
}

- (AXStateButton *)createTryAgainButton {
    AXStateButton *button = [AXStateButton button];
//    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"Try again" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [button setAlpha:1.0 forState:UIControlStateNormal];
    [button setAlpha:0.7 forState:UIControlStateHighlighted];
    
    [button setTransformScale:1.0 forState:UIControlStateNormal];
    [button setTransformScale:0.95 forState:UIControlStateHighlighted];
    
    [button setBorderWidth:1.0 forState:UIControlStateNormal];
    [button setBorderColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    CGSize buttonSize = CGSizeMake(90, 30);
    [button setCornerRadius:6.0 forState:UIControlStateNormal];
    button.frame = (CGRect){ CGPointZero, buttonSize };
    
    return button;
}

- (AXStateButton *)createLoadingButton {
    AXStateButton *button = [AXStateButton button];
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Load"
                                                               attributes:@{
                                                                            NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                            }]
                      forState:UIControlStateNormal];
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading..."
                                                               attributes:@{
                                                                            NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                            }]
                      forState:UIControlStateDisabled];
    
    [button setShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setShadowOpacity:0.2 forState:UIControlStateNormal];
    [button setShadowOffset:CGSizeMake(2, 2) forState:UIControlStateNormal];
    [button setShadowOpacity:0.4 forState:UIControlStateHighlighted];
    
    [button setTransformRotationX:0 forState:UIControlStateNormal];
    [button setTransformRotationX:M_PI forState:UIControlStateDisabled];
    
    [button setTransformRotationY:0 forState:UIControlStateNormal];
    [button setTransformRotationY:M_PI forState:UIControlStateDisabled];
    
    [button setTransformRotationZ:0 forState:UIControlStateNormal];
    [button setTransformRotationZ:M_PI forState:UIControlStateDisabled];
    
    [button setBackgroundColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:102. / 255. green:0.0 blue:102. / 255. alpha:1.0]
                      forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    CGSize buttonSize = CGSizeMake(100, 50);
    [button setCornerRadius:buttonSize.height / 2 forState:UIControlStateNormal];
    [button setCornerRadius:0 forState:UIControlStateDisabled];
    button.frame = (CGRect){ CGPointZero, buttonSize };
    
    return button;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGPoint materialButtonCenter = self.view.center;
    materialButtonCenter.y -= 100;
    self.materialButton.center = materialButtonCenter;
    
    CGPoint tryAgainButtonCenter = self.view.center;
    self.tryAgainButton.center = tryAgainButtonCenter;
    
    CGPoint loadingButtonCenter = self.view.center;
    loadingButtonCenter.y += 100;
    self.loadingButton.center = loadingButtonCenter;
}

- (void)buttonTap:(AXStateButton *)sender {
    if (sender == self.materialButton) {
//        sender.selected = !sender.isSelected;
    } else {
        sender.enabled = !sender.isEnabled;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.enabled = !sender.enabled;
        });
    }
}

@end
