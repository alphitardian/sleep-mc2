//
//  ScheduleView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 28/06/22.
//

import SwiftUI


struct ScheduleView: View {
    
    @Binding var showModal : Bool
    @State var isToggleSleepOn = false
    @State var isToggleWakeOn = false
    
    @State private var currentDateSleep = Date()
    @State private var currentDateWake = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundAppColor")
                    .ignoresSafeArea()
                VStack (alignment: .leading) {
                    NavigationLink(destination: ModalView(currentDate : $currentDateSleep)) {
                        VStack (alignment: .leading) {
                            Text("Sleep")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            Toggle(currentDateSleep.getTime(), isOn: $isToggleSleepOn)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                    }
                    Divider()
                    NavigationLink(destination: ModalView(currentDate : $currentDateWake)) {
                        VStack (alignment: .leading) {
                            Text("Wake Up")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            Toggle(currentDateWake.getTime(), isOn: $isToggleWakeOn)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                    }
                    Divider()
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                UINavigationBar.appearance()
                    .titleTextAttributes = [.foregroundColor:UIColor.white]
            }
            .toolbar {
                Button("Done") {
                    showModal.toggle()
                }
            }
        }
    }
}



struct ModalView: View {
    
    @Binding var currentDate : Date
    var body: some View {
        ZStack {
            Color("BackgroundAppColor")
                .ignoresSafeArea()
            VStack {
                DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.wheel)
                    .colorInvert()
                    .colorMultiply(.white)
            }
        }
    }
}

// 1 - Create a UISheetPresentationController that can be used in a SwiftUI interface
struct SheetPresentationForSwiftUI<Content>: UIViewRepresentable where Content: View {
    
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let detents: [UISheetPresentationController.Detent]
    let content: Content
    
    
    init(
        _ isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        detents: [UISheetPresentationController.Detent] = [.medium()],
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.onDismiss = onDismiss
        self.detents = detents
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        // Create the UIViewController that will be presented by the UIButton
        let viewController = UIViewController()
        
        // Create the UIHostingController that will embed the SwiftUI View
        let hostingController = UIHostingController(rootView: content)
        
        // Add the UIHostingController to the UIViewController
        viewController.addChild(hostingController)
        viewController.view.addSubview(hostingController.view)
        
        // Set constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        hostingController.didMove(toParent: viewController)
        
        // Set the presentationController as a UISheetPresentationController
        if let sheetController = viewController.presentationController as? UISheetPresentationController {
            sheetController.detents = detents
            sheetController.prefersGrabberVisible = true
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = false
            sheetController.largestUndimmedDetentIdentifier = .medium
        }
        
        // Set the coordinator (delegate)
        // We need the delegate to use the presentationControllerDidDismiss function
        viewController.presentationController?.delegate = context.coordinator
        
        
        if isPresented {
            // Present the viewController
            uiView.window?.rootViewController?.present(viewController, animated: true)
        } else {
            // Dismiss the viewController
            uiView.window?.rootViewController?.dismiss(animated: true)
        }
        
    }
    
    /* Creates the custom instance that you use to communicate changes
     from your view controller to other parts of your SwiftUI interface.
     */
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, onDismiss: onDismiss)
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        @Binding var isPresented: Bool
        let onDismiss: (() -> Void)?
        
        init(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) {
            self._isPresented = isPresented
            self.onDismiss = onDismiss
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented = false
            if let onDismiss = onDismiss {
                onDismiss()
            }
        }
        
    }
    
}

// 2 - Create the SwiftUI modifier conforming to the ViewModifier protocol
struct sheetWithDetentsViewModifier<SwiftUIContent>: ViewModifier where SwiftUIContent: View {
    
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let detents: [UISheetPresentationController.Detent]
    let swiftUIContent: SwiftUIContent
    
    init(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium()],
        onDismiss: (() -> Void)? = nil,
        content: () -> SwiftUIContent
    ) {
        self._isPresented = isPresented
        self.onDismiss = onDismiss
        self.swiftUIContent = content()
        self.detents = detents
    }
    
    func body(content: Content) -> some View {
        ZStack {
            SheetPresentationForSwiftUI($isPresented,onDismiss: onDismiss, detents: detents) {
                swiftUIContent
            }.fixedSize()
            content
        }
    }
}

// 3 - Create extension on View that makes it easier to use the custom modifier
extension View {
    
    func sheetWithDetents<Content>(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent],
        onDismiss: (() -> Void)?,
        content: @escaping () -> Content) -> some View where Content : View {
            modifier(
                sheetWithDetentsViewModifier(
                    isPresented: isPresented,
                    detents: detents,
                    onDismiss: onDismiss,
                    content: content)
            )
        }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(showModal: .constant(false))
    }
}
