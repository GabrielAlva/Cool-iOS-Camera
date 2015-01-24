//
//  CameraDismissButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraDismissButton.h"
#import "CameraStyleKitClass.h"

@implementation CameraDismissButton

- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawCameraDismissWithFrame:self.bounds];
}

@end
