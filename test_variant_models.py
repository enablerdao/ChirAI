#!/usr/bin/env python3
import json
import requests
import time
from datetime import datetime

# Variant models to test
VARIANT_MODELS = [
    "variant-iter1-8262349e:latest",  # Gemma3 4.3B variant
    "variant-iter1-25a8cae8:latest"   # Qwen3 596M variant
]

# Quick Japanese tests
QUICK_TESTS = [
    {
        "category": "General",
        "question": "こんにちは。今日はいい天気ですね。",
        "type": "greeting"
    },
    {
        "category": "Math",
        "question": "100 + 200 = ?",
        "type": "simple_math"
    },
    {
        "category": "Writing",
        "question": "桜について50文字で説明してください。",
        "type": "short_writing"
    },
    {
        "category": "Translation",
        "question": "「ありがとう」を英語に翻訳してください。",
        "type": "translation"
    },
    {
        "category": "Reasoning",
        "question": "なぜ空は青いのですか？簡単に説明してください。",
        "type": "explanation"
    }
]

def test_variant_models():
    base_url = "http://localhost:11434/v1/chat/completions"
    results = {}
    
    print("🧪 Testing Variant Models for Japanese Support")
    print("=" * 60)
    
    for model in VARIANT_MODELS:
        print(f"\n📊 Testing: {model}")
        model_type = "Gemma3" if "8262349e" in model else "Qwen3"
        print(f"   Type: {model_type} variant")
        
        model_results = {
            "model": model,
            "type": model_type,
            "tests": [],
            "avg_response_time": 0,
            "japanese_support": True
        }
        
        total_time = 0
        
        for test in QUICK_TESTS:
            print(f"\n   📝 {test['category']}: ", end="", flush=True)
            
            start_time = time.time()
            try:
                response = requests.post(
                    base_url,
                    json={
                        "model": model,
                        "messages": [{"role": "user", "content": test['question']}],
                        "temperature": 0.7,
                        "max_tokens": 200
                    },
                    timeout=30
                )
                
                if response.status_code == 200:
                    data = response.json()
                    content = data['choices'][0]['message']['content']
                    response_time = time.time() - start_time
                    total_time += response_time
                    
                    # Check for Japanese characters
                    has_japanese = any(ord(char) > 0x3000 for char in content)
                    
                    print(f"✅ ({response_time:.1f}s)")
                    print(f"      Response: {content[:100]}...")
                    
                    model_results["tests"].append({
                        "category": test['category'],
                        "success": True,
                        "response_time": response_time,
                        "has_japanese": has_japanese,
                        "preview": content[:100]
                    })
                else:
                    print(f"❌ Error {response.status_code}")
                    model_results["tests"].append({
                        "category": test['category'],
                        "success": False,
                        "error": f"HTTP {response.status_code}"
                    })
                    
            except Exception as e:
                print(f"❌ {str(e)}")
                model_results["tests"].append({
                    "category": test['category'],
                    "success": False,
                    "error": str(e)
                })
        
        # Calculate average response time
        successful_tests = [t for t in model_results["tests"] if t.get("success")]
        if successful_tests:
            model_results["avg_response_time"] = total_time / len(successful_tests)
            
        # Check overall Japanese support
        japanese_tests = [t for t in successful_tests if t.get("has_japanese")]
        model_results["japanese_support"] = len(japanese_tests) > len(successful_tests) / 2
        
        results[model] = model_results
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 SUMMARY")
    print("=" * 60)
    
    for model, data in results.items():
        success_rate = sum(1 for t in data["tests"] if t.get("success")) / len(data["tests"]) * 100
        print(f"\n{model}:")
        print(f"  Type: {data['type']} variant")
        print(f"  Success Rate: {success_rate:.0f}%")
        print(f"  Avg Response Time: {data['avg_response_time']:.1f}s")
        print(f"  Japanese Support: {'✅ Yes' if data['japanese_support'] else '❌ No'}")
    
    # Save results
    with open('/Users/yuki/wisbee-iOS/variant_models_test.json', 'w', encoding='utf-8') as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
    
    print(f"\n💾 Results saved to: variant_models_test.json")
    
    # Recommendation
    print("\n🎯 RECOMMENDATION:")
    if results.get("variant-iter1-8262349e:latest", {}).get("japanese_support"):
        print("variant-iter1-8262349e:latest (Gemma3 4.3B) can be used as alternative to qwen3-4b-instruct")
    else:
        print("These variant models may not be suitable for Japanese tasks")

if __name__ == "__main__":
    test_variant_models()