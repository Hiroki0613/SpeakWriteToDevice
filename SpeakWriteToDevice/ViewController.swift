//
//  ViewController.swift
//  SpeakWriteToDevice
//
//  Created by 近藤宏輝 on 2020/02/09.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognitionTaskDelegate {
    
    // MARK: 音声入力、音声認識Properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = false
//        speechRecognizer.delegate = self
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
    
    private func startRecording() throws {
        //録音スタート処理を記述
        if let recognitionTask = recognitionTask {
            //既存タスクがあればキャンセルしてリセット
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        try audioSession.setMode(AVAudioSession.Mode.measurement)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else { fatalError("リクエスト生成エラー")}
        
        recognitionRequest.shouldReportPartialResults = true
        
//        guard let inputNode = audioEngine.inputNode else { fatalError("InputNodeエラー")}
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
                self.recordButton.backgroundColor = .systemBlue
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        textView.text = "(認識中...そのまま話し続けてください)"
    }
    
    
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //利用可能になたら、録音ボタンを有効にする
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
            recordButton.backgroundColor = .systemBlue
            
        } else {
            //利用できないなら、録音ボタンは無効にする
            recordButton.isEnabled = false
            recordButton.setTitle("現在、使用不可", for: .disabled)
        }
       }
    

    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if audioEngine.isRunning {
            //音声エンジン動作中なら停止
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
            recordButton.backgroundColor = .systemGray
            return
        }
        //録音を開始する
        try! startRecording()
        recordButton.setTitle("認識を完了する", for: [])
        recordButton.backgroundColor = .systemRed
    }
    
}

/*
 参考にしたサイト
 【Speech Framework】音声認識してテキストを入力する
 https://qiita.com/chino_tweet/items/027c432cfb983f95679a
 
 音声認識(SFSpeechRecognizer)
 https://swiswiswift.com/2017-05-13/
 
 【Speech Framework】【Swift4】音声認識してテキストを入力
 inputNodeのエラーについて調査
 https://teratail.com/questions/197061
 */

