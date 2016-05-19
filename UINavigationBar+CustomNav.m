//
//  UINavigationBar+CustomNav.m
//  IOSProgrammerTest
//
//  Created by Vetri Selvi Vairamuthu on 5/18/16.
//  Copyright © 2016 AppPartner. All rights reserved.
//

#import "UINavigationBar+CustomNav.h"

@implementation UINavigationBar (CustomNav)
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    CGSize newSize = CGSizeMake(width,68);
    return newSize;
}
@end
