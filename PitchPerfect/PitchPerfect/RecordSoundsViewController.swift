//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Tony Mackay on 16/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit
import AVFoundation;

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    func configureButtons(_ enabled: Bool) {
        stopRecordingButton.isEnabled = enabled
        recordButton.isEnabled = !enabled
        recordingLabel.text = recordButton.isEnabled ? "Tap to Record" : "Recording in Progress"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent("recordedVoice.wav")
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: [:])
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        if audioRecorder.isRecording == false {
            audioRecorder.record()
        }
        configureButtons(true)
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        if audioRecorder.isRecording == true {
            audioRecorder.stop()
        }
        configureButtons(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        print("audioRecorderDidFinishRecording: url: \(audioRecorder.url)")
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue called")
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
