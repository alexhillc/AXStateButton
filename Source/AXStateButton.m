//
//  AXStateButton.m
//  AXStateButton
//
//  Created by Alex Hill on 8/18/17.
//  Copyright © 2017 Alex Hill. All rights reserved.
//

#import "AXStateButton.h"

static NSString *_Nonnull AXStateButtonTintColorKey            = @"AXStateButtonTintColor";
static NSString *_Nonnull AXStateButtonBackgroundColorKey      = @"AXStateButtonBackgroundColor";
static NSString *_Nonnull AXStateButtonAlphaKey                = @"AXStateButtonAlpha";
static NSString *_Nonnull AXStateButtonCornerRadiusKey         = @"AXStateButtonCornerRadius";
static NSString *_Nonnull AXStateButtonBorderColorKey          = @"AXStateButtonBorderColor";
static NSString *_Nonnull AXStateButtonBorderWidthKey          = @"AXStateButtonBorderWidth";
static NSString *_Nonnull AXStateButtonTransformRotationXKey   = @"AXStateButtonTransformRotationX";
static NSString *_Nonnull AXStateButtonTransformRotationYKey   = @"AXStateButtonTransformRotationY";
static NSString *_Nonnull AXStateButtonTransformRotationZKey   = @"AXStateButtonTransformRotationZ";
static NSString *_Nonnull AXStateButtonTransformScaleKey       = @"AXStateButtonTransformScale";
static NSString *_Nonnull AXStateButtonShadowColorKey          = @"AXStateButtonShadowColor";
static NSString *_Nonnull AXStateButtonShadowOpacityKey        = @"AXStateButtonShadowOpacity";
static NSString *_Nonnull AXStateButtonShadowOffsetKey         = @"AXStateButtonShadowOffset";
static NSString *_Nonnull AXStateButtonShadowRadiusKey         = @"AXStateButtonShadowRadius";
static NSString *_Nonnull AXStateButtonShadowPathKey           = @"AXStateButtonShadowPath";

static NSString *_Nonnull AXAnimationKey   = @"AXAnimation";
static NSString *_Nonnull AXStateBlockKey  = @"AXStateBlock";

typedef void(^AXStateBlock)();

@interface AXStateButton ()

@property (nonnull) NSDictionary<NSString *, NSMutableDictionary<NSNumber *, id> *> *stateDictionary;

@end

@implementation AXStateButton

#pragma mark - Initialization
+ (instancetype)button {
    return [super buttonWithType:UIButtonTypeCustom];
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    [NSException raise:@"AXUnsupportedFactoryMethodException" format:@"Use +[AXStateButton button] instead."];
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.animateControlStateChanges = YES;
    self.controlStateAnimationDuration = 0.2;
    
    NSArray<NSString *> *keys = @[ AXStateButtonTintColorKey,
                                   AXStateButtonBackgroundColorKey,
                                   AXStateButtonAlphaKey,
                                   AXStateButtonCornerRadiusKey,
                                   AXStateButtonBorderColorKey,
                                   AXStateButtonBorderWidthKey,
                                   AXStateButtonTransformRotationXKey,
                                   AXStateButtonTransformRotationYKey,
                                   AXStateButtonTransformRotationZKey,
                                   AXStateButtonTransformScaleKey,
                                   AXStateButtonShadowColorKey,
                                   AXStateButtonShadowOpacityKey,
                                   AXStateButtonShadowOffsetKey,
                                   AXStateButtonShadowRadiusKey ];
    
    NSMutableDictionary<NSString *, NSMutableDictionary<NSNumber *, id> *> *stateDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        stateDictionary[key] = [NSMutableDictionary dictionary];
    }
    
    self.stateDictionary = [stateDictionary copy];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window && self.superview) {
        BOOL animateControlStateChanges = self.animateControlStateChanges;
        self.animateControlStateChanges = NO;
        [self updateButtonState];
        self.animateControlStateChanges = animateControlStateChanges;
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.window && self.superview) {
        BOOL animateControlStateChanges = self.animateControlStateChanges;
        self.animateControlStateChanges = NO;
        [self updateButtonState];
        self.animateControlStateChanges = animateControlStateChanges;
    }
}

#pragma mark - Control state updates
- (void)setSelected:(BOOL)selected {
    BOOL updateButtonState = (self.isSelected != selected);
    
    [super setSelected:selected];
    
    if (updateButtonState) {
        [self updateButtonState];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    BOOL updateButtonState = (self.isHighlighted != highlighted);
    
    [super setHighlighted:highlighted];
    
    if (updateButtonState) {
        [self updateButtonState];
    }
}

- (void)setEnabled:(BOOL)enabled {
    BOOL updateButtonState = (self.isEnabled != enabled);
    
    [super setEnabled:enabled];

    if (updateButtonState) {
        [self updateButtonState];
    }
}

- (void)updateButtonState {
    NSArray<NSDictionary<NSString *, id> *> *stateChanges = [self stateChangesForCurrentState];
    NSMutableArray<CAAnimation *> *animations = [NSMutableArray array];
    NSMutableArray<AXStateBlock> *stateBlocks = [NSMutableArray array];
    
    for (NSDictionary<NSString *, id> *stateChange in stateChanges) {
        CAAnimation *animation = stateChange[AXAnimationKey];
        if (animation) {
            [animations addObject:animation];
        }
        
        AXStateBlock stateBlock = stateChange[AXStateBlockKey];
        if (stateBlock) {
            [stateBlocks addObject:stateBlock];
        }
    }
    
    if (animations.count > 0) {
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = self.controlStateAnimationDuration;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group.animations = animations;
        
        [self.layer addAnimation:group forKey:@"AXGroupAnim"];
    }
    
    for (AXStateBlock stateBlock in stateBlocks) {
        stateBlock();
    }
}

#pragma mark - Control states
- (void)setTintColor:(UIColor *)tintColor forState:(UIControlState)controlState {
    if (tintColor) {
        self.stateDictionary[AXStateButtonTintColorKey][@(controlState)] = tintColor;
    } else {
        [self.stateDictionary[AXStateButtonTintColorKey] removeObjectForKey:@(controlState)];
    }
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (UIColor *)tintColorForState:(UIControlState)controlState {
    return self.stateDictionary[AXStateButtonTintColorKey][@(controlState)];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)controlState {
    if (backgroundColor) {
        self.stateDictionary[AXStateButtonBackgroundColorKey][@(controlState)] = backgroundColor;
    } else {
        [self.stateDictionary[AXStateButtonBackgroundColorKey] removeObjectForKey:@(controlState)];
    }
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (UIColor *)backgroundColorForState:(UIControlState)controlState {
    return self.stateDictionary[AXStateButtonBackgroundColorKey][@(controlState)];
}

- (void)setAlpha:(CGFloat)alpha forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonAlphaKey][@(controlState)] = @(alpha);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)alphaForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonAlphaKey][@(controlState)] floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonCornerRadiusKey][@(controlState)] = @(cornerRadius);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)cornerRadiusForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonCornerRadiusKey][@(controlState)] floatValue];
}

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)controlState {
    if (borderColor) {
        self.stateDictionary[AXStateButtonBorderColorKey][@(controlState)] = borderColor;
    } else {
        [self.stateDictionary[AXStateButtonBorderColorKey] removeObjectForKey:@(controlState)];
    }
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (UIColor *)borderColorForState:(UIControlState)controlState {
    return self.stateDictionary[AXStateButtonBorderColorKey][@(controlState)];
}

- (void)setBorderWidth:(CGFloat)borderWidth forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonBorderWidthKey][@(controlState)] = @(borderWidth);

    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)borderWidthForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonBorderWidthKey][@(controlState)] floatValue];
}

- (void)setTransformRotationX:(CGFloat)radians forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonTransformRotationXKey][@(controlState)] = @(radians);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)transformRotationXForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonTransformRotationXKey][@(controlState)] floatValue];
}

- (void)setTransformRotationY:(CGFloat)radians forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonTransformRotationYKey][@(controlState)] = @(radians);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)transformRotationYForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonTransformRotationYKey][@(controlState)] floatValue];
}

- (void)setTransformRotationZ:(CGFloat)radians forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonTransformRotationZKey][@(controlState)] = @(radians);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)transformRotationZForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonTransformRotationZKey][@(controlState)] floatValue];
}

- (void)setTransformScale:(CGFloat)scale forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonTransformScaleKey][@(controlState)] = @(scale);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)transformScaleForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonTransformScaleKey][@(controlState)] floatValue];
}

- (void)setShadowColor:(UIColor *)shadowColor forState:(UIControlState)controlState {
    if (shadowColor) {
        self.stateDictionary[AXStateButtonShadowColorKey][@(controlState)] = shadowColor;
    } else {
        [self.stateDictionary[AXStateButtonShadowColorKey] removeObjectForKey:@(controlState)];
    }
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (UIColor *)shadowColorForState:(UIControlState)controlState {
    return self.stateDictionary[AXStateButtonShadowColorKey][@(controlState)];
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonShadowOpacityKey][@(controlState)] = @(shadowOpacity);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)shadowOpacityForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonShadowOpacityKey][@(controlState)] floatValue];
}

- (void)setShadowOffset:(CGSize)shadowOffset forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonShadowOffsetKey][@(controlState)] = [NSValue valueWithCGSize:shadowOffset];
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGSize)shadowOffsetForState:(UIControlState)controlState {
    return [(NSValue *)self.stateDictionary[AXStateButtonShadowOffsetKey][@(controlState)] CGSizeValue];
}

- (void)setShadowRadius:(CGFloat)shadowRadius forState:(UIControlState)controlState {
    self.stateDictionary[AXStateButtonShadowRadiusKey][@(controlState)] = @(shadowRadius);
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (CGFloat)shadowRadiusForState:(UIControlState)controlState {
    return [self.stateDictionary[AXStateButtonShadowRadiusKey][@(controlState)] floatValue];
}

- (void)setShadowPath:(UIBezierPath *)shadowPath forState:(UIControlState)controlState {
    if (shadowPath) {
        self.stateDictionary[AXStateButtonShadowPathKey][@(controlState)] = shadowPath;
    } else {
        [self.stateDictionary[AXStateButtonShadowPathKey] removeObjectForKey:@(controlState)];
    }
    
    if (self.window && self.superview) {
        [self updateButtonState];
    }
}

- (UIBezierPath *)shadowPathForState:(UIControlState)controlState {
    return self.stateDictionary[AXStateButtonShadowPathKey][@(controlState)];
}

#pragma mark - Factory methods
- (NSArray<NSDictionary<NSString *, id> *> *)stateChangesForCurrentState {
    UIControlState currentState = self.state;
    
    NSMutableArray<NSDictionary<NSString *, id> *> *stateChangesDictionary = [NSMutableArray array];
    
    [self.stateDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyKey,
                                                              NSMutableDictionary<NSNumber *,id> * _Nonnull stateDictionary,
                                                              BOOL * _Nonnull stop) {
        
        UIControlState state = currentState;
        id value = stateDictionary[@(state)];
        if (!value) {
            if (state == UIControlStateNormal) {
                return;
            }
            
            // default to normal
            state = UIControlStateNormal;
            value = stateDictionary[@(state)];
            if (!value) {
                return;
            }
        }
        
        NSDictionary<NSString *, id> *changes = nil;
        
        if (propertyKey == AXStateButtonTintColorKey) {
            changes = [self tintColorStateChangesForState:state];
        } else if (propertyKey == AXStateButtonBackgroundColorKey) {
            changes = [self backgroundColorStateChangesForState:state];
        } else if (propertyKey == AXStateButtonAlphaKey) {
            changes = [self alphaStateChangesForState:state];
        } else if (propertyKey == AXStateButtonCornerRadiusKey) {
            changes = [self cornerRadiusStateChangesForState:state];
        } else if (propertyKey == AXStateButtonBorderColorKey) {
            changes = [self borderColorStateChangesForState:state];
        } else if (propertyKey == AXStateButtonBorderWidthKey) {
            changes = [self borderWidthStateChangesForState:state];
        } else if (propertyKey == AXStateButtonTransformRotationXKey) {
            changes = [self transformRotationXStateChangesForState:state];
        } else if (propertyKey == AXStateButtonTransformRotationYKey) {
            changes = [self transformRotationYStateChangesForState:state];
        } else if (propertyKey == AXStateButtonTransformRotationZKey) {
            changes = [self transformRotationZStateChangesForState:state];
        } else if (propertyKey == AXStateButtonTransformScaleKey) {
            changes = [self transformScaleStateChangesForState:state];
        } else if (propertyKey == AXStateButtonShadowColorKey) {
            changes = [self shadowColorStateChangesForState:state];
        } else if (propertyKey == AXStateButtonShadowOpacityKey) {
            changes = [self shadowOpacityStateChangesForState:state];
        } else if (propertyKey == AXStateButtonShadowOffsetKey) {
            changes = [self shadowOffsetStateChangesForState:state];
        } else if (propertyKey == AXStateButtonShadowRadiusKey) {
            changes = [self shadowOffsetStateChangesForState:state];
        } else if (propertyKey == AXStateButtonShadowPathKey) {
            changes = [self shadowPathStateChangesForState:state];
        }
        
        if (changes) {
            [stateChangesDictionary addObject:changes];
        }
    }];
    
    return [stateChangesDictionary copy];
}

- (NSDictionary<NSString *, id> *)tintColorStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    AXStateBlock block = ^() {
        weakSelf.tintColor = [weakSelf tintColorForState:controlState];
    };
    
    return @{ AXStateBlockKey: block };
}

- (NSDictionary<NSString *, id> *)backgroundColorStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *backgroundColorKeyPath = @"backgroundColor";
        CGColorRef fromValue = (__bridge CGColorRef)([self.layer.presentationLayer valueForKeyPath:backgroundColorKeyPath]);
        CGColorRef toValue = [self backgroundColorForState:controlState].CGColor;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:backgroundColorKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = (__bridge id _Nullable)(fromValue);
        animation.toValue = (__bridge id _Nullable)(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.backgroundColor = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.backgroundColor = [weakSelf backgroundColorForState:controlState].CGColor;
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)alphaStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *opacityKeyPath = @"opacity";
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:opacityKeyPath] floatValue];
        CGFloat toValue = [self alphaForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:opacityKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.opacity = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.opacity = [weakSelf alphaForState:controlState];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)cornerRadiusStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *cornerRadiusKeyPath = @"cornerRadius";
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:cornerRadiusKeyPath] floatValue];
        CGFloat toValue = [self cornerRadiusForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:cornerRadiusKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.cornerRadius = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.cornerRadius = [weakSelf cornerRadiusForState:controlState];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)borderColorStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *borderColorKeyPath = @"borderColor";
        CGColorRef fromValue = (__bridge CGColorRef)([self.layer.presentationLayer valueForKeyPath:borderColorKeyPath]);
        CGColorRef toValue = [self borderColorForState:controlState].CGColor;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:borderColorKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = (__bridge id _Nullable)(fromValue);
        animation.toValue = (__bridge id _Nullable)(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.borderColor = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.borderColor = [weakSelf borderColorForState:controlState].CGColor;
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)borderWidthStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *borderWidthKeyPath = @"borderWidth";
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:borderWidthKeyPath] floatValue];
        CGFloat toValue = [self borderWidthForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:borderWidthKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.borderWidth = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.borderWidth = [weakSelf borderWidthForState:controlState];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)transformRotationXStateChangesForState:(UIControlState)controlState {
    NSString *xRotationKeyPath = @"transform.rotation.x";
    
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:xRotationKeyPath] floatValue];
        CGFloat toValue = [self transformRotationXForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:xRotationKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@(toValue) forKeyPath:xRotationKeyPath];
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@([weakSelf transformRotationXForState:controlState]) forKeyPath:xRotationKeyPath];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)transformRotationYStateChangesForState:(UIControlState)controlState {
    NSString *yRotationKeyPath = @"transform.rotation.y";
    
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:yRotationKeyPath] floatValue];
        CGFloat toValue = [self transformRotationYForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:yRotationKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@(toValue) forKeyPath:yRotationKeyPath];
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@([weakSelf transformRotationYForState:controlState]) forKeyPath:yRotationKeyPath];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)transformRotationZStateChangesForState:(UIControlState)controlState {
    NSString *zRotationKeyPath = @"transform.rotation.z";
    
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:zRotationKeyPath] floatValue];
        CGFloat toValue = [self transformRotationZForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:zRotationKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@(toValue) forKeyPath:zRotationKeyPath];
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@([weakSelf transformRotationZForState:controlState]) forKeyPath:zRotationKeyPath];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)transformScaleStateChangesForState:(UIControlState)controlState {
    NSString *scaleKeyPath = @"transform.scale";
    
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:scaleKeyPath] floatValue];
        CGFloat toValue = [self transformScaleForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:scaleKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@(toValue) forKeyPath:scaleKeyPath];
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            [weakSelf.layer setValue:@([weakSelf transformScaleForState:controlState]) forKeyPath:scaleKeyPath];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)shadowColorStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *shadowColorKeyPath = @"shadowColor";
        CGColorRef fromValue = (__bridge CGColorRef)([self.layer.presentationLayer valueForKeyPath:shadowColorKeyPath]);
        CGColorRef toValue = [self shadowColorForState:controlState].CGColor;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:shadowColorKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = (__bridge id _Nullable)(fromValue);
        animation.toValue = (__bridge id _Nullable)(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.shadowColor = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.shadowColor = [weakSelf shadowColorForState:controlState].CGColor;
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)shadowOpacityStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *shadowOpacityKeyPath = @"shadowOpacity";
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:shadowOpacityKeyPath] floatValue];
        CGFloat toValue = [self shadowOpacityForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:shadowOpacityKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.shadowOpacity = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.shadowOpacity = [weakSelf shadowOpacityForState:controlState];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)shadowOffsetStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *shadowOffsetKeyPath = @"shadowOffset";
        CGSize fromValue = [[self.layer.presentationLayer valueForKeyPath:shadowOffsetKeyPath] CGSizeValue];
        CGSize toValue = [self shadowOffsetForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:shadowOffsetKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = [NSValue valueWithCGSize:fromValue];
        animation.toValue = [NSValue valueWithCGSize:toValue];
        
        AXStateBlock block = ^() {
            weakSelf.layer.shadowOffset = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.shadowOffset = [weakSelf shadowOffsetForState:controlState];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)shadowRadiusStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *shadowRadiusKeyPath = @"shadowRadius";
        CGFloat fromValue = [[self.layer.presentationLayer valueForKeyPath:shadowRadiusKeyPath] floatValue];
        CGFloat toValue = [self shadowRadiusForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:shadowRadiusKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = @(fromValue);
        animation.toValue = @(toValue);
        
        AXStateBlock block = ^() {
            weakSelf.layer.shadowRadius = toValue;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.shadowRadius = [weakSelf shadowRadiusForState:controlState];
        };
        
        return @{ AXStateBlockKey: block };
    }
}

- (NSDictionary<NSString *, id> *)shadowPathStateChangesForState:(UIControlState)controlState {
    __weak typeof(self) weakSelf = self;
    
    if (self.animateControlStateChanges) {
        NSString *shadowPathKeyPath = @"shadowPath";
        UIBezierPath *fromValue = [self.layer.presentationLayer valueForKeyPath:shadowPathKeyPath];
        UIBezierPath *toValue = [self shadowPathForState:controlState];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:shadowPathKeyPath];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = fromValue;
        animation.toValue = toValue;
        
        AXStateBlock block = ^() {
            weakSelf.layer.shadowPath = toValue.CGPath;
        };
        
        return @{
                 AXAnimationKey: animation,
                 AXStateBlockKey: block
                 };
    } else {
        AXStateBlock block = ^() {
            weakSelf.layer.shadowPath = [weakSelf shadowPathForState:controlState].CGPath;
        };
        
        return @{ AXStateBlockKey: block };
    }
}

@end
