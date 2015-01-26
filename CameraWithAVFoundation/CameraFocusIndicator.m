//
//  CameraFocusIndicator.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/25/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraFocusIndicator.h"
#import "CameraStyleKitClass.h"

@implementation CameraFocusIndicator

- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawCameraFocusWithFrame:self.bounds];
}

@end
