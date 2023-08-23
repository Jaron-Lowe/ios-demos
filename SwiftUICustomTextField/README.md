# Custom Text Field Layout
This small demo was made for a user in a [Reddit thread](https://www.reddit.com/r/SwiftUI/comments/15z0bli/what_is_the_effective_way_to_achieve_this_ui/) as an example on how to create a text field with an icon and a rounded border.
It allows for customizing the icon and configuring the internal TextField without any custom modifiers.

## Solution
The solution is a basic wrapper view that takes a view builder closure intended for use with a TextField. This example assumes the usage of SF Symbol images but could easily have any custom image swapped out.

```swift
struct IconTextField<Content: View>: View {
    let iconSystemName: String
    @ViewBuilder let textField: () -> Content
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconSystemName)
                .imageScale(.medium)
                .foregroundColor(Color(.textFieldIconColor))
            textField()
        }
        .padding()
        .overlay {
            Capsule(style: .circular)
                .stroke(Color(.textFieldBorderColor), lineWidth: 2)
        }
    }
}
```

## Usage
Simply pass through a system image name and a configured TextField/SecureField.

```swift
/// Email Field
IconTextField(iconSystemName: "envelope") {
    TextField("Enter e-mail address", text: $email)
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
}

/// Password Field
IconTextField(iconSystemName: "lock") {
    SecureField("Enter password", text: $password)
        .textContentType(.password)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
}
```

| Target | Result |
| ------ | ------ |
| ![Target_Image](https://github.com/Jaron-Lowe/ios-demos/assets/10712389/44f3678f-b13c-47a9-8fac-71cacd7b0dae) | ![Result_Image](https://github.com/Jaron-Lowe/ios-demos/assets/10712389/29c93620-e31f-4c00-b544-f77ca8e2dff8) |

## Topics
#SwiftUI
