//
//  CameraShutterButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraShutterButton.h"
#import "CameraStyleKitClass.h"

@implementation CameraShutterButton

- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawCameraShutterWithFrame:self.bounds];
}

@end
