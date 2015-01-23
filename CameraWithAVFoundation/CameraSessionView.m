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

@interface CameraSessionView ()

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
    UIButton *shutterButton; {
        
        //Button Visual attribution
        CGSize size                         = CGSizeMake(60, 60);
        shutterButton                       = [[UIButton alloc] initWithFrame:(CGRect){0,0, size}];
        shutterButton.center                = CGPointMake(self.center.x, self.center.y*1.75);
        shutterButton.backgroundColor       = [[UIColor whiteColor] colorWithAlphaComponent:.75];
        shutterButton.layer.cornerRadius    = size.height/2;
        shutterButton.layer.borderWidth     = 2;
        shutterButton.layer.borderColor     = [UIColor whiteColor].CGColor;
        shutterButton.clipsToBounds         = YES;
        
        //Button target
        [shutterButton addTarget:self action:@selector(shutterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shutterButton];
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
