//
//  AppDelegate.h
//  NSLockAndSynchronizedUse2
//
//  Created by 紫冬 on 13-8-30.
//  Copyright (c) 2013年 qsji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bread.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //这是线程要操作的共享资源
    NSMutableArray *_arraySource;
    int _index;
    NSLock *_lock;
}
@property(nonatomic, retain)NSMutableArray *arraySource;
@property(nonatomic, assign)int index;
@property(nonatomic, retain)NSLock *lock;

@property (strong, nonatomic) UIWindow *window;

@end
