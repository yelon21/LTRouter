//
//  Page1VC.m
//  LTRouter
//
//  Created by yelon on 16/11/5.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import "Page1VC.h"
//#import "UIColor+LTCommon.h"
#import "LTRouter.h"

@interface Page1VC ()

@end

@implementation Page1VC

+ (id)LT_InitInstanceWithPara:(NSDictionary *)para{
    
    Page1VC *vc = [[Page1VC alloc]init];
    NSLog(@"para=%@",para);
    
//    UIColor *color  = [UIColor colorWithHexString:para[@"color"]];
//    if (!color) {
//        
//        color = [UIColor lightGrayColor];
//    }
    vc.view.backgroundColor = [UIColor lightGrayColor];
    
    vc.title = para[@"model"];
    
    return vc;
}

-(void)ssssss{

    NSLog(@"0099");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 80, 40)];
    [btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor]
              forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)pushAction{

    [LTRouter LT_OpenUrl:[NSString stringWithFormat:@"%@://%@",kLTRouterSchemePush,[NSString stringWithFormat:@"LYViewController?model=%@&rr=开心吗",kLTRouterSchemePush]]
                animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [LTRouter LT_CloseViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

@end
