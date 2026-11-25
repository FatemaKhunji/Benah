// BenahTextField.swift
// The Figma "Field" component: label, input box, helper / error text.
// States: Default, Focused (navy 2pt border), Filled, Error (red border + alert icon), Disabled.
//
// 📘 Learning note
// `@Binding var text` means the field does not own the text; the screen does.
// The screen passes `$name` and whatever the user types is written back into
// the screen's `name` variable. That is how data flows "up" in SwiftUI.
//
//   BenahTextField(label: "First name", text: $firstName, isRequired: true,
//                  error: firstNameError)
//
//   BenahTextField(label: "Mobile number", text: $phone, prefix: "+973",
//                  keyboard: .phonePad)

import SwiftUI
import UIKit

struct BenahTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var prefix: String? = nil
    var helper: String? = nil
    var isRequired: Bool = false
    /// When not nil, the field shows the error state with this message.
    var error: String? = nil
    var keyboard: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil

    @FocusState private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled

    private var borderColor: Color {
        if error != nil { return Color.benah.danger }
        if isFocused { return Color.benah.brandNavy }
        return Color.benah.borderStrong
    }

    private var borderWidth: CGFloat {
        if error != nil { return 1.5 }
        return isFocused ? 2 : 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 2) {
                Text(label)
                    .benahFont(.labelM)
                    .foregroundStyle(Color.benah.textSecondary)
                if isRequired {
                    Text("*")
                        .benahFont(.labelM)
                        .foregroundStyle(Color.benah.danger)
                        .accessibilityHidden(true)
                }
            }

            HStack(spacing: 10) {
                if let prefix {
                    Text(prefix)
                        .benahFont(.bodyMStrong)
                        .foregroundStyle(Color.benah.textPrimary)
                    Rectangle()
                        .fill(Color.benah.borderDefault)
                        .frame(width: 1, height: 24)
                }
                TextField(placeholder, text: $text)
                    .benahFont(.bodyL)
                    .foregroundStyle(isEnabled ? Color.benah.textPrimary : Color.benah.textTertiary)
                    .tint(Color.benah.brandNavy) // caret colour
                    .keyboardType(keyboard)
                    .textContentType(textContentType)
                    .focused($isFocused)
            }
            .padding(.horizontal, Space.s16)
            .frame(height: 52)
            .background(isEnabled ? Color.benah.bgSurface : Color.benah.bgSunken,
                        in: RoundedRectangle(cornerRadius: Radius.md, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.md, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            }
            .animation(.easeOut(duration: 0.15), value: isFocused)

            if let error {
                HStack(alignment: .top, spacing: 6) {
                    BenahIconView(.alert, size: 14)
                    Text(error).benahFont(.caption)
                }
                .foregroundStyle(Color.benah.danger)
            } else if let helper {
                Text(helper)
                    .benahFont(.caption)
                    .foregroundStyle(Color.benah.textSecondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isRequired ? "\(label), required" : label)
        .accessibilityHint(error ?? helper ?? "")
    }
}

#Preview {
    struct Demo: View {
        @State var name = ""
        @State var phone = "3612 3456"
        var body: some View {
            VStack(spacing: 20) {
                BenahTextField(label: "First name", text: $name, placeholder: "Fatima", isRequired: true)
                BenahTextField(label: "Mobile number", text: $phone, prefix: "+973", helper: "We'll send a 6-digit code")
                BenahTextField(label: "Surname", text: .constant(""), isRequired: true, error: "Enter your surname")
                BenahTextField(label: "Email", text: .constant("fatima@example.com")).disabled(true)
            }
            .padding()
            .background(Color.benah.bgCanvas)
        }
    }
    return Demo()
}
