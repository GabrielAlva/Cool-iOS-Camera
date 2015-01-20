//
//  CameraViewController.h
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 4/16/14.
//  Copyright (c) 2014 Gabriel Alvarado. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface CameraViewController : UIViewController

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;

@end
