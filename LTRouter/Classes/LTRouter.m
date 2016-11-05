//
//  LTRouter.m
//  Pods
//
//  Created by yelon on 16/11/4.
//
//

#import "LTRouter.h"


NSString *LTLTRouter_FilterString(id obj){
    
    if (obj == nil) {
        
        return @"";
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        
        return [NSString stringWithFormat:@"%@",obj];
        
    }else if([obj isKindOfClass:[NSNumber class]]){
        
        return [NSString stringWithFormat:@"%@",obj];
    }
    return @"";
    
}

//实例生成的类方法
#define kInitFunctionName @"LT_InitInstanceWithPara:"

static UIViewController *LT_defaultRootViewController = nil;

@implementation LTRouter

/**
 设置默认根视图
 
 @param rootVC 根视图控制器
 */
+ (void)LT_SetDefaultRootViewController:(UIViewController *)rootVC{

    if (!rootVC || ![rootVC isKindOfClass:[UIViewController class]]) {
        
        return;
    }
    LT_defaultRootViewController = [rootVC retain];
}

/**
 关闭视图控制器
 
 @param viewCon 要关闭的视图控制器
 @param animated 是否动画
 */
+ (void)LT_CloseViewController:(UIViewController *)viewCon animated:(BOOL)animated{

    if (!viewCon || ![viewCon isKindOfClass:[UIViewController class]]) {
        
        return;
    }
    
    UINavigationController *nav = viewCon.navigationController;
    
    if (nav) {
        
        if ([nav.viewControllers count] > 1) {
            
            [nav popViewControllerAnimated:animated];
        }
        else {
        
            [LTRouter LT_CloseViewController:nav animated:animated];
        }
    }
    else{
    
        if (viewCon.presentingViewController) {
            
            [viewCon dismissViewControllerAnimated:animated completion:nil];
        }
        else if (LT_defaultRootViewController
                 &&[LT_defaultRootViewController isKindOfClass:[UIViewController class]]){
        
            if (viewCon != LT_defaultRootViewController) {
                
                [[UIApplication sharedApplication].delegate window].rootViewController = LT_defaultRootViewController;
            }
        }
    }
}

/**
 开启一个视图控制器
 
 @param urlString url格式，host为类名，query为相关参数
 @param animated 是否动画
 */
+ (void)LT_OpenUrl:(NSString *)urlString animated:(BOOL)animated{
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:LTLTRouter_FilterString(urlString)];
    
    __strong UIViewController *viewControlelr = [self LT_GetViewController:urlString];
    
    if (!viewControlelr || ![viewControlelr isKindOfClass:[UIViewController class]]) {
        
        return;
    }
    
    NSString *scheme = LTLTRouter_FilterString(url.scheme);
    
    if ([viewControlelr isKindOfClass:[UINavigationController class]]) {
        
        scheme = kLTRouterSchemePresent;
    }
    
    if ([scheme isEqualToString:kLTRouterSchemePush]) {
        
        [self LT_PushViewController:viewControlelr animated:animated];
    }
    else{
        
        [self LT_PresentViewController:viewControlelr
                              animated:animated
                            completion:nil];
    }
}


//push 一视图控制器
+ (void)LT_PushViewController:(UIViewController *)viewCon
                     animated:(BOOL)animated{

    UINavigationController *nav = [self LT_FrontNavigationViewController];
    
    if (!nav) {
        
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:viewCon];
        
        [self LT_PresentViewController:navCon
                              animated:animated
                            completion:nil];
        [navCon release];
    }
    else{
        
        [nav pushViewController:viewCon animated:animated];
    }
}

//present 一视图控制器
+ (void)LT_PresentViewController:(UIViewController *)viewCon
                        animated:(BOOL)animated
                      completion:(void (^ __nullable)(void))completion{

    UIViewController *frontVC = [self LT_FrontViewController];
    
    if (frontVC) {
        
        [frontVC presentViewController:viewCon
                              animated:animated
                            completion:completion];
        
    }
    else{
        
        [[UIApplication sharedApplication].delegate window].rootViewController = frontVC;
    }

}

//根据urlString获取实例
+ (UIViewController *)LT_GetViewController:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (!url) {
        
        return nil;
    }
    
    NSString *className = LTLTRouter_FilterString(url.host);
    
    Class vcClass = NSClassFromString(className);
    
    if (!vcClass) {
        
        return nil;
    }
    
    SEL instanceSEL = NSSelectorFromString(kInitFunctionName);
    
    if (![vcClass respondsToSelector:instanceSEL]) {
        
        return nil;
    }
    
    
    UIViewController *instance = nil;//[vcClass alloc];
    
    NSMethodSignature *sig  = [vcClass methodSignatureForSelector:instanceSEL];
    
    NSInvocation *invocatin = [NSInvocation invocationWithMethodSignature:sig];
    [invocatin setTarget:vcClass];
    [invocatin setSelector:instanceSEL];
    
    NSString *query = LTLTRouter_FilterString(url.query);
    
    NSDictionary *para = [self getParamsDicByString:query];
    
    [invocatin setArgument:&para atIndex:2];
    [invocatin invoke];
    
    [invocatin getReturnValue:&instance];
    
    if (!instance) {
        
        return nil;
    }
    
    return instance;
}

//根据query获取参数
+ (NSDictionary *)getParamsDicByString:(NSString *)query{
    
    query = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *queryList = [query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *paraDic = [[[NSMutableDictionary alloc]init] autorelease];
    
    [queryList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *para = obj;
        
        NSArray *paraArray = [para componentsSeparatedByString:@"="];
        
        if ([paraArray count]>1) {
            
            NSString *key = LTLTRouter_FilterString([paraArray firstObject]);
            
            paraDic[key] = LTLTRouter_FilterString(paraArray[1]);
        }
    }];
    
    return paraDic;
}

//获取最前端的 UINavigationController
+ (UINavigationController *)LT_FrontNavigationViewController{
    
    UIViewController *viewCon = [self LT_FrontViewController];
    
    return [self LT_FindFrontNavigationViewController:viewCon];
}

+ (UINavigationController *)LT_FindFrontNavigationViewController:(UIViewController *)root{
    
    UIViewController *rootVC = root;
    
    if (rootVC.presentedViewController) {
        
        return [self LT_FindFrontNavigationViewController:rootVC.presentedViewController];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        
        return rootVC;
    }
    else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        return [self LT_FindFrontNavigationViewController:[(UITabBarController *)rootVC selectedViewController]];
    }
    else if ([rootVC isKindOfClass:[UIViewController class]]) {
        
        return rootVC.navigationController;
    }
    return nil;
}

//获取最前端的 UIViewController
+ (UIViewController *)LT_FrontViewController{
    
    UIViewController *viewCon = [[UIApplication sharedApplication].delegate window].rootViewController;
    return [self LT_FindFrontViewController:viewCon];
}

+ (UIViewController *)LT_FindFrontViewController:(UIViewController *)root{
    
    UIViewController *rootVC = root;
    
    if (rootVC.presentedViewController) {
        
        return [self LT_FindFrontViewController:rootVC.presentedViewController];
    }
    return rootVC;
}

@end

NSString * const kLTRouterSchemePresent = @"LTRouterSchemePresent";
NSString * const kLTRouterSchemePush    = @"LTRouterSchemePush";
NSString * const kLTRouterSchemeDefault = @"LTRouterSchemeDefault";
