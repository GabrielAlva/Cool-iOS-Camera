//
//  CameraViewController.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 4/16/14.
//  Copyright (c) 2014 Gabriel Alvarado. All rights reserved.
//

#import "CameraViewController.h"
#import <ImageIO/ImageIO.h>

@interface CameraViewController ()

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    
    [self setupCaptureManager];
    [self composeOverlayInterface];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];

	[[_captureManager captureSession] startRunning];
}

#pragma mark - Setup

-(void)setupCaptureManager {
    
    _captureManager = [CaptureSessionManager new];
    
    [_captureManager addVideoInputFrontCamera:NO];
    [_captureManager addStillImageOutput];
    [_captureManager addVideoPreviewLayer];
    
    CGRect layerRect = self.view.layer.bounds;
    [_captureManager.previewLayer setBounds:layerRect];
    [_captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    
    [self.view.layer addSublayer:_captureManager.previewLayer];
}

-(void)composeOverlayInterface {
    
    //Create programmatic shutter button
    UIButton *shutterButton; {
        
        //Button Visual attribution
        CGSize size                         = CGSizeMake(60, 60);
        shutterButton                       = [[UIButton alloc] initWithFrame:(CGRect){0,0, size}];
        shutterButton.center                = CGPointMake(self.view.center.x, self.view.center.y*1.75);
        shutterButton.backgroundColor       = [[UIColor redColor] colorWithAlphaComponent:.5];
        shutterButton.layer.cornerRadius    = size.height/2;
        shutterButton.clipsToBounds         = YES;
        
        //Button target
        [shutterButton addTarget:self action:@selector(shutterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shutterButton];
    }
}

- (void)shutterButtonPressed:(id)sender {
    
    // Animate shutter release
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)sender;
        [UIView animateWithDuration:.1 animations:^{
            self.view.alpha = 0;
            button.transform = CGAffineTransformMakeScale(1.25, 1.25);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                self.view.alpha = 1;
                button.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }

	[[self scanningLabel] setHidden:NO];
    [_captureManager captureStillImage];
     
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [[self scanningLabel] setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    _captureManager = nil;
    _scanningLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
