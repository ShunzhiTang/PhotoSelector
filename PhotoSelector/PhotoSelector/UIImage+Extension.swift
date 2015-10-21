//
//  UIImage+Extension.swift
//  PhotoSelector

import UIKit

extension UIImage {
    
    //按比例进行缩放
    func scaleImage(width: CGFloat) ->UIImage{
        if size.width  < width {
            return self
        }
        
    //计算目标的尺寸
        let height = size.height * width / size.width
        let s = CGSize(width: height, height: height)
        
        //使用图像上下文进行重绘
        
        //1、开启上下文
        UIGraphicsBeginImageContext(s)
        
        //2、绘图
        drawInRect(CGRect(origin: CGPointZero, size: s))
        
        //3、从当前上下文拿到结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext()
        
        //返回结果
        return result
    }
}
