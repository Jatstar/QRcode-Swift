//
//  QRViewController.swift
//  QRcode-Swift
//
//  Created by 张建宇 on 16/8/2.
//  Copyright © 2016年 张建宇. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController {
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startScan()
        // Do any additional setup after loading the view.
    }

    private func startScan(){
        
        if !session.canAddInput(deviceInput) {
            print("无法添加录入设备")
            return
        }
        
        if !session.canAddOutput(metadataOutput) {
            print("无法添加输出对象")
            return
        }
        
        session.addInput(deviceInput)
        session.addOutput(metadataOutput)
        
        metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        session.startRunning()
    }
    
    
    
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 录入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            return try AVCaptureDeviceInput(device: device)
        }catch{
            // 没有摄像头 如:模拟器
            print("未找到录入设备\(error)")
            return nil
        }
    }()
    
    // 预览
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer.init(session: self.session)
        preview.frame = self.view.frame
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        return preview
    }()
    
    // 输出
    private lazy var metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
}

extension QRViewController:AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print(metadataObjects.last);
    }
}
