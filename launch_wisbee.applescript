#!/usr/bin/osascript

-- Launch Xcode and create new project
tell application "Xcode"
    activate
    delay 2
end tell

-- Use System Events to create new project
tell application "System Events"
    tell process "Xcode"
        -- Press Cmd+Shift+N for new project
        keystroke "n" using {command down, shift down}
        delay 3
        
        -- Select iOS App template
        click button "App" of window 1
        delay 1
        click button "Next" of window 1
        delay 2
        
        -- Fill in project details
        set value of text field 1 of window 1 to "WisbeeApp"
        delay 1
        
        -- Click Next
        click button "Next" of window 1
        delay 2
        
        -- Click Create (save in default location)
        click button "Create" of window 1
        delay 5
    end tell
end tell

display dialog "Xcode project created! Please:
1. Replace ContentView.swift with the code from /Users/yuki/wisbee-iOS/WisbeeApp/ContentView.swift
2. Replace WisbeeAppApp.swift with the code from /Users/yuki/wisbee-iOS/WisbeeApp/WisbeeApp.swift  
3. Press Cmd+R to run the app" buttons {"OK"}