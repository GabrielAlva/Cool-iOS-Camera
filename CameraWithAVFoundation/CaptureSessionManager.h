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

@interface CaptureSessionManager : NSObject

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

- (void)addStillImageOutput;
- (void)captureStillImage;
- (void)addVideoPreviewLayer;
- (void)addVideoInputFrontCamera:(BOOL)front;

@end
