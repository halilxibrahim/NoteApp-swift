import SwiftUI

struct ContentView: View {
    
    @State var notMetni: String = ""
    @State var notlar: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Not Uygulaması") // Yeni satır eklendi
                
                // Not oluşturma alanı
                TextField("Not Metni", text: $notMetni)
                    .padding()
                
                // Not ekleme düğmesi
                Button(action: {
                    self.notlar.append(self.notMetni)
                    self.notMetni = ""
                }) {
                    Text("Not Ekle")
                }
                .padding()
                
                // Notlar listesi
                List {
                    ForEach(0..<notlar.count, id: \.self) { index in
                        NavigationLink(destination: NotDetay(notMetni: self.$notlar[index])) {
                            Text(self.notlar[index])
                        }
                    }
                    .onDelete(perform: silNot)
                }
            }
            .navigationBarTitle("Yeni Teknolojiler Ödevi")
        }
    }
    
    // Not silme işlevi
    func silNot(at offsets: IndexSet) {
        notlar.remove(atOffsets: offsets)
    }
}

// Not detay sayfası
struct NotDetay: View {
    
    @Binding var notMetni: String
    @State private var notSilmeOnaylandi = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextEditor(text: $notMetni)
                .navigationBarTitle("Not Düzenle")
            
            Button("Notu Sil") {
                notSilmeOnaylandi = true
            }
            .alert(isPresented: $notSilmeOnaylandi) {
                Alert(
                    title: Text("Notu Sil"),
                    message: Text("Bu notu silmek istediğinize emin misiniz?"),
                    primaryButton: .destructive(Text("Sil")) {
                        // Notu sil
                        notMetni = ""
                        // Geri git
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
