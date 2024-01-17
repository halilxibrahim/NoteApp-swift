import SwiftUI

struct ContentView: View {
    @State private var notMetni: String = ""
    @State private var notlar: [Not] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Not Uygulaması")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()

                TextField("Not Metni", text: $notMetni)
                    .padding()

                Button(action: {
                    self.notlar.append(Not(metin: self.notMetni, renk: randomRenk()))
                    self.notMetni = ""
                }) {
                    Text("Not Ekle")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                List {
                    ForEach(notlar) { not in
                        NavigationLink(destination: NotDetay(not: not, notlar: $notlar)) {
                            NotSatiri(not: not)
                        }
                    }
                    .onDelete(perform: silNot)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }

    func silNot(at offsets: IndexSet) {
        notlar.remove(atOffsets: offsets)
    }

    func randomRenk() -> Color {
        let renkler: [Color] = [.red, .blue, .green, .orange, .pink, .purple, .yellow]
        return renkler.randomElement() ?? .gray
    }
}

struct NotSatiri: View {
    var not: Not

    var body: some View {
        HStack {
            Text(not.metin)
                .foregroundColor(.black)
            Spacer()
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(not.renk)
                .frame(width: 20, height: 20)
        }
        .padding()
    }
}

struct NotDetay: View {
    @ObservedObject var not: Not
    @Binding var notlar: [Not]

    @State private var duzenleModu = false
    @State private var yeniNotMetni: String = ""

    var body: some View {
        VStack {
            if duzenleModu {
                TextField("Notu Düzenle", text: $yeniNotMetni)
                    .padding()

                Button("Kaydet") {
                    if let index = notlar.firstIndex(where: { $0.id == not.id }) {
                        notlar[index].metin = yeniNotMetni
                        duzenleModu.toggle()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Text(not.metin)
                    .padding()

                Button("Düzenle") {
                    yeniNotMetni = not.metin
                    duzenleModu.toggle()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Button("Notu Sil") {
                notlar.removeAll { $0.id == not.id }
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

class Not: Identifiable, ObservableObject {
    var id = UUID()
    var metin: String
    var renk: Color

    init(metin: String, renk: Color) {
        self.metin = metin
        self.renk = renk
    }
}
