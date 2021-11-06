//
//  SFSymbolPicker.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/14/21.
//
//  W.I.P.

import SwiftUI
import SFSafeSymbols

enum SymbolCategory: String, CaseIterable, Identifiable {
    var id: RawValue { rawValue }
    
    case all = "All"
    case whatsNew = "What's New"
    case multicolor = "Multicolor"
    case communication = "Communication"
    case weather = "Weather"
    case objectsAndTools = "Objects & Tools"
    case devices = "Devices"
    case gaming = "Gaming"
    case connectivity = "Connectivity"
    case transportation = "Transportation"
    case human = "Human"
    case nature = "Nature"
    case editing = "Editing"
    case textFormatting = "Text Formatting"
    case media = "Media"
    case keyboard = "Keyboard"
    case commerce = "Commerce"
    case time = "Time"
    case health = "Health"
    case shapes = "Shapes"
    case arrows = "Arrows"
    case indices = "Indices"
    case math = "Math"
    
    var systemImage: String {
        switch self {
        case .all:
            return "square.grid.2x2"
        case .whatsNew:
            return "sparkles"
        case .multicolor:
            return "paintpalette"
        case .communication:
            return "message"
        case .weather:
            return "cloud.sun"
        case .objectsAndTools:
            return "folder"
        case .devices:
            return "desktopcomputer"
        case .gaming:
            return "gamecontroller"
        case .connectivity:
            return "antenna.radiowaves.left.and.right"
        case .transportation:
            return "car.fill"
        case .human:
            return "person.crop.circle"
        case .nature:
            return "leaf"
        case .editing:
            return "slider.horizontal.3"
        case .textFormatting:
            return "textformat.alt"
        case .media:
            return "playpause"
        case .keyboard:
            return "command"
        case .commerce:
            return "cart"
        case .time:
            return "timer"
        case .health:
            return "heart"
        case .shapes:
            return "square.on.circle"
        case .arrows:
            return "arrow.right"
        case .indices:
            return "a.circle"
        case .math:
            return "x.squareroot"
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

extension SymbolRenderingMode: Hashable {
    public static func == (lhs: SymbolRenderingMode, rhs: SymbolRenderingMode) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: self))
    }
}

extension SymbolRenderingMode: CaseIterable {
    public static var allCases: [SymbolRenderingMode] {
        return [.monochrome, .hierarchical, .palette, .multicolor]
    }
}

struct SFSymbolPicker: View {
    @Environment(\.dismiss) var dismiss
    @State var category: SymbolCategory = .all
    @State var isMenuOpen = true
    @State var search = ""
    @State var symbolRenderingMode: SymbolRenderingMode = .monochrome
    @State var selection: SFSymbol = .cloudSunRainFill
    
    let rows = [
        GridItem(.adaptive(minimum: 65)),
        GridItem(.adaptive(minimum: 65)),
        GridItem(.adaptive(minimum: 65)),
        GridItem(.adaptive(minimum: 65))
    ]

    var body: some View {
        NavigationView {
            Group {
                if isMenuOpen {
                    List {
                        ForEach(SymbolCategory.allCases) { category in
                            Button(action: {
                                
                            }) {
                                Label(category.rawValue, systemImage: category.systemImage)
                                    .tag(category)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .onAppear {
                        UITableView.appearance().contentInset.top = 15//-35
                    }
                    .transition(.opacity)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: rows, spacing: 10) {
                            ForEach(SFSymbol.allCases, id: \.self) { symbol in
                                let a = search.lowercased()
                                let b = symbol.rawValue.lowercased()
                                
                                if search.isEmpty || b.contains(a) || levDis(a, b) < min(2, b.count) {
                                    ZStack {
                                        Capsule()
                                            .foregroundColor(selection == symbol ? Color.tertiarySystemBackground : Color.clear)
                                            .shadow(color: .black.opacity(0.2), radius: 1)
                                            //.animation(.spring())
                                            .frame(width: 60, height: 60)
                                        
                                        Button(action: {
                                            selection = symbol
                                        }) {
                                            Image(systemSymbol: symbol)
                                                .resizable()
                                                .scaledToFit()
                                                .padding(7)
                                                .frame(width: 50, height: 50)
                                                .symbolRenderingMode(symbolRenderingMode)
                                                .animation(.spring(), value: symbolRenderingMode)
                                                .if(symbolRenderingMode == .palette) {
                                                    $0.foregroundStyle(Color.primary, Color.accentColor)
                                                }
                                                .if(symbolRenderingMode == .multicolor) {
                                                    $0.foregroundStyle(Color.primary)
                                                }
                                        }
                                        .contextMenu {
                                            Label(symbol.rawValue, systemSymbol: symbol)
                                        }
                                        //.shadow(radius: selection == symbol ? 3 : 0)
                                    }
                                }
                            }
                        }
                    }
                    //.offset(y: -30)
                    //.padding(.top, 30)
                    .padding(.horizontal)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .transition(.opacity)
                    .searchable(text: $search, placement: .navigationBarDrawer, prompt: "Search symbols")
                }
            }
            .animation(.spring(), value: isMenuOpen)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isMenuOpen.toggle()
                    }) {
                        Image(systemName: "sidebar.leading")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    SymbolRenderingModeSegmentedPicker(selection: $symbolRenderingMode, symbol: $selection)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
    
    func levDis(_ w1: String, _ w2: String) -> Int {
        let empty = [Int](repeating:0, count: w2.count)
        var last = [Int](0...w2.count)

        for (i, char1) in w1.enumerated() {
            var cur = [i + 1] + empty
            for (j, char2) in w2.enumerated() {
                cur[j + 1] = char1 == char2 ? last[j] : min(last[j], last[j + 1], cur[j]) + 1
            }
            last = cur
        }
        return last.last!
    }
}

struct SFSymbolPickerDemo: View {
    @State var isPresented = false
    
    var body: some View {
        Text("Placeholder")
            .adaptiveSheet(isPresented: $isPresented, detents: [.medium()]) {
                SFSymbolPicker()
            }
            .onAppear {
                isPresented = true
            }
    }
}

struct SFSymbolPickerDemo_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolPickerDemo()
    }
}
