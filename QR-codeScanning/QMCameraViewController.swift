//
//  QMCameraViewController.swift
//  QR-codeScanning
//
//  Created by 黄启明 on 16/8/19.
//  Copyright © 2016年 huatengIOT. All rights reserved.
//

import UIKit
import AVFoundation

protocol MessageEnabled {
    func returnMessage(textString: String)
}
protocol backEnabled {
    func backToFront()
}

class QMCameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var scanView: QMScanRectView?

    var delegate: MessageEnabled?
    var backDelegate: backEnabled?
    
    //二维码的读取完全是基于视频捕获的，为了实时捕获视频，我们只需要以合适的AVCaptureDevice对象作为输入参数去实例化一个AVCaptureSession对象
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scanView = QMScanRectView()
        scanView?.frame = view.bounds
        scanView?.backgroundColor = UIColor.clearColor()
        
        scanView?.setupScanImgUI()
        view.addSubview(scanView!)
        scanView?.beginAnimation()
        
        //获取摄像设备 并设置参数AVMediaTypeVideo
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var inputError: NSError?
        var input:AVCaptureDeviceInput!
        
        do{
            input = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch let error as NSError{
            inputError = error
            print(inputError)
        }
        //实例化AVCaptureSession对象 AVCaptureSession会话是用来管理视频数据流从输入设备传送到输出端的会话过程 初始化AVCaptureSession来协调和处理AV的输入和输出流
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as AVCaptureInput)
        
        //这个会话的输出端被设定为一个AVCaptureMetaDataOutput对象，而这个AVCaptureMetaDataOutput类是二维码读取的核心组成部分，它和AVCaptureMetadataOutputObjectsDelegate协议一起，将被用来获取从输入设备传过来的元数据（就是摄像头捕获的二维码）然后将它们翻译为人类可读的格式
        let captureMetadataOutput = AVCaptureMetadataOutput()
        //限制扫描区域
        captureMetadataOutput.rectOfInterest = CGRectMake((scanView?.scanRect.origin.y)!/screenH, (scanView?.scanRect.origin.x)!/screenW, (scanView?.scanRect.size.height)!/screenH, (scanView?.scanRect.size.width)!/screenW)
        captureSession?.addOutput(captureMetadataOutput as AVCaptureOutput)
        //设置代理
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        let types = [AVMetadataObjectTypeQRCode,
                     AVMetadataObjectTypeFace,
                     AVMetadataObjectTypeEAN8Code,
                     AVMetadataObjectTypeUPCECode,
                     AVMetadataObjectTypeAztecCode,
                     AVMetadataObjectTypeEAN13Code,
                     AVMetadataObjectTypeITF14Code,
                     AVMetadataObjectTypeCode39Code,
                     AVMetadataObjectTypeCode93Code,
                     AVMetadataObjectTypePDF417Code,
                     AVMetadataObjectTypeCode128Code,
                     AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeCode39Mod43Code]
        captureMetadataOutput.metadataObjectTypes = types
        //还需要在屏幕上显示摄像头捕获到的图像，这可以通过AVCaptureVideoPreviewLayer（其实就是一个CALayer）来完成。然后使用这个预览图层和图像信息捕获会话来显示视频，这个预览图层要作为当前视图的子图层添加进去
        if let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession){
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
        //调用视频捕获 startRunning 方法来启动
        captureSession?.startRunning()
        
        view.bringSubviewToFront(scanView!)
        //设置返回按钮
        setBackButton()
        
    }
    
    func playSound(){
        let path = NSBundle.mainBundle().pathForResource("qrcode_found", ofType: "wav")
        if let path = path{
            let soundURL = NSURL(fileURLWithPath: path)
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &soundID)
            AudioServicesPlayAlertSound(soundID)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0{
            return
        }
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                guard metadataObj.stringValue != nil else{
                    return
                }
                playSound()
                
                if let delegate = delegate{
                    delegate.returnMessage(metadataObj.stringValue)
                }
                
                captureSession?.stopRunning()
                navigationController?.popViewControllerAnimated(true)
                
            }
        }
    }
    
    func setBackButton() {
        
        navigationController?.navigationBar.hidden = true
        
        let backBtn = UIButton()
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)
        backBtn.setImage(UIImage(named: "back"), forState: .Normal)
        view.addSubview(backBtn)
        view.bringSubviewToFront(backBtn)
        
        let constraint1 = NSLayoutConstraint(item: backBtn, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 20)
        let constraint2 = NSLayoutConstraint(item: backBtn, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 15)
        let constraint3 = NSLayoutConstraint(item: backBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50)
        let constraint4 = NSLayoutConstraint(item: backBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50)
        view.addConstraints([constraint1,constraint2,constraint3,constraint4])
        
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
        backDelegate?.backToFront()
    }
}
