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
@property AXStateButton *loadingButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Sample material button
    self.materialButton = [self createMaterialButton];
    [self.view addSubview:self.materialButton];
    
    // Sample loading button
    self.loadingButton = [self createLoadingButton];
    [self.view addSubview:self.loadingButton];
}

- (AXStateButton *)createMaterialButton {
    AXStateButton *materialButton = [AXStateButton button];
    materialButton.controlStateAnimationDuration = 0.1;
    [materialButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [materialButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"+"
                                                                       attributes:@{
                                                                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:28],
                                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                    }]
                              forState:UIControlStateNormal];
    [materialButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    
    [materialButton setTransformRotationZ:0 forState:UIControlStateNormal];
//    [materialButton setTransformRotationZ:M_PI_4 forState:UIControlStateHighlighted];
    
    [materialButton setTransformScale:1.0 forState:UIControlStateNormal];
    [materialButton setTransformScale:0.95 forState:UIControlStateHighlighted];
    
    [materialButton setShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [materialButton setShadowOpacity:0.2 forState:UIControlStateNormal];
    [materialButton setShadowOffset:CGSizeMake(2, 2) forState:UIControlStateNormal];
    [materialButton setShadowOpacity:0.4 forState:UIControlStateHighlighted];
    
    [materialButton setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [materialButton setBackgroundColor:[UIColor colorWithRed:216. / 255. green:0.0 blue:0.0 alpha:1.0]
                              forState:UIControlStateHighlighted];
    
    CGSize buttonSize = CGSizeMake(56, 56);
    [materialButton setCornerRadius:buttonSize.height / 2 forState:UIControlStateNormal];
    materialButton.frame = (CGRect){ CGPointZero, buttonSize };
    
    return materialButton;
}

- (AXStateButton *)createLoadingButton {
    AXStateButton *loadingButton = [AXStateButton button];
    loadingButton.controlStateAnimationDuration = 0.1;
    [loadingButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [loadingButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Load"
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                                                                   NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                   }]
                             forState:UIControlStateNormal];
    [loadingButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading..."
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                                                                   NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                   }]
                             forState:UIControlStateDisabled];
    
    [loadingButton setShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loadingButton setShadowOpacity:0.2 forState:UIControlStateNormal];
    [loadingButton setShadowOffset:CGSizeMake(2, 2) forState:UIControlStateNormal];
    [loadingButton setShadowOpacity:0.4 forState:UIControlStateHighlighted];
    
    [loadingButton setTransformRotationX:0 forState:UIControlStateNormal];
    [loadingButton setTransformRotationX:M_PI forState:UIControlStateDisabled];
    
    [loadingButton setTransformRotationY:0 forState:UIControlStateNormal];
    [loadingButton setTransformRotationY:M_PI forState:UIControlStateDisabled];
    
    [loadingButton setTransformRotationZ:0 forState:UIControlStateNormal];
    [loadingButton setTransformRotationZ:M_PI forState:UIControlStateDisabled];
    
    [loadingButton setBackgroundColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [loadingButton setBackgroundColor:[UIColor colorWithRed:102. / 255. green:0.0 blue:102. / 255. alpha:1.0]
                             forState:UIControlStateHighlighted];
    [loadingButton setBackgroundColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    CGSize buttonSize = CGSizeMake(100, 50);
    [loadingButton setCornerRadius:buttonSize.height / 2 forState:UIControlStateNormal];
    [loadingButton setCornerRadius:0 forState:UIControlStateDisabled];
    loadingButton.frame = (CGRect){ CGPointZero, buttonSize };
    
    return loadingButton;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGPoint materialButtonCenter = self.view.center;
    materialButtonCenter.y -= 50;
    self.materialButton.center = materialButtonCenter;
    
    CGPoint loadingButtonCenter = self.view.center;
    loadingButtonCenter.y += 50;
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
