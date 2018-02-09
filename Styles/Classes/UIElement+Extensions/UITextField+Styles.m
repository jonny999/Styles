//  Copyright © 2018 Inloop, s.r.o. All rights reserved.

#import "UITextField+Styles.h"
#import <objc/runtime.h>
#import "Swizzle.h"
#import "UIView+Styles.h"
#import <Styles/Styles-Swift.h>

@interface UITextField ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, TextStyle *> *textStyles;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, LayerStyle *> *layerStyles;
@end

@implementation UITextField (Styles)

- (NSMutableDictionary *)textStyles {
    NSMutableDictionary *stored = objc_getAssociatedObject(self, @selector(textStyles));
    if (!stored) {
        stored = [NSMutableDictionary new];
        [self setTextStyles:stored];
    }
    return stored;
}

- (NSMutableDictionary *)layerStyles {
    NSMutableDictionary *stored = objc_getAssociatedObject(self, @selector(layerStyles));
    if (!stored) {
        stored = [NSMutableDictionary new];
        [self setLayerStyles:stored];
    }
    return stored;
}

- (void)setLayerStyles:(NSMutableDictionary *)layerStyles {
    objc_setAssociatedObject(self, @selector(layerStyles), layerStyles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTextStyles:(NSMutableDictionary *)textStyles {
    objc_setAssociatedObject(self, @selector(textStyles), textStyles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        swizzle_instance_method(class, @selector(becomeFirstResponder), @selector(swizzle_becomeFirstResponder));
        swizzle_instance_method(class, @selector(resignFirstResponder), @selector(swizzle_resignFirstResponder));
    });
}

- (BOOL)swizzle_becomeFirstResponder {
    [self updateStylesForState:kEditing];
    return [super becomeFirstResponder];
}

- (BOOL)swizzle_resignFirstResponder {
    [self updateStylesForState:kInactive];
    return [super resignFirstResponder];
}

- (void)setTextStyle:(TextStyle *)style forState:(UITextFieldState)state {
    self.textStyles[@(state)] = style;
    [self applyStyle];
}

- (void)setLayerStyle:(LayerStyle *)style forState:(UITextFieldState)state {
    self.layerStyles[@(state)] = style;
    [self applyStyle];
}

- (void)updateStylesForState:(UITextFieldState)state {
    LayerStyle *layerStyle = self.layerStyles[@(state)];
    TextStyle *textStyle = self.textStyles[@(state)];

    [self updateTextFieldUsingTextStyle:textStyle];
    [self updateTextFieldUsingLayerStyle:layerStyle];
}

- (void)applyStyle {
    UITextFieldState state = [self isEditing] ? kEditing : kInactive;
    [self updateStylesForState:state];
}

- (void)updateTextFieldUsingTextStyle:(TextStyle *)style {
    NSString *text = self.text;
    if (!text || !style) {
        return;
    }
    [self setAttributedText:[style applyTo:text]];
}

- (void)updateTextFieldUsingLayerStyle:(LayerStyle *)style {
    if (!style) {
        return;
    }
    [style applyTo:self.layer];
}

@end
