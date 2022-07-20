//
//  TimerPickerView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 19/07/22.
//

import SwiftUI

struct TimerPickerView: UIViewRepresentable {
    typealias UIViewType = UIPickerView
    
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var second: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        // For adding default value
        uiView.selectRow(minute, inComponent: 1, animated: true)
        
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: TimerPickerView
        
        init(_ pickerView: TimerPickerView) {
            self.parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0:
                return 25
            case 1,2:
                return 60
            default:
                return 0
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return pickerView.frame.size.width / 3
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0:
                return "\(row) Hour"
            case 1:
                return "\(row) Min"
            case 2:
                return "\(row) Sec"
            default:
                return ""
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                self.parent.hour = row
            case 1:
                self.parent.minute = row
            case 2:
                self.parent.second = row
            default:
                break;
            }
        }
    }
}
