//
//  ContentView.swift
//  Calculator SwiftUI
//
//  Created by Jacob Sokora on 5/5/20.
//  Copyright © 2020 Jacob Sokora. All rights reserved.
//

import SwiftUI

struct Converter {

	static let ftoc = Converter(inUnit: "ºF", outUnit: "ºC") { ($0 - 32) * 5 / 9 }
	static let ctof = Converter(inUnit: "ºC", outUnit: "ºF") { $0 * 9 / 5 + 32 }
	static let mtok = Converter(inUnit: "m", outUnit: "km") { $0 * 1.60934 }
	static let ktom = Converter(inUnit: "km", outUnit: "m") { $0 / 1.60934 }

	let converter: (Double) -> Double
	let inFormatter: ConverterFormatter
	let outFormatter: ConverterFormatter

	init(inUnit: String, outUnit: String, converter: @escaping (Double) -> Double) {
		self.converter = converter
		self.inFormatter = ConverterFormatter(unit: inUnit)
		self.outFormatter = ConverterFormatter(unit: outUnit, converter: converter)
	}

	class ConverterFormatter: Formatter {
		let unit: String
		let converter: ((Double) -> Double)?

		init(unit: String, converter: ((Double) -> Double)? = nil) {
			self.unit = unit
			self.converter = converter
			super.init()
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		override func string(for obj: Any?) -> String? {
			guard var number = obj as? String else {
				return unit
			}
			if let converter = converter, let double = Double(number) {
				let convertedNumber = converter(double)
				let parts = number.split(separator: ".")
				var mod: Double = 1000
				if parts.count == 2 {
					mod = 10.0 * Double(parts[1].count)
				}
				number = String(Double(round(convertedNumber * mod) / mod))
			}
			return "\(number) \(unit)"
		}
	}
}

struct NumberButton: View {

	@Binding var number: String?
	var value: Int

	var body: some View {
		Button(action: {
			if let number = self.number {
				if Double(number) == 0 && !number.contains(".") {
					self.number = "\(self.value)"
				} else {
					self.number = "\(number)\(self.value)"
				}
			} else {
				self.number = "\(self.value)"
			}
		}, label: {
			Text("\(value)")
		})
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.font(.custom("Avenir Light", size: 40))
		.background(Color(hex: "CCCCCC"))
		.foregroundColor(.black)
	}

}

struct CalculatorView: View {

	@State var input: String? = nil
	@State var converter: Converter = .ftoc
	@State var selectConverter = false

	var converterButton: some View {
		Button(action: { self.selectConverter = true }, label: { Text("Converter") })
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.font(.custom("Avenir Light", size: 23))
			.background(Color.orange)
			.foregroundColor(.black)
			.actionSheet(isPresented: self.$selectConverter) {
				ActionSheet(title: Text("Select a converter"), message: nil, buttons: [
					.default(Text("Fahrenheit to Celcius")) { self.converter = .ftoc },
					.default(Text("Celcius to Fahrenheit")) { self.converter = .ctof },
					.default(Text("Miles to Kilometers")) { self.converter = .mtok },
					.default(Text("Kilometers to Miles")) { self.converter = .ktom },
					.cancel()
				])
			}
	}

    var body: some View {
		GeometryReader { geo in
			VStack(spacing: 1) {
				TextField("", value: self.$input, formatter: self.converter.inFormatter)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.multilineTextAlignment(.trailing)
					.background(Color(hex: "DCFFFF"))
					.foregroundColor(.black)
					.font(.system(size: 40))
					.disabled(true)
					.accessibility(identifier: "Input")
				TextField("", value: self.$input, formatter: self.converter.outFormatter)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.multilineTextAlignment(.trailing)
					.background(Color.white)
					.foregroundColor(.black)
					.font(.system(size: 40))
					.disabled(true)
					.accessibility(identifier: "Output")
				HStack(spacing: 1) {
					Button(action: { self.input = nil }, label: { Text("C") })
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.font(.custom("Avenir Light", size: 40))
						.background(Color(hex: "B3B3B3"))
						.foregroundColor(.black)
					Button(action: {
						if let input = self.input {
							if input.starts(with: "-") {
								self.input?.remove(at: input.startIndex)
							} else {
								self.input = "-\(input)"
							}
						}
					}, label: { Text("+/-") })
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.font(.custom("Avenir Light", size: 40))
					.background(Color(hex: "B3B3B3"))
					.foregroundColor(.black)
					converterButton
				}
				HStack(spacing: 1) {
					NumberButton(number: self.$input, value: 7)
					NumberButton(number: self.$input, value: 8)
					NumberButton(number: self.$input, value: 9)
				}
				HStack(spacing: 1) {
					NumberButton(number: self.$input, value: 4)
					NumberButton(number: self.$input, value: 5)
					NumberButton(number: self.$input, value: 6)
				}
				HStack(spacing: 1) {
					NumberButton(number: self.$input, value: 1)
					NumberButton(number: self.$input, value: 2)
					NumberButton(number: self.$input, value: 3)
				}
				HStack(spacing: 1) {
					Button(action: {
						if let input = self.input, Double(input) != 0 || input.contains(".") {
							self.input = "\(input)0"
						} else {
							self.input = "0"
						}
					}, label: { Text("0") })
					.frame(maxWidth: geo.size.width / 3 * 2 + 0.5, maxHeight: .infinity)
					.font(.custom("Avenir Light", size: 40))
					.background(Color(hex: "CCCCCC"))
					.foregroundColor(.black)
					Button(action: {
						if let input = self.input {
							self.input = "\(input)."
						} else {
							self.input = "0."
						}
					}, label: { Text(".") })
					.frame(maxWidth: geo.size.width / 3 - 0.5, maxHeight: .infinity)
					.font(.custom("Avenir Light", size: 40))
					.background(Color(hex: "CCCCCC"))
					.foregroundColor(.black)
					.accessibility(identifier: "decimal")
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.gray)
		}
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
