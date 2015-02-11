install: 
	@xcodebuild -scheme QLGradle
	@qlmanage -r 

clean:
	@rm -rf ~/Library/QuickLook/QLGradle.qlgenerator
