//
//  LittlePainterAppDelegate.m
//  LittlePainter
//
//  Created by bfu on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LittlePainterAppDelegate.h"
#import "LittlePainterViewController.h"

@implementation LittlePainterAppDelegate

@synthesize window;
@synthesize paintViewController;
@synthesize templatesListController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	// Set the view controller as the window's root view controller and display.

	UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:self.templatesListController];
    self.window.rootViewController = rootController;
	rootController.delegate = self;
	[rootController release];
	
	NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	cacheFile = [caches stringByAppendingPathComponent:@"Cached.png"];
	[cacheFile retain];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	needRestore = [[NSUserDefaults standardUserDefaults] boolForKey:@"NeedRestore"];
	
	if ([fm fileExistsAtPath:cacheFile] && needRestore) {
		UIImage *saved = [UIImage imageWithContentsOfFile:cacheFile];
		[self.window.rootViewController pushViewController:self.paintViewController animated:NO];
		self.paintViewController.restoreImage = saved;
	}

	[self.window makeKeyAndVisible];

    return YES;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	needRestore = NO;
	
	if (viewController == self.paintViewController) {
		needRestore = YES;
	}
	
	[[NSUserDefaults standardUserDefaults] setBool:needRestore forKey:@"NeedRestore"];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	if (needRestore) {
		[UIImagePNGRepresentation(self.paintViewController.paintView.image)
			writeToFile:cacheFile
			 atomically:NO];
	}
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[cacheFile release];
    [paintViewController release];
	[templatesListController release];
    [window release];
    [super dealloc];
}


@end
