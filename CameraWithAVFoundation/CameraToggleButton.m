//
//  CameraToggleButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraToggleButton.h"
#import "CameraStyleKitClass.h"

@implementation CameraToggleButton

- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawCameraToggleWithFrame:self.bounds];
}

@end
