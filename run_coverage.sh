#!/bin/bash

echo "📊 Running Tests with Coverage Analysis..."
echo "=========================================="

# Use the Homebrew Ruby to run Fastlane
/opt/homebrew/Library/Homebrew/vendor/portable-ruby/3.4.5/bin/bundle exec fastlane coverage

echo ""
echo "✅ Coverage analysis completed!"
echo ""
echo "📁 View your coverage reports:"
echo "   • HTML Report: test_output/report.html"
echo "   • Text Report: test_output/coverage.txt"
echo "   • JUnit Report: test_output/report.xml"
echo ""
echo "🌐 To view HTML report:"
echo "   open test_output/report.html"
echo ""
echo "📱 To view in Xcode:"
echo "   Open DynaQuiz.xcworkspace → Report Navigator (⌘+9) → Coverage tab"
