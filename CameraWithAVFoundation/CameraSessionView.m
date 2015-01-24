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
#import "Constants.h"

@interface CameraSessionView ()

@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, strong) CameraShutterButton   *cameraShutter;
@property (nonatomic, strong) CameraToggleButton    *cameraToggle;
@property (nonatomic, strong) CameraFlashButton     *cameraFlash;
@property (nonatomic, strong) CameraDismissButton   *cameraDismiss;
@property (nonatomic, strong) CameraTopBarView      *topBarView;

@end

@implementation CameraSessionView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
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
    
    //Create programmatic shutter button
    _cameraShutter = [CameraShutterButton new]; {
        
        //Button Visual attribution
        _cameraShutter.frame            = (CGRect){0,0, IPHONE_SHUTTER_BUTTON_SIZE};
        _cameraShutter.center           = CGPointMake(self.center.x, self.center.y*1.75);
        _cameraShutter.backgroundColor  = [UIColor clearColor];
        
        //Button target
        [_cameraShutter addTarget:self action:@selector(shutterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraShutter];
    }
    
    //Create the top bar and add the buttons to it
    _topBarView = [CameraTopBarView new]; {
        
        //Setup visual attribution
        _topBarView.frame               = (CGRect){0,0, IPHONE_OVERLAY_BAR_SIZE};
        _topBarView.backgroundColor     = [UIColor clearColor];
        [self addSubview:_topBarView];
        
        //Add the flash button
        _cameraFlash = [CameraFlashButton new]; {
            
            //Button Visual attribution
            _cameraFlash.frame              = (CGRect){0,0, IPHONE_OVERLAY_BAR_BUTTON_SIZE};
            _cameraFlash.center             = CGPointMake(_topBarView.center.x * 0.80, _topBarView.center.y);
            _cameraFlash.backgroundColor    = [UIColor clearColor];
            
            //Button target
            [_cameraFlash addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_topBarView addSubview:_cameraFlash];
        }
        
        //Add the camera toggle button
        _cameraToggle = [CameraToggleButton new]; {
            
            //Button Visual attribution
            _cameraToggle.frame             = (CGRect){0,0, IPHONE_OVERLAY_BAR_BUTTON_SIZE};
            _cameraToggle.center            = CGPointMake(_topBarView.center.x * 1.20, _topBarView.center.y);
            _cameraToggle.backgroundColor   = [UIColor clearColor];
            
            //Button target
            [_cameraToggle addTarget:self action:@selector(toggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_topBarView addSubview:_cameraToggle];
        }
        
        //Add the camera dismiss button
        _cameraDismiss = [CameraDismissButton new]; {
            
            //Button Visual attribution
            _cameraDismiss.frame            = (CGRect){0,0, IPHONE_OVERLAY_BAR_BUTTON_SIZE};
            _cameraDismiss.center           = CGPointMake(20, _topBarView.center.y);
            _cameraDismiss.backgroundColor  = [UIColor clearColor];
            
            //Button target
            [_cameraDismiss addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_topBarView addSubview:_cameraDismiss];
        }
    }
}

- (void)shutterButtonPressed:(id)sender {
    
    //If sender is not a UIButton object, return
    if (![sender isKindOfClass:[UIButton class]]) return;
    
    //Animate shutter release
    [self animateShutterRelease:(UIButton *)sender];
    
    //Capture image from camera
    [_captureManager captureStillImage];
}

- (void)flashButtonPressed:(id)sender {
    BOOL enable = !self.captureManager.isTorchEnabled;
    self.captureManager.enableTorch = enable;
}

- (void)toggleButtonPressed:(id)sender {
}

- (void)dismissButtonPressed:(id)sender {
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

#pragma mark - Animation

- (void)animateShutterRelease:(UIButton *)shutterButton {
    
    [UIView animateWithDuration:.1 animations:^{
        self.alpha = 0;
        shutterButton.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            self.alpha = 1;
            shutterButton.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
