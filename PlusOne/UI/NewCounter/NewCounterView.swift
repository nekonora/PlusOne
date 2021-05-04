//
//  NewCounterView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/07/2020.
//

import SwiftUI
import Combine

// MARK: - NewCounterView
struct NewCounterView: View {
    
    @ObservedObject var viewModel: NewCounterVM
    
    var body: some View {
        #if targetEnvironment(macCatalyst)
        CounterForm(viewModel: viewModel)
        HStack {
            Button(R.string.localizable.alertCancel()) {
                self.viewModel.dismiss?()
            }
            Spacer()
            Button(viewModel.editingCounter == nil ? R.string.localizable.newCounterAdd() : R.string.localizable.newCounterSave()) {
                viewModel.saveCounter()
            }.disabled(viewModel.name.isEmpty)
        }.padding()
        #else
        NavigationView {
            CounterForm(viewModel: viewModel)
        }
        #endif
    }
}

// MARK: - CounterForm
private struct CounterForm: View {
    
    @ObservedObject var viewModel: NewCounterVM
    @State private var isShowingTagsSelection = false
    
    var body: some View {
        Form {
            Section(header: Text(R.string.localizable.newCounterMainInfoSectionTitle())) {
                HStack {
                    Text(R.string.localizable.newCounterMainInfoNameLabel())
                    Spacer()
                    TextField(R.string.localizable.newCounterMainInfoNamePlaceholder(), text: $viewModel.name)
                        .multilineTextAlignment(.trailing)
                        .disableAutocorrection(true)
                }
                
                HStack {
                    Text(R.string.localizable.newCounterMainInfoInitialValueLabel())
                    Spacer()
                    TextField(R.string.localizable.newCounterMainInfoInitialValuePlaceholder(), text: $viewModel.value)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.value)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { self.viewModel.value = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section(header: Text("Other")) {
                HStack {
                    Text("Increment")
                    Spacer()
                    TextField("1", text: $viewModel.increment)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.increment)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { self.viewModel.increment = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Unit")
                    Spacer()
                    TextField("", text: $viewModel.unit)
                        .onReceive(Just(viewModel.unit)) { newValue in
                            let filtered = String(newValue.prefix(2))
                            if filtered != newValue { self.viewModel.unit = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                HStack {
                    Text("Completion value")
                    Spacer()
                    TextField("", text: $viewModel.completionValue)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.completionValue)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { self.viewModel.completionValue = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section(header: Text("Tags")) {
                if !viewModel.tags.isEmpty {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(Array(viewModel.tags), id: \.identifier) { tag in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(R.color.accentColor.color)
                                    Text(tag.name)
                                        .foregroundColor(.white)
                                        .padding(8)
                                }
                            }
                        }
                    }
                }
                
                Button(viewModel.tags.isEmpty ? "Add Tags" : "Edit tags") {
                    isShowingTagsSelection.toggle()
                }
                .sheet(isPresented: $isShowingTagsSelection) {
                    TagsView(viewModel: viewModel, selectedTags: viewModel.tags, initiallySelectedTags: viewModel.tags)
                }
            }
        }
        .navigationBarTitle(viewModel.editingCounter == nil ? "New Counter" : "Edit Counter", displayMode: .inline)
        .navigationBarItems(
            leading:
                Button("Cancel") {
                    self.viewModel.dismiss?()
                }
            ,
            trailing:
                Button(viewModel.editingCounter == nil ? "Add" : "Save") {
                    viewModel.saveCounter()
                }
                .disabled(viewModel.name.isEmpty)
        )
    }
}

// MARK: - TagsView
private struct TagsView: View {
    
    @ObservedObject var viewModel: NewCounterVM
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var newTag: String = ""
    @State var selectedTags: Set<Tag>
    
    var initiallySelectedTags: Set<Tag>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    TextField("Create new tag", text: $newTag)
                        .multilineTextAlignment(.leading)
                        .disableAutocorrection(true)
                    
                    Button("Create") {
                        do {
                            try CoreDataManager.shared.newTag(named: newTag)
                        } catch {
                            
                        }
                    }
                    .disabled(newTag.isEmpty)
                }
                .padding()
                
                TagsList(selectedTags: $selectedTags)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .environment(\.managedObjectContext, CoreDataManager.shared.context)
                    
                Spacer()
            }
            .padding(.top, 20)
            .background(Color(.secondarySystemBackground))
            .navigationBarTitle("Select tags", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                ,
                trailing:
                    Button("Done") {
                        viewModel.tags = selectedTags
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedTags == initiallySelectedTags)
            )
        }
    }
}
