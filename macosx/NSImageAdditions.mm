// This file Copyright © 2011-2022 Transmission authors and contributors.
// It may be used under the MIT (SPDX: MIT) license.
// License text can be found in the licenses/ folder.

#import "CocoaCompatibility.h"

#import "NSImageAdditions.h"
#import "NSApplicationAdditions.h"

@implementation NSImage (NSImageAdditions)

#define ICON_WIDTH 16.0
#define BORDER_WIDTH 1.25

+ (NSImage*)discIconWithColor:(NSColor*)color insetFactor:(CGFloat)insetFactor
{
    return [NSImage imageWithSize:NSMakeSize(ICON_WIDTH, ICON_WIDTH) flipped:NO drawingHandler:^BOOL(NSRect rect) {
        //shape
        rect = NSInsetRect(rect, BORDER_WIDTH / 2 + rect.size.width * insetFactor / 2, BORDER_WIDTH / 2 + rect.size.height * insetFactor / 2);
        NSBezierPath* bp = [NSBezierPath bezierPathWithOvalInRect:rect];
        bp.lineWidth = BORDER_WIDTH;

        //border
        CGFloat fractionOfBlendedColor = NSApp.darkMode ? 0.15 : 0.3;
        NSColor* borderColor = [color blendedColorWithFraction:fractionOfBlendedColor ofColor:NSColor.controlTextColor];
        [borderColor setStroke];
        [bp stroke];

        //inside
        [color setFill];
        [bp fill];

        return YES;
    }];
}

- (NSImage*)imageWithColor:(NSColor*)color
{
    NSImage* coloredImage = [self copy];

    [coloredImage lockFocus];

    [color set];

    NSSize const size = coloredImage.size;
    NSRectFillUsingOperation(NSMakeRect(0.0, 0.0, size.width, size.height), NSCompositingOperationSourceAtop);

    [coloredImage unlockFocus];

    return coloredImage;
}

+ (NSImage*)systemSymbol:(NSString*)symbolName withFallback:(NSString*)fallbackName
{
    if (@available(macOS 11.0, *))
    {
        return [NSImage imageWithSystemSymbolName:symbolName accessibilityDescription:nil];
    }

    return [NSImage imageNamed:fallbackName];
}

+ (NSImage*)largeSystemSymbol:(NSString*)symbolName withFallback:(NSString*)fallbackName
{
#ifdef __MAC_11_0
    if (@available(macOS 11.0, *))
    {
        return [[NSImage imageWithSystemSymbolName:symbolName accessibilityDescription:nil]
            imageWithSymbolConfiguration:[NSImageSymbolConfiguration configurationWithScale:NSImageSymbolScaleLarge]];
    }
#endif

    return [NSImage imageNamed:fallbackName];
}

@end
