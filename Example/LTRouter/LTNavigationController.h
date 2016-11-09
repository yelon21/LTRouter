//
//  LTNavigationController.h
//  LTBarrage
//
//  Created by yelon on 16/8/27.
//  Copyright © 2016年 yelon21. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "UINavigationBar+LTUtil.h"

@interface LTNavigationController : UINavigationController

+ (LTNavigationController *)LT_NavigationController:(UIViewController *)rootViewController;

- (void)setBackgroundImage:(UIImage *)backgroundImage;
@end
