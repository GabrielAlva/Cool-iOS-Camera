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

@interface CameraSessionView ()
{
    CameraShutterButton *cameraShutter;
    CameraFlashButton *cameraFlash;
    CameraToggleButton *cameraToggle;
    CameraDismissButton *cameraDismiss;
    CameraTopBarView *topBarView;
}

@property (nonatomic, strong) CaptureSessionManager *captureManager;

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
    CaptureSessionManager *captureManager; {
        
        //Alloc/Init
        captureManager = [CaptureSessionManager new];
        
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
    CGSize shutterSize                             = CGSizeMake(70, 70);
    cameraShutter = [[CameraShutterButton alloc] initWithFrame:(CGRect){0,0, shutterSize}]; {
        
        //Button Visual attribution
        cameraShutter.center                = CGPointMake(self.center.x, self.center.y*1.75);
        cameraShutter.backgroundColor       = [UIColor clearColor];
        
        //Button target
        [cameraShutter addTarget:self action:@selector(shutterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cameraShutter];
    }
    
    //Create the top bar and add the buttons to it
    CGSize topBarSize                            = CGSizeMake(self.frame.size.width, 45);
    topBarView = [[CameraTopBarView alloc] initWithFrame:(CGRect){0,0, topBarSize}]; {
        topBarView.backgroundColor       = [UIColor clearColor];
        [self addSubview:topBarView];
        
        //Add the flash button
        CGSize flashButtonSize                             = CGSizeMake(27, 27);
        cameraFlash = [[CameraFlashButton alloc] initWithFrame:(CGRect){0,0, flashButtonSize}]; {
            
            //Button Visual attribution
            cameraFlash.center                = CGPointMake(topBarView.center.x * 0.80, topBarView.center.y);
            cameraFlash.backgroundColor       = [UIColor clearColor];
            
            //Button target
            [cameraFlash addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [topBarView addSubview:cameraFlash];
        }
        
        //Add the camera toggle button
        CGSize toggleButtonSize                             = CGSizeMake(27, 27);
        cameraToggle = [[CameraToggleButton alloc] initWithFrame:(CGRect){0,0, toggleButtonSize}]; {
            
            //Button Visual attribution
            cameraToggle.center                = CGPointMake(topBarView.center.x * 1.20, topBarView.center.y);
            cameraToggle.backgroundColor       = [UIColor clearColor];
            
            //Button target
            [cameraToggle addTarget:self action:@selector(toggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [topBarView addSubview:cameraToggle];
        }
        
        //Add the camera dismiss button
        CGSize dismissButtonSize                             = CGSizeMake(27, 27);
        cameraDismiss = [[CameraDismissButton alloc] initWithFrame:(CGRect){0,0, dismissButtonSize}]; {
            
            //Button Visual attribution
            cameraDismiss.center                = CGPointMake(20, topBarView.center.y);
            cameraDismiss.backgroundColor       = [UIColor clearColor];
            
            //Button target
            [cameraDismiss addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [topBarView addSubview:cameraDismiss];
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
