//
//  UpperLayer.h
//  LittlePainter
//
//  Created by bfu on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpperLayerView : UIView {
	UIColor *brushColor;
	int brushSize;
	UIImage *templateImage;
}

@property (nonatomic,retain) UIColor *brushColor;
@property (nonatomic) int brushSize;
@property (nonatomic,retain) UIImage *templateImage;

@end
