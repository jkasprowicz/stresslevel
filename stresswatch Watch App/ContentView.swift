import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var stressLevel: String = "Calculando"
    @State private var heartRate: Double = 0.0
    @State private var hrv: Double = 0.0
    @State private var rhr: Double = 0.0
    @State private var sleepHours: Double = 0.0
    @State private var timer: Timer? // Timer to send data every 30 seconds
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Nível de Estresse")
                .font(.caption) // Smaller font for the title
                .foregroundColor(.secondary)

            HStack {
                Text(stressMessage)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                if stressLevel == "Calculando" {
                    PulsingDots() // Adds animated dots
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(stressColor)
            .cornerRadius(8)
            .shadow(radius: 3)

            Button(action: {
                fetchDataAndPredictStress()
            }) {
                Text("Atualizar")
                    .font(.footnote)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .onAppear {
            startSendingData()
        }
        .onDisappear {
            stopSendingData()
        }
    }

    // Custom feedback message based on stress level
    private var stressMessage: String {
        switch stressLevel {
        case "Nivel Baixo de Estresse":
            return "😊 Nível baixo."
        case "Nivel Médio de Estresse":
            return "😌 Nível Moderado."
        case "Nivel Alto de Estresse":
            return "⚠️ Nível Alto."
        default:
            return "Calculando"
        }
    }

    // Dynamic color based on stress level with gradient effect
    private var stressColor: Color {
        switch stressLevel {
        case "Nivel Baixo de Estresse":
            return Color.green
        case "Nivel Médio de Estresse":
            return Color.yellow
        case "Nivel Alto de Estresse":
            return Color.red
        default:
            return Color.gray
        }
    }

    // Function to generate random health data
    func generateRandomData() -> (heartRate: Double, hrv: Double, rhr: Double, sleepHours: Double) {
        let heartRate = Double.random(in: 60...140)
        let hrv = Double.random(in: 30...100)
        let rhr = Double.random(in: 50...70)
        let sleepHours = Double.random(in: 4...10)
        
        return (heartRate, hrv, rhr, sleepHours)
    }
    
    // Function to fetch data and predict stress level
    func fetchDataAndPredictStress() {
        let url = URL(string: "http://127.0.0.1:5001/predict")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "mean_hr": heartRate,
            "mean_hrv_sdnn": hrv,
            "mean_rhr": rhr,
            "total_sleep_hours": sleepHours
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let predictedStressLevel = json["stress_level"] as? String {
                DispatchQueue.main.async {
                    self.stressLevel = predictedStressLevel
                }
            }
        }
        task.resume()
    }
    
    // Timer to send random data every 30 seconds
    func startSendingData() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            let randomData = generateRandomData()
            self.heartRate = randomData.heartRate
            self.hrv = randomData.hrv
            self.rhr = randomData.rhr
            self.sleepHours = randomData.sleepHours
            fetchDataAndPredictStress()
        }
    }
    
    // Stop the timer when view disappears
    func stopSendingData() {
        timer?.invalidate()
    }
}

// View to create the pulsing dots animation
struct PulsingDots: View {
    @State private var dot1Visible = false
    @State private var dot2Visible = false
    @State private var dot3Visible = false

    var body: some View {
        HStack(spacing: 2) {
            Circle()
                .frame(width: 4, height: 4)
                .opacity(dot1Visible ? 1 : 0.2)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0), value: dot1Visible)
                .onAppear { dot1Visible.toggle() }

            Circle()
                .frame(width: 4, height: 4)
                .opacity(dot2Visible ? 1 : 0.2)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0.2), value: dot2Visible)
                .onAppear { dot2Visible.toggle() }

            Circle()
                .frame(width: 4, height: 4)
                .opacity(dot3Visible ? 1 : 0.2)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0.4), value: dot3Visible)
                .onAppear { dot3Visible.toggle() }
        }
    }
}
