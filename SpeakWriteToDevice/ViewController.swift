//
//  ViewController.swift
//  SpeakWriteToDevice
//
//  Created by 近藤宏輝 on 2020/02/09.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    
    private let speechRecoginizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    privatevar recognitionTask = SFSpeechRecognitionTask?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    //許可
                    self.recordButton.isEnabled       = true
                    self.recordButton.backgroundColor = UIColor.systemBlue
                case .denied:
                    //拒否
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("録音許可無し", for: .disabled)
                case .restricted:
                    //限定
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("このデバイスでは無効", for: .disabled)
                case .notDetermined:
                    //不明
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("録音機能が無効", for: .disabled)
                }
                
            }
        }
    }

    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    
}

/*
 参考にしたサイト
 【Speech Framework】音声認識してテキストを入力する
 https://qiita.com/chino_tweet/items/027c432cfb983f95679a
 */

