Dynamic Gradient
======================

![Dynamic Gradient](https://github.com/MattMcEachern/DynamicGradient/blob/master/DynamicGradient.gif)

# Installation

Add the file `DynamicGradient.swift` to your Xcode project.

# Usage

Tweak the constants at the top of the file to modify the wave motion.

## Initialization
``` swift
override func viewDidLoad() {
	let background = DynamicGradient(frame: self.view.bounds)
	self.view.addSubview(background)
}
```

## Toggling
``` swift
background.startAnimating()
background.stopAnimatiing()
```