//
//  CaptureSessionManager.h
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 4/16/14.
//  Copyright (c) 2014 Gabriel Alvarado. All rights reserved.
//
#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

///Protocol Definition
@protocol CaptureSessionManagerDelegate <NSObject>
@required - (void)cameraSessionManagerDidCaptureImage;
@required - (void)cameraSessionManagerFailedToCaptureImage;
@required - (void)cameraSessionManagerDidReportAvailability:(BOOL)deviceAvailability forCameraType:(CameraType)cameraType;
@required - (void)cameraSessionManagerDidReportDeviceStatistics:(CameraStatistics)deviceStatistics; //Report every .125 seconds

@end

@interface CaptureSessionManager : NSObject

//Weak pointers
@property (nonatomic, weak) id<CaptureSessionManagerDelegate>delegate;
@property (nonatomic, weak) AVCaptureDevice *activeCamera;

//Strong Pointers
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIImage *stillImage;
@property (nonatomic, strong) NSData *stillImageData;

//Primative Variables
@property (nonatomic,assign,getter=isTorchEnabled) BOOL enableTorch;

//API Methods
- (void)addStillImageOutput;
- (void)captureStillImage;
- (void)addVideoPreviewLayer;
- (void)initiateCaptureSessionForCamera:(CameraType)cameraType;
- (void)stop;

@end
