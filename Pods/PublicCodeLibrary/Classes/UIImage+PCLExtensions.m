//
//  UIImage+PCLExtensions.m
//  PublicCodeLibrary
//
//  Created by Stefan Herold on 9/12/11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "UIImage+PCLExtensions.h"

@implementation UIImage (PCLExtensions)

- (UIImage*)pcl_randomImageOfSize:(CGSize)aSize
{
	CGFloat nX = arc4random() % (NSUInteger)(self.size.width - aSize.width);
	CGFloat nY = arc4random() % (NSUInteger)(self.size.height - aSize.height);
	CGRect finalCropRect = CGRectMake(nX, nY, aSize.width, aSize.height);
	
	CGImageRef resultingImageRef = CGImageCreateWithImageInRect(self.CGImage, 
			finalCropRect);
	UIImage * resultingImage = [UIImage imageWithCGImage:resultingImageRef];
	CGImageRelease(resultingImageRef);
	return resultingImage;
}

@end
