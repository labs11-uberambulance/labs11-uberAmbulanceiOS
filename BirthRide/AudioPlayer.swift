//
//  AudioPlayer.swift
//  BirthRide
//
//  Created by Austin Cole on 4/25/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import AVFoundation

protocol AuidoPlayerDelegate: AnyObject, AVAudioPlayerDelegate {
    func playerDidChangeState(_ player: AudioPlayer)
}
//Will be delegate of audio recorder, so needs to be `NSObject`
///Delegate of the audio recorder
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    var totalTime: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    var remainingTime: TimeInterval {
        return totalTime - elapsedTime
    }
    
    
    weak var delegate: AuidoPlayerDelegate?
    
    ///Indicates whether or not the audioPlayer is currently playing
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    ///Returns the current time within the song
    var elapsedTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    var file: URL?
    ///If the audio player is playing, it will pause. If it is paused, it will play.
    func playPause(url: URL? = nil) {
        if isPlaying {
            pause()
        }
        else {
            play(url: url)
        }
    }
    //MARK: Private Methods
    ///Instructs the audioPlayer to play. If the audioPlayer is equal to nil, audioPlayer will be given a new value and will play.
    func play(url: URL? = nil) {
        file = url ?? Bundle.main.url(forResource: "TKO", withExtension: "mp3")
        
        if audioPlayer == nil || audioPlayer?.url != file {
            //Make a new audioplayer if audioplayer is nil
            
            audioPlayer = try! AVAudioPlayer(contentsOf: file!)
            audioPlayer?.delegate = self
            
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.notifyDelegate()
        }
        audioPlayer?.play()
        notifyDelegate()
    }
    ///Instructs the audioPlayer to pause.
    private func pause() {
        audioPlayer?.pause()
        notifyDelegate()
    }
    ///Notify the delegate when the audio player changes state
    private func notifyDelegate() {
        delegate?.playerDidChangeState(self)
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}
