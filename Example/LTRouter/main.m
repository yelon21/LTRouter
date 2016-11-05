//
//  main.m
//  LTRouter
//
//  Created by yjpal on 11/04/2016.
//  Copyright (c) 2016 yjpal. All rights reserved.
//

@import UIKit;
#import "LYAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        @try {
            
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([LYAppDelegate class]));
            
        } @catch (NSException *exception) {
            
            NSLog(@"exception=%@",exception);
        }
        
    }
}
