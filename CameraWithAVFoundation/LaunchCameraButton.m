//
//  LaunchCameraButton.m
//  CameraWithAVFoundation
//
//  Created by Gabriel Alvarado on 2/18/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "LaunchCameraButton.h"

@implementation LaunchCameraButton

- (void)drawRect:(CGRect)frame {
    // Drawing code
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.225 green: 0.225 blue: 0.225 alpha: 1];
    UIColor* color0 = [UIColor colorWithRed: 0.521 green: 0.521 blue: 0.521 alpha: 1];
    UIColor* color1 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Page-1
    {
        //// Artboard-1
        {
            //// Rectangle-1-+-Launch-Camera 2
            {
                //// Rectangle-1 Drawing
                UIBezierPath* rectangle1Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 9, CGRectGetMinY(frame) + 9.97, 228, 71) cornerRadius: 8];
                [color1 setFill];
                [rectangle1Path fill];
                [color0 setStroke];
                rectangle1Path.lineWidth = 3;
                [rectangle1Path stroke];
                
                
                //// Rectangle 2 Drawing
                CGRect rectangle2Rect = CGRectMake(CGRectGetMinX(frame) + 54, CGRectGetMinY(frame) + 31.69, 260, 40);
                NSMutableParagraphStyle* rectangle2Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                rectangle2Style.alignment = NSTextAlignmentLeft;
                
                NSDictionary* rectangle2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size: 20], NSForegroundColorAttributeName: color2, NSParagraphStyleAttributeName: rectangle2Style};
                
                [@"Launch Camera" drawInRect: rectangle2Rect withAttributes: rectangle2FontAttributes];
            }
        }
    }
}

@end
