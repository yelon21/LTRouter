//
//  LTNavigationController.m
//  LTBarrage
//
//  Created by yelon on 16/8/27.
//  Copyright © 2016年 yelon21. All rights reserved.
//

#import "LTNavigationController.h"

@interface LTNavigationController ()

@end

@implementation LTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
    
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

+ (LTNavigationController *)LT_NavigationController:(UIViewController *)rootViewController{
    
    LTNavigationController *controller = [[LTNavigationController alloc] initWithRootViewController:rootViewController];
    [controller.navigationBar setTranslucent:NO];
    [controller setBackgroundImage:[self imageWithColor:[UIColor blackColor]]];
    [controller.navigationBar setTintColor:[UIColor whiteColor]];
    [controller.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return controller;
}

+ (UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        [self.navigationBar setBackgroundImage:backgroundImage
                                forBarPosition:UIBarPositionTopAttached
                                    barMetrics:UIBarMetricsDefault];
    }
    else{
        
        [self.navigationBar setBackgroundImage:backgroundImage
                                 forBarMetrics:UIBarMetricsDefault];
    }
}
@end
