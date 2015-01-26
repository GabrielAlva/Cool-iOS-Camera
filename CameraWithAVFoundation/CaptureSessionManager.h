//
//  CaptureSessionManager.h
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 4/16/14.
//  Copyright (c) 2014 Gabriel Alvarado. All rights reserved.
//
#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

///Protocol Definition
@protocol CaptureSessionManagerDelegate <NSObject>
@required - (void)cameraSessionManagerDidCaptureImage;
@required - (void)cameraSessionManagerFailedToCaptureImage;
@optional - (void)cameraSessionManagerCannotAccessFrontFacingCamera;
@optional - (void)cameraSessionManagerCannotAccessBackFacingCamera;


@end

@interface CaptureSessionManager : NSObject

@property (nonatomic, weak) id<CaptureSessionManagerDelegate>delegate;
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;
@property (nonatomic,assign,getter=isTorchEnabled) BOOL enableTorch;

- (void)addStillImageOutput;
- (void)captureStillImage;
- (void)addVideoPreviewLayer;
- (void)addVideoInputFrontCamera:(BOOL)front;

@end
