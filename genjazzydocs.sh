jazzy --min-acl public \
-c \
--exclude Demo/ViewController.swift,Demo/AppDelegate.swift \
--copyright "Max Kramer" \
--author "Max Kramer" \
--author_url "http://maxkramer.co" \
--github_url https://github.com/MaxKramer/Logger \
--theme fullwidth \
-x -project,Demo.xcodeproj \
-o ../docs \
--readme ../README.md
