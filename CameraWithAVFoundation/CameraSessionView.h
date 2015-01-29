//
//  CameraSessionView.h
//  CameraWithAVFoundation
//
//  Created by Christopher Cohen on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

///Protocol Definition
@protocol CameraManagerDelegate <NSObject>

@optional - (void)capturedImage:(UIImage *)image;
@optional - (void)capturedImageData:(NSData *)imageData;

@end

@interface CameraSessionView : UIView

//Delegate Property
@property (nonatomic, weak) id<CameraManagerDelegate>delegate;

//API Functions
- (void)setTopBarColor:(UIColor *)topBarColor;
- (void)hideFlashButton;
- (void)hideCameraToogleButton;
- (void)hideDismissButton;

@end
