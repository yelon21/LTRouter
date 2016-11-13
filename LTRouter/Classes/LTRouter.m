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
static Class LT_defaultNavigationViewControllerClass = nil;

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

+ (void)LT_SetDefaultNavigationViewControllerClass:(Class)navClass{

    if (!navClass || ![[navClass new] isKindOfClass:[UINavigationController class]]) {
        
        return;
    }
    
    LT_defaultNavigationViewControllerClass = navClass;
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
        
        NSArray *viewControllers = nav.viewControllers;
        
        NSUInteger index = [viewControllers indexOfObject:viewCon];
        
        if (index == NSNotFound) {
            
            return;
        }
        else if (index > 0) {
            
            UIViewController *toVC = [viewControllers objectAtIndex:index-1];
            [nav popToViewController:toVC animated:animated];
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
+ (id)LT_OpenUrl:(NSString *)urlString animated:(BOOL)animated{

    urlString = LTLTRouter_FilterString(urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        
        url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [self LT_OpenURL:url animated:animated];
}
/**
 开启一个视图控制器
 
 @param url url格式，host为类名，query为相关参数
 @param animated 是否动画
 */
+ (id)LT_OpenURL:(NSURL *)url animated:(BOOL)animated{
    
    __strong UIViewController *viewControlelr = [self LT_GetViewController:url.absoluteString];
    
    if (!viewControlelr || ![viewControlelr isKindOfClass:[UIViewController class]]) {
        
        return nil;
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
    
    return viewControlelr;
}


//push 一视图控制器
+ (void)LT_PushViewController:(UIViewController *)viewCon
                     animated:(BOOL)animated{

    UINavigationController *nav = [self LT_FrontNavigationViewController];
    
    if (!nav) {
        
        Class navClass = LT_defaultNavigationViewControllerClass;
        if (!navClass) {
            
            navClass = [UINavigationController class];
        }
        
        UINavigationController *navCon = [[(UINavigationController *)navClass alloc] initWithRootViewController:viewCon];
        
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
        
        [[UIApplication sharedApplication].delegate window].rootViewController = viewCon;
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

#import <objc/runtime.h>

@interface UIApplication (LTCommon)

@end

@implementation UIApplication (LTCommon)

+ (void)load {
    
    [self swizzleSelector:@selector(openURL:)
             withSelector:@selector(lt_openURL:)];
    
    [self swizzleSelector:@selector(openURL:options:completionHandler:)
             withSelector:@selector(lt_openURL:options:completionHandler:)];
}

+ (void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

-(BOOL)lt_openURL:(NSURL *)url{
    
    NSString *scheme = url.scheme;
    
    if ([scheme isEqualToString:kLTRouterSchemeDefault]
        ||[scheme isEqualToString:kLTRouterSchemePush]
        |[scheme isEqualToString:kLTRouterSchemePresent]) {
        
        [LTRouter LT_OpenURL:url animated:YES];
        return NO;
    }
    else{
    
        return [self lt_openURL:url];
    }
}

-(void)lt_openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL))completion{
    
    NSString *scheme = url.scheme;
    
    if ([scheme isEqualToString:kLTRouterSchemeDefault]
        ||[scheme isEqualToString:kLTRouterSchemePush]
        |[scheme isEqualToString:kLTRouterSchemePresent]) {
        
        [LTRouter LT_OpenURL:url animated:YES];
        
        completion(NO);
    }
    else{
        
        return [self lt_openURL:url
                        options:options
              completionHandler:completion];
    }
}

@end


