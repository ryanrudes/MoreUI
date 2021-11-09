//
//  RangeSlider.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/11/21.
//

import SwiftUI

/// A control for selecting an interval of values from a bounded linear range of values.
public struct RangeSlider<V, Label, ValueLabel>: View where V: BinaryFloatingPoint, V.Stride : BinaryFloatingPoint, Label : View, ValueLabel : View {
    @Binding var interval: ClosedRange<V>
    let bounds: ClosedRange<V>
    let step: V
    let minimumValueLabel: ValueLabel
    let maximumValueLabel: ValueLabel
    let label: Label
    let onEditingChanged: (Bool) -> Void
    
    public var body: some View {
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
                            .frame(width: geometry.size.width * CGFloat((interval.upperBound - interval.lowerBound) / range), height: 4)
                            .offset(x: geometry.size.width * CGFloat((interval.lowerBound - lower) / range))
                        
                        Circle()
                            .fill(.white)
                            .shadow(radius: 1.5, y: 0.75)
                            .frame(width: 28)
                            .offset(x: geometry.size.width * CGFloat((interval.lowerBound - lower) / range) - 14)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let hi = interval.upperBound
                                        var lo = max(min(V(gesture.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound, hi), bounds.lowerBound).rounded()
                                        if step != 0 {
                                            lo = floor(lo / step) * step
                                        }
                                        interval = ClosedRange(uncheckedBounds: (lo, hi))
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
                            .offset(x: geometry.size.width * CGFloat((interval.upperBound - lower) / range) - 14)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let lo = interval.lowerBound
                                        var hi = min(max(V(gesture.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound, lo), bounds.upperBound)
                                        if step != 0 {
                                            hi = floor(hi / step) * step
                                        }
                                        interval = ClosedRange(uncheckedBounds: (lo, hi))
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

public extension RangeSlider where Label == EmptyView, ValueLabel == EmptyView {
    /**
     Creates a range slider to select a closed interval from a given range.
     
     - Parameter interval: The selected value interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(interval: Binding<ClosedRange<V>>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = interval
        self.bounds = bounds
        self.step = 0
        self.onEditingChanged = onEditingChanged
        self.label = EmptyView()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
    
    /**
     Creates a range slider to select a closed interval from a given range, subject to a step increment.
     
     - Parameter interval: The selected value interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter step: The distance between each valid value.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(interval: Binding<ClosedRange<V>>, in bounds: ClosedRange<V> = 0...1, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = interval
        self.bounds = bounds
        self.step = V(step.magnitude)
        self.onEditingChanged = onEditingChanged
        self.label = EmptyView()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }

    /**
     Creates a range slider to select the upper and lower bounds of a closed interval from a given range.
     
     - Parameter lower: The selected lower bound of the interval within bounds.
     - Parameter upper: The selected upper bound of the interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(lower: Binding<V>, upper: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = .init(get: {
            return ClosedRange(uncheckedBounds: (lower.wrappedValue, upper.wrappedValue))
        }, set: { newValue in
            lower.wrappedValue = newValue.lowerBound
            upper.wrappedValue = newValue.upperBound
        })
        self.bounds = bounds
        self.step = 0
        self.onEditingChanged = onEditingChanged
        self.label = EmptyView()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
    
    /**
     Creates a range slider to select the upper and lower bounds of a closed interval from a given range, subject to a step increment.
     
     - Parameter lower: The selected lower bound of the interval within bounds.
     - Parameter upper: The selected upper bound of the interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter step: The distance between each valid value.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(lower: Binding<V>, upper: Binding<V>, in bounds: ClosedRange<V> = 0...1, step: V.Stride = 1, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = .init(
            get: {
                return ClosedRange(uncheckedBounds: (lower.wrappedValue, upper.wrappedValue))
            },
            set: { newValue in
                lower.wrappedValue = newValue.lowerBound
                upper.wrappedValue = newValue.upperBound
            })
        self.bounds = bounds
        self.step = V(step.magnitude)
        self.onEditingChanged = onEditingChanged
        self.label = EmptyView()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
}

public extension RangeSlider where Label: View, ValueLabel == EmptyView {
    /**
     Creates a range slider to select a closed interval from a given range, which displays the provided label.
     
     - Parameter interval: The selected value interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(interval: Binding<ClosedRange<V>>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = interval
        self.bounds = bounds
        self.step = 0
        self.onEditingChanged = onEditingChanged
        self.label = label()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
    
    /**
     Creates a range slider to select a closed interval from a given range, subject to a step increment, which displays the provided label.
     
     - Parameter interval: The selected value interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter step: The distance between each valid value.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(interval: Binding<ClosedRange<V>>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = interval
        self.bounds = bounds
        self.step = V(step.magnitude)
        self.onEditingChanged = onEditingChanged
        self.label = label()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
    
    /**
     Creates a range slider to select the upper and lower bounds of a closed interval from a given range, which displays the provided label.
     
     - Parameter lower: The selected lower bound of the interval within bounds.
     - Parameter upper: The selected upper bound of the interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(lower: Binding<V>, upper: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = .init(
            get: {
                return ClosedRange(uncheckedBounds: (lower.wrappedValue, upper.wrappedValue))
            },
            set: { newValue in
                lower.wrappedValue = newValue.lowerBound
                upper.wrappedValue = newValue.upperBound
            })
        self.bounds = bounds
        self.step = 0
        self.onEditingChanged = onEditingChanged
        self.label = label()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
    
    /**
     Creates a range slider to select the upper and lower bounds of a closed interval from a given range, subject to a step increment, which displays the provided label.
     
     - Parameter lower: The selected lower bound of the interval within bounds.
     - Parameter upper: The selected upper bound of the interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter step: The distance between each valid value.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(lower: Binding<V>, upper: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = .init(
            get: {
                return ClosedRange(uncheckedBounds: (lower.wrappedValue, upper.wrappedValue))
            },
            set: { newValue in
                lower.wrappedValue = newValue.lowerBound
                upper.wrappedValue = newValue.upperBound
            })
        self.bounds = bounds
        self.step = V(step.magnitude)
        self.onEditingChanged = onEditingChanged
        self.label = label()
        self.minimumValueLabel = EmptyView()
        self.maximumValueLabel = EmptyView()
    }
}

public extension RangeSlider where Label: View, ValueLabel: View {
    /**
     Creates a range slider to select a closed interval from a given range, which displays the provided labels.
     
     - Parameter interval: The selected value interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter minimumValueLabel: A view that describes `bounds.lowerBound`.
     - Parameter maximumValueLabel: A view that describes` bounds.upperBound`.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(interval: Binding<ClosedRange<V>>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = interval
        self.bounds = bounds
        self.step = 0
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
    }
    
    /**
     Creates a range slider to select a closed interval from a given range, subject to a step increment, which displays the provided labels.
     
     - Parameter interval: The selected value interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter step: The distance between each valid value.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter minimumValueLabel: A view that describes `bounds.lowerBound`.
     - Parameter maximumValueLabel: A view that describes` bounds.upperBound`.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(interval: Binding<ClosedRange<V>>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = interval
        self.bounds = bounds
        self.step = V(step)
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
    }
    
    /**
     Creates a range slider to select the upper and lower bounds of a closed interval from a given range, which displays the provided labels.
     
     - Parameter lower: The selected lower bound of the interval within bounds.
     - Parameter upper: The selected upper bound of the interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter minimumValueLabel: A view that describes `bounds.lowerBound`.
     - Parameter maximumValueLabel: A view that describes` bounds.upperBound`.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(lower: Binding<V>, upper: Binding<V>, in bounds: ClosedRange<V> = 0...1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = .init(
            get: {
                return ClosedRange(uncheckedBounds: (lower.wrappedValue, upper.wrappedValue))
            },
            set: { newValue in
                lower.wrappedValue = newValue.lowerBound
                upper.wrappedValue = newValue.upperBound
            })
        self.bounds = bounds
        self.step = 0
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
    }
    
    /**
     Creates a range slider to select the upper and lower bounds of a closed interval from a given range, subject to a step increment, which displays the provided labels.
     
     - Parameter lower: The selected lower bound of the interval within bounds.
     - Parameter upper: The selected upper bound of the interval within bounds.
     - Parameter bounds: The range of the valid values. Defaults to `0...1`.
     - Parameter step: The distance between each valid value.
     - Parameter label: A `View` that describes the purpose of the instance. Not all slider styles show the label, but even in those cases, SwiftUI uses the label for accessibility. For example, VoiceOver uses the label to identify the purpose of the slider.
     - Parameter minimumValueLabel: A view that describes `bounds.lowerBound`.
     - Parameter maximumValueLabel: A view that describes` bounds.upperBound`.
     - Parameter onEditingChanged: A callback for when editing begins and ends.
     
     The value of the created instance is equal to the position of the given value within bounds, mapped into `0...1`.

     The slider calls `onEditingChanged` when editing begins and ends. For example, on iOS, editing begins when the user starts to drag either thumb along the slider’s track.
     */
    init(lower: Binding<V>, upper: Binding<V>, in bounds: ClosedRange<V>, step: V.Stride = 1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self._interval = .init(
            get: {
                return ClosedRange(uncheckedBounds: (lower.wrappedValue, upper.wrappedValue))
            },
            set: { newValue in
                lower.wrappedValue = newValue.lowerBound
                upper.wrappedValue = newValue.upperBound
            })
        self.bounds = bounds
        self.step = V(step)
        self.label = label()
        self.onEditingChanged = onEditingChanged
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
    }
}
