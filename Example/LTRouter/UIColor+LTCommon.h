//
//  UIColor+LTCommon.h
//  YLkit
//
//  Created by yelon on 15/7/19.
//  Copyright (c) 2015年 yelon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define UIColorRGB(r,g,b) UIColorRGBA(r,g,b,1.0)

#define UIColorRGBHex(rgbValue) UIColorRGBAHex(rgbValue,1.0)

#define UIColorRGBAHex(rgbValue,alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]
@interface UIColor (LTCommon)
/**
 *  @author yelon
 *
 *  根据色值返回颜色对象
 *
 *  @param hex 十六进制RGB色值
 *
 *  @return 颜色UIColor
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
/**
 *  @author yelon
 *
 *  根据色值返回颜色对象
 *
 *  @param hex 十六进制RGB色值字符串
 *
 *  @return 颜色UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
