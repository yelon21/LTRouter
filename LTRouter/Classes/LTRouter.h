//
//  LTRouter.h
//  Pods
//
//  Created by yelon on 16/11/4.
//
//

#import <Foundation/Foundation.h>

@interface LTRouter : NSObject

/**
 设置默认根视图

 @param rootVC 根视图控制器
 */
+ (void)LT_SetDefaultRootViewController:(UIViewController *)rootVC;


/**
 navClass

 @param navClass navClass
 */
+ (void)LT_SetDefaultNavigationViewControllerClass:(Class)navClass;

/**
 开启一个视图控制器

 @param urlString url格式，host为类名，query为相关参数
 @param animated 是否动画
 @return UIViewController
 */
+ (id)LT_OpenUrl:(NSString *)urlString animated:(BOOL)animated;

/**
 关闭视图控制器

 @param viewCon 要关闭的视图控制器
 @param animated 是否动画
 */
+ (void)LT_CloseViewController:(UIViewController *)viewCon animated:(BOOL)animated;
@end

extern NSString * const kLTRouterSchemePresent;
extern NSString * const kLTRouterSchemePush;
extern NSString * const kLTRouterSchemeDefault;
