//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sanath Kumar Kruthiventi on 5/17/16.
//  Copyright © 2016 Sanath Kumar Kruthiventi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var lblOutletStatus: UILabel!
    @IBOutlet weak var btnOutletStopRec: UIButton!
    @IBOutlet weak var btnOutletRec: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    

    @IBAction func btnRecord(sender: AnyObject) {
        updateUIisRecording(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func btnActionStopRec(sender: AnyObject) {
        updateUIisRecording(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    override func viewWillAppear(animated: Bool) {
    btnOutletStopRec.enabled=false
        lblOutletStatus.text="Tap to start recording"
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if (flag) {
        performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
            updateUIisRecording(false)
            //PlaySoundsViewController.showAlert("")
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="stopRecording") {
        let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recorderAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL=recorderAudioURL
        }
    }

    func updateUIisRecording(isRecording: Bool) {
        if (isRecording) {
           lblOutletStatus.text = "Recording in progress"
            btnOutletRec.enabled = false
            btnOutletStopRec.enabled = true
        } else {
            lblOutletStatus.text = "Recording done"
            btnOutletRec.enabled = true
            btnOutletStopRec.enabled = false
        }
    }
}

