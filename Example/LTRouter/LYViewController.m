//
//  LYViewController.m
//  LTRouter
//
//  Created by yjpal on 11/04/2016.
//  Copyright (c) 2016 yjpal. All rights reserved.
//

#import "LYViewController.h"
#import "LTRouter.h"
#import "Page1VC.h"
#import "UIColor+LTCommon.h"

@interface LYViewController ()

@end

@implementation LYViewController

+ (id)LT_InitInstanceWithPara:(NSDictionary *)para{

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LYViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LYViewController"];
    NSLog(@"para=%@",para);
    UIColor *color  = [UIColor colorWithHexString:para[@"color"]];
    if (!color) {
        
        color = [UIColor lightGrayColor];
    }
    vc.view.backgroundColor = color;
    vc.title = para[@"model"];
    
    return vc;
}

-(void)dealloc{

    NSLog(@"dealloc=%@",@"dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [LTRouter LT_SetDefaultNavigationViewControllerClass:NSClassFromString(@"LTNavigationController")];
}

- (NSString *)randomColor{

    NSMutableArray *array = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < 3; i++) {
        
        u_int32_t random = arc4random()%0x100;
        
        [array addObject:[NSString stringWithFormat:@"%02X",random]];
    }
    
    return [array componentsJoinedByString:@""];
}

- (IBAction)presentAction:(id)sender {
    
    [LTRouter LT_OpenUrl:[NSString stringWithFormat:@"%@://%@",kLTRouterSchemePresent,[NSString stringWithFormat:@"LYViewController?model=%@&color=%@&rr=232",kLTRouterSchemePresent,[self randomColor]]]
                animated:YES];
}

- (IBAction)disMissAction:(id)sender {
    
    [LTRouter LT_CloseViewController:self animated:YES];
}


- (IBAction)pushAction:(id)sender {
    
    UIViewController *viewCon = [LTRouter LT_OpenUrl:[NSString stringWithFormat:@"%@://%@",kLTRouterSchemePush,[NSString stringWithFormat:@"Page1VC?model=%@&color=%@&rr=开心吗",kLTRouterSchemePush,[self randomColor]]]
                animated:YES];
    
    [(Page1VC *)viewCon ssssss];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
