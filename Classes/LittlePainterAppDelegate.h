//
//  LittlePainterAppDelegate.h
//  LittlePainter
//
//  Created by bfu on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateListController.h"

@class LittlePainterViewController;

@interface LittlePainterAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> {
    UIWindow *window;
    LittlePainterViewController *paintViewController;
	TemplateListController *templatesListController;
	NSString *cacheFile;
	BOOL needRestore;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LittlePainterViewController *paintViewController;
@property (nonatomic, retain) IBOutlet TemplateListController *templatesListController;

@end

