//
//  Constants.m
//  CameraWithAVFoundation
//
//  Created by Christopher Cohen on 1/29/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "Constants.h"

@implementation Constants

CameraStatistics cameraStatisticsMake(float aperture, float exposureDuration, float ISO, float lensPostion) {
    CameraStatistics cameraStatistics;
    cameraStatistics.aperture = aperture;
    cameraStatistics.exposureDuration = exposureDuration;
    cameraStatistics.ISO = ISO;
    cameraStatistics.lensPosition = lensPostion;
    return cameraStatistics;
}


@end
