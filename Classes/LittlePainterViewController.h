//
//  LittlePainterViewController.h
//  LittlePainter
//
//  Created by bfu on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpperLayerView.h"
#import	"ColorSelectionController.h"

#define INDIRECT_DRAWING 1

@interface LittlePainterViewController : UIViewController <ColorSelectionDelegate> {
	UIImageView *paintView;
	UpperLayerView *upperLayer;
	CGPoint recentTouch;
	UIColor *brushColor;
	int brushSize;
	UIImage *restoreImage;
	ColorSelectionController *colorSelection;
	NSArray *colors;
	
#ifdef INDIRECT_DRAWING
	NSTimeInterval updatePeriod;
	int minLength;
	UIImage *paintImage;
	BOOL waitingForUpdate;
	NSTimer *timer;
#endif
}

@property (nonatomic,retain) IBOutlet UIImageView *paintView;
@property (nonatomic,retain) IBOutlet UpperLayerView *upperLayer;
@property (nonatomic,retain) IBOutlet ColorSelectionController *colorSelection;
@property (nonatomic,retain) UIColor *brushColor;
@property (nonatomic) int brushSize;
@property (nonatomic,retain) UIImage *restoreImage;
@property (nonatomic,retain) NSArray *colors;
#ifdef INDIRECT_DRAWING
@property (nonatomic,retain) UIImage *paintImage;
#endif

-(IBAction)changeColor:(id)sender;
-(IBAction)showColorSelection:(id)sender;
-(void)resetWithTemplate:(UIImage *)aTemplate;
-(IBAction)save:(id)sender;
-(void)actionInModalViewDone;

@end

