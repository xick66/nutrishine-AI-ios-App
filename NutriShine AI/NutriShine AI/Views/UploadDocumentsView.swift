//
//  UploadDocumentsView.swift
//  NutriShine AI
//
//  Created by Rahul K M on 19/02/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct UploadDocumentsView: View {
    @State private var isShowingDocumentPicker = false
    @State private var pickedDocuments: [URL] = []

    var body: some View {
        VStack {
            Text("Upload your medical documents here.")
                .padding()

            Button("Pick Documents") {
                isShowingDocumentPicker = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            List(pickedDocuments, id: \.self) { url in
                Text(url.lastPathComponent)
                    .padding()
            }
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(pickedDocuments: $pickedDocuments)
        }
        .navigationTitle("Upload Documents")
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var pickedDocuments: [URL]
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.plainText], asCopy: true)
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.pickedDocuments = urls
            parent.presentationMode.wrappedValue.dismiss()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
