//
//  UIImage+Extensions.swift
//  Core
//
//  Created by Stefan Herold on 10.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public extension UIImage {

    convenience init(withSolidColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}
