#!/usr/bin/env python3
import json
import requests
import time
from datetime import datetime

# MT-Bench Japanese test cases
MT_BENCH_JAPANESE = [
    # Writing & Reasoning
    {
        "category": "Writing",
        "question": "「人工知能が私たちの日常生活を変える」というテーマで、200文字程度の短いエッセイを書いてください。",
        "type": "creative_writing"
    },
    {
        "category": "Math",
        "question": "太郎君は100円のお菓子を3個と、150円のジュースを2本買いました。500円札で支払った場合、おつりはいくらですか？計算過程も示してください。",
        "type": "math_reasoning"
    },
    {
        "category": "Reasoning",
        "question": "次の文章の論理的な問題点を指摘してください：「すべての鳥は飛べる。ペンギンは鳥である。したがって、ペンギンは飛べる。」",
        "type": "logical_reasoning"
    },
    {
        "category": "Coding",
        "question": "Pythonで、リストの中から重複する要素を削除する関数を書いてください。",
        "type": "code_generation"
    },
    {
        "category": "Knowledge",
        "question": "富士山について、高さ、場所、文化的意義を含めて説明してください。",
        "type": "factual_knowledge"
    },
    {
        "category": "Translation",
        "question": "次の文を英語に翻訳してください：「昨日、友達と一緒に新しいラーメン屋に行きました。とても美味しかったです。」",
        "type": "translation"
    },
    {
        "category": "Summarization",
        "question": "AIの発展により、多くの仕事が自動化される可能性があります。これには良い面と悪い面があり、新しい仕事が生まれる一方で、従来の仕事がなくなる可能性もあります。この文章を30文字以内で要約してください。",
        "type": "summarization"
    },
    {
        "category": "Role-play",
        "question": "あなたは親切な店員です。お客様から「この商品の使い方がわからない」と言われました。どのように対応しますか？",
        "type": "roleplay"
    }
]

class LLMTester:
    def __init__(self, base_url="http://localhost:11434/v1"):
        self.base_url = base_url
        self.results = []
        
    def test_model(self, model_name, test_cases):
        print(f"\n🧪 Testing model: {model_name}")
        print("=" * 60)
        
        model_results = {
            "model": model_name,
            "timestamp": datetime.now().isoformat(),
            "tests": []
        }
        
        for i, test in enumerate(test_cases, 1):
            print(f"\n📝 Test {i}/{len(test_cases)} - {test['category']}")
            print(f"Question: {test['question'][:50]}...")
            
            start_time = time.time()
            response = self.send_request(model_name, test['question'])
            end_time = time.time()
            
            response_time = end_time - start_time
            
            if response:
                print(f"✅ Response received in {response_time:.2f}s")
                print(f"Response preview: {response[:100]}...")
                
                # Analyze response quality
                quality_score = self.analyze_response_quality(
                    test['question'], 
                    response, 
                    test['type']
                )
                
                model_results["tests"].append({
                    "category": test['category'],
                    "question": test['question'],
                    "response": response,
                    "response_time": response_time,
                    "quality_score": quality_score,
                    "type": test['type']
                })
            else:
                print("❌ Failed to get response")
                model_results["tests"].append({
                    "category": test['category'],
                    "question": test['question'],
                    "response": None,
                    "error": "Failed to get response",
                    "response_time": response_time
                })
        
        self.results.append(model_results)
        return model_results
    
    def send_request(self, model, prompt):
        try:
            response = requests.post(
                f"{self.base_url}/chat/completions",
                json={
                    "model": model,
                    "messages": [{"role": "user", "content": prompt}],
                    "temperature": 0.7,
                    "max_tokens": 500
                },
                timeout=30
            )
            
            if response.status_code == 200:
                data = response.json()
                return data['choices'][0]['message']['content']
            else:
                print(f"Error: HTTP {response.status_code}")
                return None
                
        except Exception as e:
            print(f"Error: {e}")
            return None
    
    def analyze_response_quality(self, question, response, test_type):
        """Simple quality analysis"""
        score = 0
        max_score = 10
        
        # Basic checks
        if response and len(response) > 10:
            score += 2  # Response exists and has content
        
        # Japanese language check
        if any(ord(char) > 0x3000 for char in response):
            score += 2  # Contains Japanese characters
        
        # Type-specific checks
        if test_type == "math_reasoning":
            if any(char in response for char in "0123456789+-*/="):
                score += 2  # Contains numbers/math
        elif test_type == "code_generation":
            if "def" in response or "function" in response:
                score += 2  # Contains code structure
        elif test_type == "translation":
            if any(ord(char) < 128 for char in response):
                score += 2  # Contains English characters
        else:
            score += 2  # Default points for other types
        
        # Length appropriateness
        if 50 < len(response) < 1000:
            score += 2  # Reasonable length
        elif len(response) > 20:
            score += 1  # At least some content
        
        # Coherence check (simple)
        if response.count('。') > 0 or response.count('.') > 0:
            score += 2  # Has sentence endings
        
        return min(score, max_score)
    
    def generate_report(self):
        print("\n" + "=" * 60)
        print("📊 TEST RESULTS SUMMARY")
        print("=" * 60)
        
        for model_result in self.results:
            model = model_result['model']
            tests = model_result['tests']
            
            total_tests = len(tests)
            successful_tests = sum(1 for t in tests if t.get('response'))
            avg_response_time = sum(t.get('response_time', 0) for t in tests) / total_tests
            avg_quality = sum(t.get('quality_score', 0) for t in tests) / total_tests
            
            print(f"\n🤖 Model: {model}")
            print(f"Success Rate: {successful_tests}/{total_tests} ({successful_tests/total_tests*100:.1f}%)")
            print(f"Avg Response Time: {avg_response_time:.2f}s")
            print(f"Avg Quality Score: {avg_quality:.1f}/10")
            
            # Category breakdown
            print("\nCategory Performance:")
            categories = {}
            for test in tests:
                cat = test['category']
                if cat not in categories:
                    categories[cat] = []
                categories[cat].append(test.get('quality_score', 0))
            
            for cat, scores in categories.items():
                avg_cat_score = sum(scores) / len(scores)
                print(f"  {cat}: {avg_cat_score:.1f}/10")
        
        # Save detailed results
        with open('/Users/yuki/wisbee-iOS/mt_bench_results.json', 'w', encoding='utf-8') as f:
            json.dump(self.results, f, ensure_ascii=False, indent=2)
        
        print(f"\n💾 Detailed results saved to: mt_bench_results.json")

def main():
    tester = LLMTester()
    
    # Test available models
    models_to_test = [
        "gemma3:1b",
        "gemma3:4b", 
        "jaahas/qwen3-abliterated:0.6b"
    ]
    
    for model in models_to_test:
        try:
            tester.test_model(model, MT_BENCH_JAPANESE)
        except Exception as e:
            print(f"Error testing {model}: {e}")
    
    # Generate final report
    tester.generate_report()

if __name__ == "__main__":
    main()