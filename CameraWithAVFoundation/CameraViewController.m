//
//  CameraViewController.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 4/16/14.
//  Copyright (c) 2014 Gabriel Alvarado. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraSessionView.h"

@interface CameraViewController () <CACameraSessionDelegate>

@end

@implementation CameraViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Set white status bar
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Instantiate the camera view
    CameraSessionView *cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    
    //Example Customization
    //[cameraView setTopBarColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha: 0.64]];
    //[cameraView hideFlashButton];
    //[cameraView hideCameraToogleButton];
    //[cameraView hideDismissButton];
    
    [self.view insertSubview:cameraView atIndex:0];
}

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE");
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
