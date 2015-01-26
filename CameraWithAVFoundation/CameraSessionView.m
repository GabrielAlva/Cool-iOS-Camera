//
//  CameraSessionView.m
//  CameraWithAVFoundation
//
//  Created by Christopher Cohen on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraSessionView.h"
#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>
//Custom UI classes
#import "CameraShutterButton.h"
#import "CameraToggleButton.h"
#import "CameraFlashButton.h"
#import "CameraDismissButton.h"
#import "CameraTopBarView.h"
#import "CameraFocusIndicator.h"
#import "Constants.h"

@interface CameraSessionView ()

//Primative Properties
@property (readwrite) BOOL animationInProgress;

//Object References
@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, strong) CameraShutterButton   *cameraShutter;
@property (nonatomic, strong) CameraToggleButton    *cameraToggle;
@property (nonatomic, strong) CameraFlashButton     *cameraFlash;
@property (nonatomic, strong) CameraDismissButton   *cameraDismiss;
@property (nonatomic, strong) CameraTopBarView      *topBarView;
@property (nonatomic, strong) CameraFocusIndicator  *focusIndicator;

@end

@implementation CameraSessionView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animationInProgress = NO;
        [self setupCaptureManager];
        [self composeInterface];
        
#warning replace with delegate implementation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
        
        [[_captureManager captureSession] startRunning];
    }
    return self;
}

#pragma mark - Setup

-(void)setupCaptureManager {
    
    //Create and configure 'CaptureSessionManager' object
    CaptureSessionManager *captureManager = [CaptureSessionManager new]; {
        
        //Configure
        [captureManager addVideoInputFrontCamera:NO];
        [captureManager addStillImageOutput];
        [captureManager addVideoPreviewLayer];
        
        //Preview Layer setup
        CGRect layerRect = self.layer.bounds;
        [captureManager.previewLayer setBounds:layerRect];
        [captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
        
        //Add to self.view's layer
        [self.layer addSublayer:captureManager.previewLayer];
        
        //Retain strong reference to object
        _captureManager = captureManager;
    }
}

-(void)composeInterface {
    
    //Create shutter button
    _cameraShutter = [CameraShutterButton new]; {
        
        //Button Visual attribution
        _cameraShutter.frame            = (CGRect){0,0, IPHONE_SHUTTER_BUTTON_SIZE};
        _cameraShutter.center           = CGPointMake(self.center.x, self.center.y*1.75);
        _cameraShutter.tag              = ShutterButtonTag;
        _cameraShutter.backgroundColor  = [UIColor clearColor];
        
        //Button target
        [_cameraShutter addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraShutter];
    }
    
    //Create the top bar and add the buttons to it
    _topBarView = [CameraTopBarView new]; {
        
        //Setup visual attribution for bar
        _topBarView.frame               = (CGRect){0,0, IPHONE_OVERLAY_BAR_SIZE};
        _topBarView.backgroundColor     = [UIColor clearColor];
        [self addSubview:_topBarView];
        
        //Add the flash button
        _cameraFlash = [CameraFlashButton new]; {
            _cameraFlash.frame  = (CGRect){0,0, IPHONE_OVERLAY_BAR_BUTTON_SIZE};
            _cameraFlash.center = CGPointMake(_topBarView.center.x * 0.80, _topBarView.center.y);
            _cameraFlash.tag    = FlashButtonTag;
            [_topBarView addSubview:_cameraFlash];
        }
        
        //Add the camera toggle button
        _cameraToggle = [CameraToggleButton new]; {
            _cameraToggle.frame     = (CGRect){0,0, IPHONE_OVERLAY_BAR_BUTTON_SIZE};
            _cameraToggle.center    = CGPointMake(_topBarView.center.x * 1.20, _topBarView.center.y);
            _cameraToggle.tag       = ToggleButtonTag;
            [_topBarView addSubview:_cameraToggle];
        }
        
        //Add the camera dismiss button
        _cameraDismiss = [CameraDismissButton new]; {
            _cameraDismiss.frame    = (CGRect){0,0, IPHONE_OVERLAY_BAR_BUTTON_SIZE};
            _cameraDismiss.center   = CGPointMake(20, _topBarView.center.y);
            _cameraDismiss.tag      = DismissButtonTag;
            [_topBarView addSubview:_cameraDismiss];
        }
        
        //Attribute and configure all buttons in the bar's subview
        for (UIButton *button in _topBarView.subviews) {
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //Create the focus indicator UIView
    _focusIndicator = [CameraFocusIndicator new]; {
    
        //Setup the attributes for the focus view
        _focusIndicator.frame               = (CGRect){0,0, 60, 60};
        _focusIndicator.backgroundColor     = [UIColor clearColor];
        _focusIndicator.hidden              = YES;
        [self addSubview:_focusIndicator];
    }
    
    //Create the gesture recognizer for the focus tap
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];{
        [self addGestureRecognizer:singleTapGestureRecognizer];
    }
    

}

#pragma mark - User Interaction

-(void)inputManager:(id)sender {
    
    //If animation is in progress, ignore input
    if (_animationInProgress) return;
    
    //If sender does not inherit from 'UIButton', return
    if (![sender isKindOfClass:[UIButton class]]) return;
    
    //Input manager switch
    switch ([(UIButton *)sender tag]) {
        case ShutterButtonTag:  [self onTapShutterButton];  return;
        case ToggleButtonTag:   [self onTapToggleButton];   return;
        case FlashButtonTag:    [self onTapFlashButton];    return;
        case DismissButtonTag:  [self onTapDismissButton];  return;
    }
}

- (void)onTapShutterButton {
    
    //Animate shutter release
    [self animateShutterRelease];
    
    //Capture image from camera
    [_captureManager captureStillImage];
}

- (void)onTapFlashButton {
    BOOL enable = !self.captureManager.isTorchEnabled;
    self.captureManager.enableTorch = enable;
}

- (void)onTapToggleButton {
}

- (void)onTapDismissButton {
    [self removeFromSuperview];
}

- (void)focusGesture:(id)sender {
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = sender;
        if (tap.state == UIGestureRecognizerStateRecognized) {
            CGPoint location = [sender locationInView:self];
            
            [self focusAtPoint:location completionHandler:^{
                 [self animateFocusIndicatorToPoint:location];
             }];
        }
    }
}

#pragma mark - Animation

- (void)animateShutterRelease {
    
    _animationInProgress = YES; //Disables input manager
    
    [UIView animateWithDuration:.1 animations:^{
        self.alpha = 0;
        _cameraShutter.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            self.alpha = 1;
            _cameraShutter.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            _animationInProgress = NO; //Enables input manager
        }];
    }];
}

- (void)animateFocusIndicatorToPoint:(CGPoint)targetPoint
{
    _animationInProgress = YES; //Disables input manager
    
    [self.focusIndicator setCenter:targetPoint];
    self.focusIndicator.alpha = 0.0;
    self.focusIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
         self.focusIndicator.alpha = 1.0;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:0.4 animations:^{
              self.focusIndicator.alpha = 0.0;
          }completion:^(BOOL finished) {
              
              _animationInProgress = NO; //Enables input manager
          }];
     }];
}

#pragma mark - Helper Methods

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
    CGPoint pointOfInterest = CGPointZero;
    CGSize frameSize = self.bounds.size;
    pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        //Lock camera for configuration if possible
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                [device setFocusPointOfInterest:pointOfInterest];
            }
            
            if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [device setExposurePointOfInterest:pointOfInterest];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device unlockForConfiguration];
            
            completionHandler();
        }
    }
    else { completionHandler(); }
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
