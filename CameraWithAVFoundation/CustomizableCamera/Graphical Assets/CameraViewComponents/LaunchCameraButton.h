//
//  LaunchCameraButton.h
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 2/18/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchCameraButton : UIButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
