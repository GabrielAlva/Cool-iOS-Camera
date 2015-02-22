//
//  Constants.h
//  CameraWithAVFoundation
//
//  Created by Christopher Cohen on 1/24/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

///Type Definitions

typedef NS_ENUM(BOOL, CameraType) {
    FrontFacingCamera,
    RearFacingCamera,
};

typedef NS_ENUM(NSInteger, BarButtonTag) {
    ShutterButtonTag,
    ToggleButtonTag,
    FlashButtonTag,
    DismissButtonTag,
};

typedef struct {
    CGFloat ISO;
    CGFloat exposureDuration;
    CGFloat aperture;
    CGFloat lensPosition;
} CameraStatistics;

///Function Prototype declarations

CameraStatistics cameraStatisticsMake(float aperture, float exposureDuration, float ISO, float lensPostion);

@end
