//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Ryan Rudes on 10/11/21.
//

import SwiftUI

struct RangeSlider<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    @Binding var lo: V
    @Binding var hi: V
    var bounds: ClosedRange<V>
    var onEditingChanged: (Bool) -> Void
    
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
    }
    
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
    }
    
    /// TODO
    /*
    init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        
    }
    
    init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        
    }
    
    init<V>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, label: () -> Label, minimumValueLabel: () -> ValueLabel, maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        
    }
    
    init<V>(value: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, label: () -> Label, minimumValueLabel: () -> ValueLabel, maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
        
    }
    */
    
    var body: some View {
        let upper = bounds.upperBound
        let lower = bounds.lowerBound
        let range = upper - lower
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(uiColor: .systemFill))
                    .frame(width: geometry.size.width, height: 4)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(.blue)
                    .frame(width: geometry.size.width * CGFloat((hi - lo) / range), height: 4)
                    .offset(x: geometry.size.width * CGFloat((lo - lower) / range))
                
                Circle()
                    .fill(.white)
                    .shadow(radius: 1.5, y: 0.75)
                    .frame(width: 28)
                    .offset(x: geometry.size.width * CGFloat((lo - lower) / range) - 14)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                lo = max(min(V(gesture.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound, hi), bounds.lowerBound)
                                self.onEditingChanged(true)
                            }
                            .onEnded { _ in
                                self.onEditingChanged(false)
                            }
                    )
                
                Circle()
                    .fill(.white)
                    .shadow(radius: 1.5, y: 0.75)
                    .frame(width: 28)
                    .offset(x: geometry.size.width * CGFloat((hi - lower) / range) - 14)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                hi = min(max(V(gesture.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound, lo), bounds.upperBound)
                                self.onEditingChanged(true)
                            }
                            .onEnded { _ in
                                self.onEditingChanged(false)
                            }
                    )
            }
        }
        .padding(.horizontal, 1)
        .frame(maxHeight: 28)
    }
}
