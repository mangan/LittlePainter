//
//  LittlePainterViewController.m
//  LittlePainter
//
//  Created by bfu on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LittlePainterViewController.h"

#define BRUSH_SIZE 24
#define REDRAW_PERIOD (1.0 / 24)
#define MIN_PATH_LEN 10

@implementation LittlePainterViewController

@synthesize paintView;
@synthesize upperLayer;
@synthesize brushColor;
@synthesize brushSize;
@synthesize restoreImage;
@synthesize colorSelection;
@synthesize colors;
#ifdef INDIRECT_DRAWING
@synthesize paintImage;
#endif

-(void)restoreSavedState {
	NSString *label = [[NSUserDefaults standardUserDefaults] stringForKey:@"Selection"];
	
	UIImage *template = [UIImage imageWithContentsOfFile:
						 [[NSBundle mainBundle] pathForResource:label
														 ofType:@"png"
													inDirectory:@"Templates"]];
	
	NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"SelectedColor"];
	UIColor *color = [UIColor redColor];
	if (data != nil) {
	color = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
	}

	self.paintView.image = self.restoreImage;
	self.paintImage = self.restoreImage;
	self.upperLayer.templateImage = template;
	self.brushColor = color;
}

-(void)setBrushColor:(UIColor *)aColor {
	[brushColor autorelease];
	brushColor = aColor;
	[brushColor retain];
	self.upperLayer.brushColor = brushColor;
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:brushColor];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SelectedColor"];
	
}

-(void)setBrushSize:(int)aSize {
	brushSize = aSize;
	self.upperLayer.brushSize = brushSize;
}

-(void)resetWithTemplate:(UIImage *)aTemplate {
	self.brushColor = [UIColor redColor];
	self.upperLayer.templateImage = aTemplate;
	
	UIGraphicsBeginImageContextWithOptions(self.paintView.frame.size, YES, 0.0);
	[[UIColor whiteColor] set];
	UIRectFill(self.paintView.frame);
#ifdef INDIRECT_DRAWING
	self.paintImage = UIGraphicsGetImageFromCurrentImageContext();
	self.paintView.image = self.paintImage;
#else
	self.paintView.image = UIGraphicsGetImageFromCurrentImageContext();
#endif
	UIGraphicsEndImageContext();
}

-(void)redrawWithLineFrom:(CGPoint)start to:(CGPoint)end {
	UIBezierPath *path = [UIBezierPath bezierPath];
	UIGraphicsBeginImageContextWithOptions(self.paintView.frame.size, YES, 0.0);
#ifdef INDIRECT_DRAWING	
	[self.paintImage drawAtPoint:CGPointMake(0, 0)];
#else	
	[self.paintView.image drawAtPoint:CGPointMake(0, 0)];
#endif	
	[self.brushColor set];
	
	path.lineWidth = self.brushSize;
	path.lineCapStyle = kCGLineCapRound;
	
	[path moveToPoint:start];
	[path addLineToPoint:end];
	[path stroke];

#ifdef INDIRECT_DRAWING
	self.paintImage = UIGraphicsGetImageFromCurrentImageContext();
	waitingForUpdate = YES;
#else	
	self.paintView.image = UIGraphicsGetImageFromCurrentImageContext();
#endif
	UIGraphicsEndImageContext();
}

#ifdef INDIRECT_DRAWING
-(void)tick:(NSTimer *)aTimer {
	if (waitingForUpdate) {
		self.paintView.image = self.paintImage;
		waitingForUpdate = NO;
	}
}
#endif

-(IBAction)changeColor:(id)sender {
	switch ([sender tag]) {
		case 1:
			self.brushColor = [UIColor redColor];
			break;
		case 2:
			self.brushColor = [UIColor greenColor];
			break;
		case 3:
			self.brushColor = [UIColor blueColor];
			break;
		case 4:
			self.brushColor = [UIColor yellowColor];
			break;
	}
}

-(IBAction)showColorSelection:(id)sender {
	[self presentModalViewController:self.colorSelection animated:YES];
}

-(void)colorChosen:(id)sender {
	self.brushColor = [self.colors objectAtIndex:[sender tag]];
	[self dismissModalViewControllerAnimated:YES];
}

-(void)setBackgroundForButton:(UIButton *)button {
	[button setBackgroundColor:[self.colors objectAtIndex:[button tag]]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	recentTouch = [[touches anyObject] locationInView:self.paintView];
	[self redrawWithLineFrom:recentTouch to:recentTouch];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint current = [[touches anyObject] locationInView:self.paintView];
	
#ifdef INDIRECT_DRAWING
	int minLenSquare = minLength*minLength;
	int x = recentTouch.x - current.x;
	int y = recentTouch.y - current.y;
	
	if(x*x + y*y < minLenSquare) return;
#endif
	
	[self redrawWithLineFrom:recentTouch to:current];
	recentTouch = current;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
	}
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
	if (error) {
		[[[[UIAlertView alloc]
		 initWithTitle:@"Save Failed"
		 message:[error localizedDescription]
		 delegate:nil
		 cancelButtonTitle:@"Close"
		 otherButtonTitles:nil]
		  autorelease] show];
	} else {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Success"
		   message:@"Image saved"
		   delegate:nil
		   cancelButtonTitle:@"Close"
		   otherButtonTitles:nil]
		  autorelease] show];
	}
		
}

-(void)save:(id)sender {
	UIGraphicsBeginImageContextWithOptions(self.paintView.frame.size, YES, 0.0);
	[self.paintView.image drawAtPoint:CGPointMake(0, 0)];
	[self.upperLayer.templateImage drawAtPoint:CGPointMake(0, 0)];
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(result, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.colors = [NSArray arrayWithObjects:
				   [UIColor redColor],
				   [UIColor greenColor],
				   [UIColor blueColor],
				   [UIColor yellowColor],
				   [UIColor	blackColor],
				   [UIColor grayColor],
				   [UIColor brownColor],
				   [UIColor colorWithRed:0 green:0.53 blue:0 alpha:1.0],
				   [UIColor colorWithRed:0 green:0.75 blue:1 alpha:1.0],
				   [UIColor colorWithRed:0.53 green:0 blue:0 alpha:1.0],
				   [UIColor orangeColor],
				   [UIColor purpleColor],
				   [UIColor colorWithRed:1.0 green:0.75 blue:0.8 alpha:1.0],
				   nil];
	
	for(id view in self.view.subviews) {
		if ([view isKindOfClass:[UIToolbar class]]) {
			int i = 1;
			for(id item in [view subviews]) {
				UIColor *color = NULL;
				switch (i++) {
					case 1:
						color = [UIColor redColor];
						break;
					case 2:
						color = [UIColor greenColor];
						break;
					case 3:
						color = [UIColor blueColor];
						break;
					case 4:
						color = [UIColor yellowColor];
						break;
				}
				if (color != NULL) [item setTintColor:color];
			}
		}
	}
	
	if (self.restoreImage != NULL) {
		[self restoreSavedState];
		self.restoreImage = NULL;
	}
	self.brushSize = BRUSH_SIZE;
#ifdef INDIRECT_DRAWING
	minLength = MIN_PATH_LEN;
	updatePeriod = REDRAW_PERIOD;
	timer = [NSTimer
			 scheduledTimerWithTimeInterval:updatePeriod
			 target:self
			 selector:@selector(tick:)
			 userInfo:nil
			 repeats:YES];
	[timer retain];
#endif
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[colors retain];
	[paintView release];
	[upperLayer release];
    [brushColor release];
	[restoreImage release];
	[colorSelection release];
#ifdef INDIRECT_DRAWING
	[paintImage release];
	[timer release];
#endif
	[super dealloc];
}

@end
