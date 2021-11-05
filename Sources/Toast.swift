//
//  Toast.swift
//  MoreUI
//
//  Created by Ryan Rudes on 11/2/21.
//
//  W.I.P.

import SwiftUI

// 691 / 1170
// 150 / 2532
// 31, 31, 31

// 600 / 1170
// 150 / 2532

@ViewBuilder func createTitle<S: StringProtocol>(_ text: S) -> Text {
    Text(text)
        .foregroundColor(.white)
        .bold()
        .font(.footnote)
}

@ViewBuilder func createSubtitle<S: StringProtocol>(_ text: S) -> Text {
    Text(text)
        .foregroundColor(.gray)
        .bold()
        .font(.footnote)
}

@ViewBuilder func createImage<S: StringProtocol>(_ systemImage: S) -> some View {
    Image(systemName: systemImage as! String)
        .resizable()
        .scaledToFit()
}

struct Toast<Title, Subtitle, Symbol>: View where Title : View, Subtitle : View, Symbol : View {
    
    var title: Title
    var subtitle: Subtitle
    var image: Symbol

    var body: some View {
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height
        
        HStack {
            image
            
            Spacer()
            
            VStack(spacing: 1) {
                title
                subtitle
            }
            
            Spacer()
            
            if image is Image {
                Button(action: {
                    
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.tintColor)
                        .padding(7.5)
                        .background(Color.systemGray3)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 12)
        .frame(width: 0.51282051282 * w, height: 0.05924170616 * h)
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(Color(red: 31/255,
                            green: 31/255,
                            blue: 31/255))
        )
    }
}

extension Toast where Title == Text, Subtitle == Text, Symbol: View {
    init(@ViewBuilder title: () -> Title, @ViewBuilder subtitle: () -> Subtitle, @ViewBuilder image: () -> Symbol) {
        self.title = title()
        self.subtitle = subtitle()
        self.image = image()
    }
    
    init<S: StringProtocol>(@ViewBuilder title: () -> Title, subtitle: S, @ViewBuilder image: () -> Symbol) {
        self.title = title()
        self.subtitle = createSubtitle(subtitle)
        self.image = image()
    }

    init<S: StringProtocol>(@ViewBuilder title: () -> Title, @ViewBuilder subtitle: () -> Subtitle, systemImage: S) {
        self.title = title()
        self.subtitle = subtitle()
        self.image = createImage(systemImage) as! Symbol
    }
    
    init<S: StringProtocol>(@ViewBuilder title: () -> Title, subtitle: S, systemImage: S) {
        self.title = title()
        self.subtitle = createSubtitle(subtitle)
        self.image = createImage(systemImage) as! Symbol
    }
    
    init<S: StringProtocol>(title: S, @ViewBuilder subtitle: () -> Subtitle, @ViewBuilder image: () -> Symbol) {
        self.title = createTitle(title)
        self.subtitle = subtitle()
        self.image = image()
    }
    
    init<S: StringProtocol>(title: S, subtitle: S, @ViewBuilder image: () -> Symbol) {
        self.title = createTitle(title)
        self.subtitle = createSubtitle(subtitle)
        self.image = image()
    }
    
    init<S: StringProtocol>(title: S, @ViewBuilder subtitle: () -> Subtitle, systemImage: S) {
        self.title = createTitle(title)
        self.subtitle = subtitle()
        self.image = createImage(systemImage) as! Symbol
    }
}

extension Toast where Title == Text, Subtitle == Text, Symbol == AnyView {
    init<S: StringProtocol>(title: S, subtitle: S, systemImage: S) {
        self.title = createTitle(title)
        self.subtitle = createSubtitle(subtitle)
        self.image = createImage(systemImage) as! Symbol
    }
}

extension Toast where Title == Text, Subtitle == EmptyView, Symbol == AnyView {
    init(@ViewBuilder title: () -> Title, @ViewBuilder image: () -> Symbol) {
        self.title = title()
        self.subtitle = EmptyView()
        self.image = image()
    }
    
    init<S: StringProtocol>(@ViewBuilder title: () -> Title, systemImage: S) {
        self.title = title()
        self.subtitle = EmptyView()
        self.image = createImage(systemImage) as! Symbol
    }
    
    init<S: StringProtocol>(title: S, @ViewBuilder image: () -> Symbol) {
        self.title = createTitle(title)
        self.subtitle = EmptyView()
        self.image = image()
    }
    
    init<S: StringProtocol>(title: S, systemImage: S) {
        self.title = createTitle(title)
        self.subtitle = EmptyView()
        self.image = createImage(systemImage) as! Symbol
    }
}

extension Toast where Title == Text, Subtitle == Text, Symbol == EmptyView {
    init(@ViewBuilder title: () -> Title, @ViewBuilder subtitle: () -> Subtitle) {
        self.title = title()
        self.subtitle = subtitle()
        self.image = EmptyView()
    }
    
    init<S: StringProtocol>(@ViewBuilder title: () -> Title, subtitle: S) {
        self.title = title()
        self.subtitle = createSubtitle(subtitle)
        self.image = EmptyView()
    }
    
    init<S: StringProtocol>(title: S, @ViewBuilder subtitle: () -> Subtitle) {
        self.title = createTitle(title)
        self.subtitle = subtitle()
        self.image = EmptyView()
    }
    
    init<S: StringProtocol>(title: S, subtitle: S) {
        self.title = createTitle(title)
        self.subtitle = createSubtitle(subtitle)
        self.image = EmptyView()
    }
}

extension Toast where Title == Text, Subtitle == EmptyView, Symbol == EmptyView {
    init(@ViewBuilder title: () -> Title) {
        self.title = title()
        self.subtitle = EmptyView()
        self.image = EmptyView()
    }
    
    init<S: StringProtocol>(title: S) {
        self.title = createTitle(title)
        self.subtitle = EmptyView()
        self.image = EmptyView()
    }
}


/*
extension Toast where Symbol == AnyView {
    internal func render(_ mode: SymbolRenderingMode) -> Self {
        self.symbolRenderingMode = mode
        return self
    }
}
*/

extension View {
    /**
     Presents a toast alert when a binding to a Boolean value that you provide is true.
     - Parameter isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier’s content closure.
     - Parameter onDismiss: The closure to execute when dismissing the sheet.
     - parameter content: A closure returning the toast to present.
     */
    func toast(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, duration: Double = 2, content: @escaping () -> Toast<Text, Text, Image>) -> some View {
        ZStack {
            self
            
            VStack {
                if isPresented.wrappedValue {
                    content()
                        .transition(.asymmetric(insertion: .move(edge: .top), removal: .offset(CGSize(width: 0, height: -80))))
                        .animation(.spring())
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation(.spring()) {
                                    isPresented.wrappedValue.toggle()
                                }
                            }
                        }
                }
                
                Spacer()
            }
        }
    }
}

struct AlertToastPreview: View {
    @State var isToast1Presented = false
    @State var isToast2Presented = false
    
    var body: some View {
        List {
            HStack {
                Spacer()
                
                Button(action: {
                    isToast1Presented.toggle()
                }, label: {
                    Toast(title: "Sleep", subtitle: "On", image: {
                        Image(systemName: "bed.double.fill")
                            .symbolRenderingMode(.multicolor)
                    })
                })
                
                Spacer()
            }
            .listRowBackground(Color.clear)
            
            /*
            HStack {
                Spacer()
                
                Button(action: {
                    isToast2Presented.toggle()
                }) {
                    Toast(title: "Notes pasted from Chrome")
                }
                
                Spacer()
            }
            .listRowBackground(Color.clear)
            */
        }
        .toast(isPresented: $isToast1Presented, onDismiss: {
            
        }, content: {
            Toast(title: "Sleep", subtitle: "On", image: {
                Image(systemName: "bed.double.fill")
                    .symbolRenderingMode(.multicolor)
            })
        })
        /*
        .toast(isPresented: $isToast2Presented, onDismiss: {
            
        }, content: {
            Toast(title: "Notes pasted from Chrome")
        })
        */
    }
}

struct AlertToast_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AlertToastPreview()
        }
        .preferredColorScheme(.dark)
    }
}
