//
//  QMCameraViewController.swift
//  QR-codeScanning
//
//  Created by 黄启明 on 16/8/19.
//  Copyright © 2016年 huatengIOT. All rights reserved.
//

import UIKit
import AVFoundation

class QMCameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    //二维码的读取完全是基于视频捕获的，为了实时捕获视频，我们只需要以合适的AVCaptureDevice对象作为输入参数去实例化一个AVCaptureSession对象
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        captureSession?.addOutput(captureMetadataOutput as AVCaptureOutput)
        //设置代理
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        //还需要在屏幕上显示摄像头捕获到的图像，这可以通过AVCaptureVideoPreviewLayer（其实就是一个CALayer）来完成。然后使用这个预览图层和图像信息捕获会话来显示视频，这个预览图层要作为当前视图的子图层添加进去
        if let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession){
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
        //调用视频捕获回话的startRunning方法来启动
        captureSession?.startRunning()
        view.bringSubviewToFront(messageLabel)
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
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
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "未发现二维码"
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            //            let codeObj = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj) as! AVMetadataMachineReadableCodeObject
            //            qrCodeFrameView?.frame = codeObj.bounds
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                messageLabel.sizeToFit()
            }
            playSound()
            captureSession?.stopRunning()
            navigationController?.popViewControllerAnimated(true)
        }
    }

}
