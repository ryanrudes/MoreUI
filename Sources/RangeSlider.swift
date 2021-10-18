//
//  RangeSlider.swift
//  swiftui-more
//
//  Created by Ryan Rudes on 10/11/21.
//

import SwiftUI

struct RangeSlider<V, Label, ValueLabel>: View where V: BinaryFloatingPoint, V.Stride : BinaryFloatingPoint, Label : View, ValueLabel : View {
    @Binding var lo: V
    @Binding var hi: V
    let bounds: ClosedRange<V>
    let minimumValueLabel: ValueLabel
    let maximumValueLabel: ValueLabel
    let label: Label
    let onEditingChanged: (Bool) -> Void
    
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
        self.label = EmptyView() as! Label
        self.minimumValueLabel = EmptyView() as! ValueLabel
        self.maximumValueLabel = EmptyView() as! ValueLabel
    }
    
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
        self.label = EmptyView() as! Label
        self.minimumValueLabel = EmptyView() as! ValueLabel
        self.maximumValueLabel = EmptyView() as! ValueLabel
    }
    
    var body: some View {
        let upper = bounds.upperBound
        let lower = bounds.lowerBound
        let range = upper - lower
        
        VStack {
            HStack {
                minimumValueLabel
                
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
                
                maximumValueLabel
            }
            
            label
        }
        .padding(.horizontal, 1)
        .frame(minHeight: 28, maxHeight: 60)
    }
}

extension RangeSlider where Label == EmptyView, ValueLabel == EmptyView {
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.onEditingChanged = onEditingChanged
        self.label = EmptyView()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
}

extension RangeSlider where Label: View, ValueLabel == EmptyView {
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
    
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
}

extension RangeSlider where Label: View, ValueLabel: View {
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
    }
    
    init(lo: Binding<V>, hi: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._lo = lo
        self._hi = hi
        self.bounds = bounds
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
    }
}
