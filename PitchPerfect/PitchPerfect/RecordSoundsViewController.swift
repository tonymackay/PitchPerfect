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
    
    // MARK: - Outlets

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: - Variables/Constants
    
    var audioRecorder: AVAudioRecorder!
    let segueIdentifier = "stopRecording"
    
    // MARK: - Lifecycle methods
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue called")
        if segue.identifier == segueIdentifier {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: - Actions

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
    
    // MARK: - Private methods
    
    func configureButtons(_ enabled: Bool) {
        stopRecordingButton.isEnabled = enabled
        recordButton.isEnabled = !enabled
        recordingLabel.text = recordButton.isEnabled ? "Tap to Record" : "Recording in Progress"
    }
    
    // MARK: - Delegate methods
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        print("audioRecorderDidFinishRecording: url: \(audioRecorder.url)")
        if flag {
            performSegue(withIdentifier: segueIdentifier, sender: audioRecorder.url)
        } else {
            print("recording failed")
        }
    }
}
