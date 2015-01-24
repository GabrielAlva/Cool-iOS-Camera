//
//  CameraTopBarView.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraTopBarView.h"
#import "CameraStyleKitClass.h"

@implementation CameraTopBarView

- (void)drawRect:(CGRect)rect {
    [CameraStyleKitClass drawCameraTopBarWithFrame:self.bounds];
}

@end
