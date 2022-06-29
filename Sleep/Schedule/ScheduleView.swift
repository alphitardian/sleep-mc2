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

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(showModal: .constant(false))
    }
}
