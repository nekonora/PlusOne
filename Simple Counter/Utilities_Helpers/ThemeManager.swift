//
//  ThemeManager.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 01/04/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

/*
THEMES:

# Ocean (default dark theme)
- tint:			2EC4B6 - greenPastel
- background:	011627 - notQuiteBlack
- text:			FDFFFC - notQuiteWhite
- tags:			FF9F1C - pastelOrange
- deletion:		E71D36 - pastelRed

# Sunrise
- tint:			1A3263
- background:	E8E2DB
- text:			16161D
- tags:			FAB95B
- deletion:		F5564E

*/


import UIKit
import Foundation
import Menu


extension UIColor {
	
	func colorFromHexString (_ hex:String) -> UIColor {
		var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		
		if (cString.hasPrefix("#")) {
			cString.remove(at: cString.startIndex)
		}
		
		if ((cString.count) != 6) {
			return UIColor.gray
		}
		
		var rgbValue:UInt32 = 0
		Scanner(string: cString).scanHexInt32(&rgbValue)
		
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
}


enum Theme: Int {
	
	case ocean, sunrise
	
	var tintColor: UIColor {
		switch self {
		case .ocean:
			return UIColor().colorFromHexString("2EC4B6")
		case .sunrise:
			return UIColor().colorFromHexString("1A3263")
		}
	}
	
	//Customizing the Navigation Bar
	var barStyle: UIBarStyle {
		switch self {
		case .ocean:
			return .black
		case .sunrise:
			return .default
		}
	}
	
//	var navigationBackgroundImage: UIImage? {
//		return self == .ocean ? UIImage(named: "navBackground") : nil
//	}
//
//	var tabBarBackgroundImage: UIImage? {
//		return self == .ocean ? UIImage(named: "tabBarBackground") : nil
//	}
	
	var backgroundColor: UIColor {
		switch self {
		case .ocean:
			return UIColor().colorFromHexString("011627")
		case .sunrise:
			return UIColor().colorFromHexString("E8E2DB")
		}
	}
	
	var tagsColor: UIColor {
		switch self {
		case .ocean:
			return UIColor().colorFromHexString("FF9F1C")
		case .sunrise:
			return UIColor().colorFromHexString("FAB95B")
		}
	}
	
	var textColor: UIColor {
		switch self {
		case .ocean:
			return UIColor().colorFromHexString("FDFFFC")
		case .sunrise:
			return UIColor().colorFromHexString("16161D")
		}
	}
	
	var deletionColor: UIColor {
		switch self {
		case .ocean:
			return UIColor().colorFromHexString("E71D36")
		case .sunrise:
			return UIColor().colorFromHexString("F5564E")
		}
	}
}

enum CustomMenuTheme {
	
//	static var dark: MenuTheme {
//		struct PlusOneTheme: MenuTheme {
//			let font 						= UIFont.systemFont(ofSize: 16, weight: .medium)
//			let textColor 					= UIColor(named: "greenPastel")!
//			let brightTintColor 			= UIColor.black
//			let darkTintColor 				= UIColor.black
//			let highlightedTextColor 		= UIColor.white
//			let highlightedBackgroundColor 	= UIColor(named: "greenPastel")!
//			let backgroundTint 				= UIColor(red:0.18, green:0.77, blue:0.71, alpha: 0.15)
//			let gestureBarTint 				= UIColor(named: "greenPastel")!
//			let blurEffect 					= UIBlurEffect(style: .dark)
//			let shadowColor 				= UIColor.black
//			let shadowOpacity: Float 		= 0.3
//			let shadowRadius: CGFloat 		= 7.0
//			let separatorColor 				= UIColor(white: 1, alpha: 0.1)
//			public init() {}
//		}
//		return PlusOneTheme()
//	}
	
	static var dark: MenuTheme {
		struct PlusOneTheme: MenuTheme {
			let font 						= UIFont.systemFont(ofSize: 16, weight: .medium)
			let textColor 					= ThemeManager.currentTheme().tintColor
			var brightTintColor: UIColor {
				switch ThemeManager.currentTheme(){
				case .ocean:
					return .black
				case .sunrise:
					return .white
				}
			}
			var darkTintColor: UIColor {
				switch ThemeManager.currentTheme(){
				case .ocean:
					return .black
				case .sunrise:
					return .white
				}
			}
			var highlightedTextColor: UIColor {
				switch ThemeManager.currentTheme(){
				case .ocean:
					return .white
				case .sunrise:
					return .black
				}
			}
			let highlightedBackgroundColor 	= ThemeManager.currentTheme().tintColor
			let backgroundTint 				= UIColor(red:0.18, green:0.77, blue:0.71, alpha: 0.15)
			let gestureBarTint 				= ThemeManager.currentTheme().tintColor
			var blurEffect: UIBlurEffect {
				switch ThemeManager.currentTheme(){
				case .ocean:
					return UIBlurEffect(style: .dark)
				case .sunrise:
					return UIBlurEffect(style: .light)
				}
			}
			var shadowColor: UIColor {
				switch ThemeManager.currentTheme(){
				case .ocean:
					return .black
				case .sunrise:
					return .white
				}
			}
			let shadowOpacity: Float 		= 0.3
			let shadowRadius: CGFloat 		= 7.0
			let separatorColor 				= UIColor(white: 1, alpha: 0.1)
			public init() {}
		}
		return PlusOneTheme()
	}

}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"


// This will let you use a theme in the app.
class ThemeManager {
	
	// ThemeManager
	static func currentTheme() -> Theme {
		if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
			return Theme(rawValue: storedTheme)!
		} else {
			return .ocean
		}
	}
	
	static func applyTheme(theme: Theme) {
		// First persist the selected theme using NSUserDefaults.
		UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
		UserDefaults.standard.synchronize()
		
		// You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
		let sharedApplication = UIApplication.shared
		sharedApplication.delegate?.window??.tintColor = theme.tintColor
		
		UINavigationBar.appearance().barStyle = theme.barStyle
//		UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
//		UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
//		UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
		
		UITabBar.appearance().barStyle = theme.barStyle
//		UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
		
//		let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
//		let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
//		UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
		
//		let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
//			.resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//		let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
//			.withRenderingMode(.alwaysTemplate)
//			.resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
		
//		UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
//		UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
//		
//		UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
//		UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
//		UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
//		UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
//		UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
//		
//		UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
//		UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
//			.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
//		UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
//			.withRenderingMode(.alwaysTemplate)
//			.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
		
		UISwitch.appearance().onTintColor = theme.tintColor.withAlphaComponent(0.3)
		UISwitch.appearance().thumbTintColor = theme.tintColor
	}
	
	static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
}

