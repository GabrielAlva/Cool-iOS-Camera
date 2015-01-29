//
//  CaptureSessionManager.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 4/16/14.
//  Copyright (c) 2014 Gabriel Alvarado. All rights reserved.
//

#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize stillImage;
@synthesize stillImageData;

#pragma mark Capture Session Configuration

- (id)init {
	if ((self = [super init])) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
        captureSession.sessionPreset = AVCaptureSessionPresetHigh;
	}
	return self;
}

- (void)addVideoPreviewLayer {
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)initiateCaptureSessionForCamera:(CameraType)cameraType {
    
    //Iterate through devices and assign 'active camera' per parameter
    for (AVCaptureDevice *device in AVCaptureDevice.devices) if ([device hasMediaType:AVMediaTypeVideo]) {
        switch (cameraType) {
            case RearFacingCamera:  if ([device position] == AVCaptureDevicePositionBack)   _activeCamera = device; break;
            case FrontFacingCamera: if ([device position] == AVCaptureDevicePositionFront)  _activeCamera = device; break;
        }
    }
        
    NSError *error          = nil;
    BOOL deviceAvailability = YES;
    
    AVCaptureDeviceInput *cameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_activeCamera error:&error];
    if (!error && [[self captureSession] canAddInput:cameraDeviceInput]) [[self captureSession] addInput:cameraDeviceInput];
    else deviceAvailability = NO;
    
    //Report camera device availability
    if (self.delegate) [self.delegate cameraSessionManagerDidReportAvailability:deviceAvailability forCameraType:cameraType];
    
    [self initiateActiveCameraStatisticsReportLoop];
}

-(void)initiateActiveCameraStatisticsReportLoop {
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        do {
            [NSThread sleepForTimeInterval:.125];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"ISO: %f \n APERTURE: %f \n LENS POSITION: %f \n EXPOSURE DURATION: %f", _activeCamera.ISO, _activeCamera.lensAperture, _activeCamera.lensPosition, CMTimeGetSeconds(_activeCamera.exposureDuration));
            }];
        } while (true);
    }];
}

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                AVCaptureVideoOrientation newOrientation;
                switch ([[UIDevice currentDevice] orientation]) {
                    case UIDeviceOrientationPortrait:
                        newOrientation = AVCaptureVideoOrientationPortrait;
                        break;
                    case UIDeviceOrientationPortraitUpsideDown:
                        newOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                        break;
                    case UIDeviceOrientationLandscapeLeft:
                        newOrientation = AVCaptureVideoOrientationLandscapeRight;
                        break;
                    case UIDeviceOrientationLandscapeRight:
                        newOrientation = AVCaptureVideoOrientationLandscapeLeft;
                        break;
                    default:
                        newOrientation = AVCaptureVideoOrientationPortrait;
                }
                [videoConnection setVideoOrientation: newOrientation];
                break;
            }
        }
        if (videoConnection) {
            AVCaptureVideoOrientation newOrientation;
            switch ([[UIDevice currentDevice] orientation]) {
                case UIDeviceOrientationPortrait:
                    newOrientation = AVCaptureVideoOrientationPortrait;
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    newOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                    break;
                case UIDeviceOrientationLandscapeLeft:
                    newOrientation = AVCaptureVideoOrientationLandscapeRight;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    newOrientation = AVCaptureVideoOrientationLandscapeLeft;
                    break;
                default:
                    newOrientation = AVCaptureVideoOrientationPortrait;
            }
            [videoConnection setVideoOrientation: newOrientation];
            break;
        }
    }
    
    [[self captureSession] addOutput:[self stillImageOutput]];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
    {
        [device lockForConfiguration:nil];
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [device unlockForConfiguration];
    }
}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
    
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
                AVCaptureVideoOrientation newOrientation;
                switch ([[UIDevice currentDevice] orientation]) {
                    case UIDeviceOrientationPortrait:
                        newOrientation = AVCaptureVideoOrientationPortrait;
                        break;
                    case UIDeviceOrientationPortraitUpsideDown:
                        newOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                        break;
                    case UIDeviceOrientationLandscapeLeft:
                        newOrientation = AVCaptureVideoOrientationLandscapeRight;
                        break;
                    case UIDeviceOrientationLandscapeRight:
                        newOrientation = AVCaptureVideoOrientationLandscapeLeft;
                        break;
                    default:
                        newOrientation = AVCaptureVideoOrientationPortrait;
                }
                [videoConnection setVideoOrientation: newOrientation];
				break;
			}
		}
		if (videoConnection) {
            AVCaptureVideoOrientation newOrientation;
            switch ([[UIDevice currentDevice] orientation]) {
                case UIDeviceOrientationPortrait:
                    newOrientation = AVCaptureVideoOrientationPortrait;
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    newOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                    break;
                case UIDeviceOrientationLandscapeLeft:
                    newOrientation = AVCaptureVideoOrientationLandscapeRight;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    newOrientation = AVCaptureVideoOrientationLandscapeLeft;
                    break;
                default:
                    newOrientation = AVCaptureVideoOrientationPortrait;
            }
            [videoConnection setVideoOrientation: newOrientation];
            break;
        }
	}
    
	NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                 NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 NSLog(@"no attachments");
                                                             }
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                             [self setStillImage:image];
                                                             [self setStillImageData:imageData];
                                                             
                                                             if (self.delegate) [self.delegate cameraSessionManagerDidCaptureImage];
                                                                 
                                                         }];
}

- (void)dealloc {
    
	[[self captureSession] stopRunning];
    
	previewLayer = nil;
	captureSession = nil;
    stillImageOutput = nil;
    stillImage = nil;
}

- (void)setEnableTorch:(BOOL)enableTorch
{
    _enableTorch = enableTorch;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        if (enableTorch) { [device setTorchMode:AVCaptureTorchModeOn]; }
        else { [device setTorchMode:AVCaptureTorchModeOff]; }
        [device unlockForConfiguration];
    }
}

@end
