//
//  CameraFlashButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraFlashButton.h"
#import "CameraStyleKitClass.h"

@implementation CameraFlashButton

- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawCameraFlashWithFrame:self.bounds];
}

@end
