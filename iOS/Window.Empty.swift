import SwiftUI

extension Window {
    struct Empty: View {
        @Binding var session: Session
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image(session.archive.items.isEmpty ? "welcome" : "choose")
                    
                    if session.archive.items.isEmpty {
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                Text("Start")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .fixedSize()
                        .padding()
                    }
                }
            }
            .navigationBarTitle(session.archive.items.isEmpty ? "Start your first project now" : "Choose a project to start", displayMode: .inline)
        }
    }
}
