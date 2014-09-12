//
//  ColorSelectionController.h
//  LittlePainter
//
//  Created by bfu on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorSelectionDelegate <NSObject>

-(void)colorChosen:(id)sender;
-(void)setBackgroundForButton:(UIButton *)button;

@end

@interface ColorSelectionController : UIViewController {
	id<ColorSelectionDelegate> delegate;
}

@property (nonatomic,retain) IBOutlet id<ColorSelectionDelegate> delegate;

-(IBAction)colorChosen:(id)sender;

@end
