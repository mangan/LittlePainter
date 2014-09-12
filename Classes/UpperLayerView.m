//
//  UpperLayer.m
//  LittlePainter
//
//  Created by bfu on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UpperLayerView.h"


@implementation UpperLayerView
	
@synthesize brushColor;
@synthesize templateImage;
@synthesize brushSize;

-(void)setTemplateImage:(UIImage *)aTemplate {
	[templateImage autorelease];
	templateImage = aTemplate;
	[templateImage retain];
}

-(void)setBrushColor:(UIColor *)aColor {
	[brushColor autorelease];
	brushColor = aColor;
	[brushColor retain];
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	int padding = 10;
	int x = self.frame.size.width - padding;
	int y = self.frame.size.height - padding;
	
	CGRect brushRect = CGRectMake(x - brushSize, y - brushSize, brushSize, brushSize);
	UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:brushRect];
	
	[self.templateImage drawAtPoint:CGPointMake(0, 0)];
	
	path.lineWidth = 2;
	[[UIColor blackColor] setStroke];
	[self.brushColor setFill];
	[path fill];
	[path stroke];
}


- (void)dealloc {
	[brushColor release];
	[templateImage release];
    [super dealloc];
}


@end
