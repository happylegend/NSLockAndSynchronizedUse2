//
//  AppDelegate.m
//  NSLockAndSynchronizedUse2
//
//  Created by 紫冬 on 13-8-30.
//  Copyright (c) 2013年 qsji. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize arraySource = _arraySource;
@synthesize index = _index;
@synthesize lock = _lock;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //创建生产者和消费者线程
    NSLock *aLock = [[NSLock alloc] init];
    self.lock = aLock;
    NSThread *produceThread = [[NSThread alloc] initWithTarget:self selector:@selector(produce) object:nil];
    NSThread *consumeThread = [[NSThread alloc] initWithTarget:self selector:@selector(consume) object:nil];
    
    /*
     当然我们也可以将NSLock锁作为参数，让多个线程共用
     NSLock *aLock = [[NSLock alloc] init];
     NSThread *produceThread = [[NSThread alloc] initWithTarget:self selector:@selector(produce:) object:aLock];
     NSThread *consumeThread = [[NSThread alloc] initWithTarget:self selector:@selector(consume:) object:aLock];
     
     -(void)produce:(NSLock *)lock
     {
        [lock lock];
        //......
        [lock unlock];
     }
     
     -(void)consume:(NSLock *)lock
     {
        [lock lock];
        //......
        [lock unlock];
     }
     
     */
    
    [produceThread start];
    [consumeThread start];
    
    [aLock release];
    aLock = nil;
    
    return YES;
}

-(void)produce
{
    
    //使用NSLock
    for (int i = 0; i < 20; i++)
    {
        [self.lock lock];
        (self.index)++;
        NSLog(@"生产第%d个面包", self.index);
        Bread *bread = [[Bread alloc] init];
        [self.arraySource addObject:bread];
        [bread release];
        bread = nil;
        [self.lock unlock];
    }
    
    //使用@synchronized
    for (int i = 0; i < 20; i++)
    {
        @synchronized(self)
        {
            (self.index)++;
            NSLog(@"生产第%d个面包", self.index);
            Bread *bread = [[Bread alloc] init];
            [self.arraySource addObject:bread];
            [bread release];
            bread = nil;
        }
                
    }

}

-(void)consume
{
    //使用NSLock
    for (int i = 0; i < 20; i++)
    {
        [self.lock lock];
        NSLog(@"消费第%d个面包", self.index);
        [self.arraySource removeObjectAtIndex:i];
        
        [self.lock unlock];
    }
    
    //使用@synchronized
    for (int i = 0; i < 20; i++)
    {
        @synchronized(self)
        {
            NSLog(@"消费第%d个面包", self.index);
            [self.arraySource removeObjectAtIndex:i];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
