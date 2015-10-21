//
//  UIBuutton+Extension.swift
//  PhotoSelector
//
//  Created by Tsz on 15/10/20.
//  Copyright © 2015年 Tsz. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(imageName: String){
        self.init()
        setImage(imageName)
    }
    
    //使用图像名设置按钮的图像
    func setImage(imageName: String){
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName+"_highlighted"), forState: UIControlState.Highlighted)
    }
}
