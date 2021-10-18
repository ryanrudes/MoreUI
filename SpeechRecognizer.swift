//
//  SpeechReader.swift
//  RangeSlider
//
//  Created by Ryan Rudes on 10/18/21.
//

import SwiftUI

struct SpeechRecognizer<Content: View>: View {
    let speechRecognizer = SpeechRecognitionEngine()
    
    @Binding var text: String
    @Binding var recording: Bool
    var content: () -> Content
    let onBeginRecording: () -> Void
    let onFinishRecording: () -> Void
    
    init(text: Binding<String>, recording: Binding<Bool>, content: @escaping () -> Content, onBeginRecording: @escaping () -> Void, onFinishRecording: @escaping () -> Void) {
        self._text = text
        self._recording = recording
        self.content = content
        self.onBeginRecording = onBeginRecording
        self.onFinishRecording = onFinishRecording
    }
    
    var body: some View {
        content()
            .onChange(of: recording) { _ in
                if recording {
                    speechRecognizer.record(to: $text)
                    onBeginRecording()
                } else {
                    speechRecognizer.stopRecording()
                    onFinishRecording()
                }
            }
            .onAppear {
                if recording {
                    speechRecognizer.record(to: $text)
                    onBeginRecording()
                }
            }
    }
}
