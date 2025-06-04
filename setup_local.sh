#!/bin/bash

echo "🚀 Setting up Wisbee iOS Local Development Environment"
echo "======================================================"

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama is not installed. Please install it first:"
    echo "   curl -fsSL https://ollama.ai/install.sh | sh"
    exit 1
fi

# Start Ollama if not running
if ! pgrep -x "ollama" > /dev/null; then
    echo "🔄 Starting Ollama service..."
    ollama serve &
    sleep 5
else
    echo "✅ Ollama is already running"
fi

# Check and pull required models
echo -e "\n📦 Checking required models..."
MODELS=("gemma3:1b" "qwen2.5:3b")

for model in "${MODELS[@]}"; do
    if ollama list | grep -q "$model"; then
        echo "✅ Model $model is already installed"
    else
        echo "📥 Pulling $model..."
        ollama pull "$model"
    fi
done

# Test Ollama API
echo -e "\n🧪 Testing Ollama API..."
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "✅ Ollama API is accessible"
else
    echo "❌ Ollama API is not accessible"
    exit 1
fi

# Install iOS development dependencies
echo -e "\n📱 Checking iOS development tools..."
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store"
    exit 1
else
    echo "✅ Xcode is installed"
fi

# Check for iOS simulators
echo -e "\n📱 Available iOS Simulators:"
xcrun simctl list devices | grep -E "iPhone|iPad" | grep -v "unavailable" | head -10

echo -e "\n✨ Local development environment is ready!"
echo "Next steps:"
echo "1. Run E2E tests: ./run_e2e_tests.sh"
echo "2. Launch app: open WisbeeApp/WisbeeApp.xcodeproj"