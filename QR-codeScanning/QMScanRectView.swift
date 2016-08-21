//
//  QMScanRectView.swift
//  QR-codeScanning
//
//  Created by 黄启明 on 16/8/20.
//  Copyright © 2016年 huatengIOT. All rights reserved.
//

import UIKit

let screenW = UIScreen.mainScreen().bounds.size.width
let screenH = UIScreen.mainScreen().bounds.size.height

var w: CGFloat {
    get {
        let margin: CGFloat = 60
        return screenW - 2 * margin
    }
}
let h: CGFloat = w


class QMScanRectView: UIView {
    var scanRect: CGRect {
        get {
            return CGRectMake((screenW - w) * 0.5, (screenH - h) * 0.5, w, h)
        }
    }
    var scanRectView: UIView = UIView(frame: CGRectMake((screenW - w) * 0.5, (screenH - h) * 0.5, w, h))
    
    
    var scanImgView: UIImageView?
    
    //设置扫描图片frame 和图片下文字
    func setupScanImgUI() {
        
        let title = UILabel(frame: CGRectMake(0, (screenH - h) * 0.5 + h + 15, screenW, 20))
        title.text = "将二维码/条码放入框内, 即可自动扫描"
        title.font = UIFont.systemFontOfSize(14.0)
        title.textAlignment = .Center
        title.backgroundColor = UIColor.clearColor()
        title.textColor = UIColor.whiteColor()
        self.addSubview(title)
        
        scanImgView = UIImageView(image: UIImage(named: "scan_net"))
        self.addSubview(scanRectView)
        self.bringSubviewToFront(scanRectView)
        if let scanImgView = scanImgView {
            scanImgView.clipsToBounds = true
            scanImgView.layer.shadowOpacity = 1.0
            scanImgView.frame = CGRectMake(0, -h - 5, w, h)
            scanImgView.contentMode = .ScaleAspectFill
            self.addSubview(scanRectView)
            scanRectView.addSubview(scanImgView)
            scanRectView.clipsToBounds = true
        }
    }
    
    //添加扫描框动画
    func beginAnimation() {
        UIView.animateWithDuration(2.0, animations: {
            if let scanImgView = self.scanImgView {
                scanImgView.frame = CGRectMake(0, 5, w, h)
            }
            }) { (finished) in
                if let scanImgView = self.scanImgView {
                    scanImgView.frame = CGRectMake(0, -h - 5, w, h)
                    self.beginAnimation()
                }
        }
    }
    
    
    
    
    //绘制扫描框
    override func drawRect(rect: CGRect) {
        let originX: CGFloat = (rect.size.width - w) * 0.5
        let originY: CGFloat = (rect.size.height - h) * 0.5
        let cornerLineWidth: CGFloat = 15
        let cornerColor: UIColor = UIColor(red: 0/255.0, green: 153/255.0, blue: 204/255.0, alpha: 1.0)
        let frameColor: UIColor = UIColor.whiteColor()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(context, 60/255.0, 60/255.0, 60/255.0, 1)
        //设置透明度
        CGContextSetAlpha(context, 0.5)
    
        CGContextFillRect(context, rect)
        //frame path
        let framePath: UIBezierPath = UIBezierPath(rect: CGRectMake(originX, originY, w, h))
        CGContextAddPath(context, framePath.CGPath)
        CGContextSetStrokeColorWithColor(context, frameColor.CGColor)
        CGContextSetLineWidth(context, 0.6)
        CGContextStrokePath(context)
        //scan corner
        CGContextClearRect(context, CGRectMake(originX, originY, w, h))
        
        //left top corner
        let leftTopPath = UIBezierPath()
        leftTopPath.moveToPoint(CGPointMake(originX, originY + cornerLineWidth))
        leftTopPath.addLineToPoint(CGPointMake(originX, originY))
        leftTopPath.addLineToPoint(CGPointMake(originX + cornerLineWidth, originY))
        CGContextAddPath(context, leftTopPath.CGPath)
        CGContextSetStrokeColorWithColor(context, cornerColor.CGColor)
        CGContextSetLineWidth(context, 1.6)
        CGContextStrokePath(context)
        
        //right top corner
        let rightTopPath = UIBezierPath()
        rightTopPath.moveToPoint(CGPointMake(originX + w - cornerLineWidth, originY))
        rightTopPath.addLineToPoint(CGPointMake(originX + w, originY))
        rightTopPath.addLineToPoint(CGPointMake(originX + w, originY + cornerLineWidth))
        CGContextAddPath(context, rightTopPath.CGPath)
        CGContextSetStrokeColorWithColor(context, cornerColor.CGColor)
        CGContextSetLineWidth(context, 1.6)
        CGContextStrokePath(context)
        
        //left Bottom corner
        let leftBottomPath = UIBezierPath()
        leftBottomPath.moveToPoint(CGPointMake(originX, originY + h - cornerLineWidth))
        leftBottomPath.addLineToPoint(CGPointMake(originX, originY + h))
        leftBottomPath.addLineToPoint(CGPointMake(originX + cornerLineWidth, originY + h))
        CGContextAddPath(context, leftBottomPath.CGPath)
        CGContextSetStrokeColorWithColor(context, cornerColor.CGColor)
        CGContextSetLineWidth(context, 1.6)
        CGContextStrokePath(context)
        
        //right Bottom corner
        let rightBottomPath = UIBezierPath()
        rightBottomPath.moveToPoint(CGPointMake(originX + w - cornerLineWidth, originY + h))
        rightBottomPath.addLineToPoint(CGPointMake(originX + w, originY + h))
        rightBottomPath.addLineToPoint(CGPointMake(originX + w, originY + h - cornerLineWidth))
        CGContextAddPath(context, rightBottomPath.CGPath)
        CGContextSetStrokeColorWithColor(context, cornerColor.CGColor)
        CGContextSetLineWidth(context, 1.6)
        CGContextStrokePath(context)
        
//        //add text
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .Center
//        let attrs = [NSFontAttributeName: UIFont.systemFontOfSize(14.0),NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName: UIColor.whiteColor()]
//        let title = "将二维码/条码放入框内, 即可自动扫描"
//        
//        let titleSize = (title as NSString).sizeWithAttributes(attrs)
//        let titleRect = CGRectMake(0, originY + h + 15, rect.size.width, titleSize.height)
//        (title as NSString).drawInRect(titleRect, withAttributes: attrs)
    }
}
