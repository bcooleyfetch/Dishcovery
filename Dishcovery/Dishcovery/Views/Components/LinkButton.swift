struct LinkButton: View {
  let title: String
  let systemImage: String
  let url: URL
  let color: Color

  var body: some View {
    Link(destination: url) {
      Label(title, systemImage: systemImage)
        .font(.headline)
        .foregroundStyle(color)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
  }
}