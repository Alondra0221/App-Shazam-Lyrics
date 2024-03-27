//
//  ShazamViewModel.swift
//  ShazamLyrics
//
//  Created by Alondra García Morales on 26/03/24.
//

import Foundation
import ShazamKit
import SwiftUI

class ShazamViewModel : NSObject, ObservableObject{
    @Published var shazamModel = ShazamModels(title: "", artist: "", album: URL(string: "https://google.com"))
    @Published var recording = false
    
    
    private var audioEngine = AVAudioEngine()
    private var session = SHSession()
    private var signatureGenerator = SHSignatureGenerator()
    
    override init(){
        super.init()
        session.delegate = self
    }
    
    func startListening(){
        guard !audioEngine.isRunning else{
            audioEngine.stop()
            DispatchQueue.main.async{
                self.recording = true
            }
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { granted in
            guard granted else { return }
            
            try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = self.audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            inputNode.removeTap(onBus: 0)
            
            inputNode.installTap(onBus: .zero , bufferSize: 1024, format: recordingFormat){ (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.session.matchStreamingBuffer(buffer, at: nil)
            }// la parte que graba el microfono
            
            self.audioEngine.prepare()
            do{
                try self.audioEngine.start()
                
            }catch let error as NSError{
                print("Error al escanear", error.localizedDescription)
            }
            
            DispatchQueue.main.async{
                self.recording = true
            }
        }
    }
    
    func stopListening(){
        if audioEngine.isRunning{
            audioEngine.stop()
            DispatchQueue.main.async {
                self.recording = false
            }
        }
    }
}

extension ShazamViewModel : SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {
        let mediaItems = match.mediaItems
        if let item = mediaItems.first{
            DispatchQueue.main.async{
                self.shazamModel = ShazamModels(title: item.title, artist: item.artist, album: item.artworkURL)
                if ((self.shazamModel.album?.isFileURL) != nil){
                    self.stopListening()
                }
            }
        } //dame el primer resultado que sea compatible
    }
}
