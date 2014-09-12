//
//  TemplatesList.h
//  NavBased1
//
//  Created by bfu on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittlePainterViewController.h"


@interface TemplateListController : UITableViewController {
	NSArray *templates;
	LittlePainterViewController *nextView;
}

@property (nonatomic,retain) NSArray *templates;
@property (nonatomic,retain) IBOutlet LittlePainterViewController *nextView;

@end
