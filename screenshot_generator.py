#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
🌸 ChirAI Professional Screenshot Generator
App Store品質のスクリーンショットを自動生成
"""

import os
import json
from datetime import datetime
from PIL import Image, ImageDraw, ImageFont
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib import font_manager

class ChirAIScreenshotGenerator:
    def __init__(self):
        self.sakura_pink = '#FF6B9D'
        self.teal = '#4ECDC4'
        self.sky_blue = '#45B7D1'
        self.charcoal = '#2C3E50'
        self.pearl = '#F8F9FA'
        
        # iPhone screen sizes for App Store
        self.screen_sizes = {
            'iphone-6.7': (1290, 2796),  # iPhone 15 Pro Max
            'iphone-6.5': (1284, 2778),  # iPhone 15 Plus
            'iphone-5.5': (1242, 2208)   # iPhone 8 Plus
        }
        
    def create_chat_interface(self, size_key, conversation_type='japanese'):
        """Create a beautiful chat interface screenshot"""
        width, height = self.screen_sizes[size_key]
        
        # Create figure with iPhone proportions
        fig, ax = plt.subplots(figsize=(width/200, height/200), dpi=200)
        fig.patch.set_facecolor(self.pearl)
        
        # Remove axes and margins
        ax.set_xlim(0, width)
        ax.set_ylim(0, height)
        ax.axis('off')
        plt.subplots_adjust(left=0, right=1, top=1, bottom=0)
        
        # Status bar (iPhone style)
        self.draw_status_bar(ax, width, height)
        
        # App header
        self.draw_app_header(ax, width, height)
        
        # Chat messages
        if conversation_type == 'japanese':
            self.draw_japanese_conversation(ax, width, height)
        else:
            self.draw_english_conversation(ax, width, height)
        
        # Input area
        self.draw_input_area(ax, width, height)
        
        # Save screenshot
        filename = f"screenshots/professional/{size_key}/chat_{conversation_type}_{width}x{height}.png"
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        plt.savefig(filename, dpi=200, bbox_inches='tight', 
                   facecolor=self.pearl, edgecolor='none')
        plt.close()
        
        return filename
    
    def draw_status_bar(self, ax, width, height):
        """Draw iPhone status bar"""
        status_height = 60
        
        # Status bar background
        status_bar = patches.Rectangle((0, height - status_height), width, status_height,
                                     facecolor='white', alpha=0.95)
        ax.add_patch(status_bar)
        
        # Time (9:41 AM - Apple standard)
        ax.text(50, height - 30, "9:41", fontsize=18, fontweight='bold', 
               color=self.charcoal, va='center')
        
        # Battery, WiFi, Signal (right side)
        ax.text(width - 50, height - 30, "100%  📶  📶", fontsize=14, 
               color=self.charcoal, va='center', ha='right')
    
    def draw_app_header(self, ax, width, height):
        """Draw ChirAI app header"""
        header_height = 120
        header_y = height - 180
        
        # Header background with gradient effect
        header_bg = patches.Rectangle((0, header_y), width, header_height,
                                    facecolor=self.sakura_pink, alpha=0.1)
        ax.add_patch(header_bg)
        
        # ChirAI logo and title
        ax.text(40, header_y + 80, "🌸 ChirAI", fontsize=32, fontweight='bold',
               color=self.sakura_pink, va='center')
        
        ax.text(40, header_y + 40, "ローカルAIチャット", fontsize=16,
               color=self.charcoal, va='center', alpha=0.7)
        
        # Settings button
        settings_btn = patches.Circle((width - 60, header_y + 60), 25,
                                    facecolor=self.teal, alpha=0.2)
        ax.add_patch(settings_btn)
        ax.text(width - 60, header_y + 60, "⚙️", fontsize=20, 
               ha='center', va='center')
    
    def draw_japanese_conversation(self, ax, width, height):
        """Draw Japanese conversation example"""
        messages = [
            {
                "text": "🌸 ChirAIへようこそ！どのようにお手伝いできますか？",
                "is_user": False,
                "y_pos": height - 400
            },
            {
                "text": "プログラミングについて教えてください。SwiftUIの基本的な使い方を知りたいです。",
                "is_user": True,
                "y_pos": height - 550
            },
            {
                "text": "SwiftUIは素晴らしい選択ですね！宣言的UIフレームワークで、iOSアプリ開発を大幅に簡素化できます。\n\n基本的な構造:\n• View プロトコルを実装\n• body プロパティでUIを定義\n• @State で状態管理\n• プレビュー機能で即座確認\n\n何か具体的に知りたい部分はありますか？",
                "is_user": False,
                "y_pos": height - 800
            },
            {
                "text": "ありがとうございます！とても分かりやすい説明でした。",
                "is_user": True,
                "y_pos": height - 1000
            }
        ]
        
        for msg in messages:
            self.draw_message_bubble(ax, width, msg["text"], msg["is_user"], msg["y_pos"])
    
    def draw_english_conversation(self, ax, width, height):
        """Draw English conversation example"""
        messages = [
            {
                "text": "🌸 Welcome to ChirAI! How can I assist you today?",
                "is_user": False,
                "y_pos": height - 400
            },
            {
                "text": "Tell me about the importance of privacy in AI applications.",
                "is_user": True,
                "y_pos": height - 550
            },
            {
                "text": "Privacy in AI is absolutely crucial! Here's why:\n\n• Personal Data Protection: AI processes sensitive information\n• Trust Building: Users need confidence in your application\n• Legal Compliance: GDPR, CCPA, and other regulations\n• Ethical Responsibility: Respecting user autonomy\n\nChirAI addresses this by processing everything locally - no data ever leaves your device!",
                "is_user": False,
                "y_pos": height - 800
            },
            {
                "text": "That's exactly what I was looking for. Local processing is the future!",
                "is_user": True,
                "y_pos": height - 1000
            }
        ]
        
        for msg in messages:
            self.draw_message_bubble(ax, width, msg["text"], msg["is_user"], msg["y_pos"])
    
    def draw_message_bubble(self, ax, width, text, is_user, y_pos):
        """Draw individual message bubble"""
        max_width = width * 0.7
        bubble_padding = 20
        
        if is_user:
            # User message (right side, pink)
            bubble_x = width * 0.25
            bubble_color = self.sakura_pink
            text_color = 'white'
            bubble_alpha = 0.9
            text_align = 'right'
        else:
            # AI message (left side, light gray)
            bubble_x = 40
            bubble_color = self.pearl
            text_color = self.charcoal
            bubble_alpha = 1.0
            text_align = 'left'
            
            # Add ChirAI label for AI messages
            ax.text(bubble_x, y_pos + 40, "🌸 ChirAI", fontsize=12, 
                   color=self.sakura_pink, fontweight='bold')
        
        # Calculate bubble dimensions based on text
        lines = text.split('\n')
        line_height = 20
        bubble_height = len(lines) * line_height + bubble_padding * 2
        bubble_width = min(max_width, max(len(line) * 8 for line in lines) + bubble_padding * 2)
        
        # Draw bubble background
        bubble = patches.FancyBboxPatch(
            (bubble_x, y_pos - bubble_height), bubble_width, bubble_height,
            boxstyle="round,pad=10", facecolor=bubble_color, alpha=bubble_alpha,
            edgecolor='none'
        )
        ax.add_patch(bubble)
        
        # Draw text
        for i, line in enumerate(lines):
            text_y = y_pos - bubble_padding - (i + 1) * line_height
            ax.text(bubble_x + bubble_padding, text_y, line, 
                   fontsize=14, color=text_color, va='center')
    
    def draw_input_area(self, ax, width, height):
        """Draw input area at bottom"""
        input_height = 100
        input_y = 50
        
        # Input background
        input_bg = patches.Rectangle((20, input_y), width - 40, input_height,
                                   facecolor='white', alpha=0.9,
                                   edgecolor=self.sakura_pink, linewidth=2)
        ax.add_patch(input_bg)
        
        # Placeholder text
        ax.text(40, input_y + 50, "メッセージを入力...", fontsize=16,
               color=self.charcoal, alpha=0.5, va='center')
        
        # Send button
        send_btn = patches.Circle((width - 70, input_y + 50), 30,
                                facecolor=self.sakura_pink, alpha=0.9)
        ax.add_patch(send_btn)
        ax.text(width - 70, input_y + 50, "📤", fontsize=20,
               ha='center', va='center', color='white')
    
    def create_agents_list(self, size_key):
        """Create agents list screenshot"""
        width, height = self.screen_sizes[size_key]
        
        fig, ax = plt.subplots(figsize=(width/200, height/200), dpi=200)
        fig.patch.set_facecolor(self.pearl)
        
        ax.set_xlim(0, width)
        ax.set_ylim(0, height)
        ax.axis('off')
        plt.subplots_adjust(left=0, right=1, top=1, bottom=0)
        
        # Status bar and header
        self.draw_status_bar(ax, width, height)
        
        # Agents header
        ax.text(40, height - 200, "🤖 AI エージェント", fontsize=32, fontweight='bold',
               color=self.sakura_pink)
        ax.text(40, height - 240, "14種類のモデルから選択", fontsize=16,
               color=self.charcoal, alpha=0.7)
        
        # Agent cards
        agents = [
            {"name": "qwen2.5:3b", "desc": "日本語に最適化されたモデル", "status": "推奨"},
            {"name": "gemma3:1b", "desc": "高速英語処理モデル", "status": "推奨"},
            {"name": "llama3:8b", "desc": "バランス型汎用モデル", "status": "良い"},
            {"name": "codellama:7b", "desc": "プログラミング特化", "status": "実験的"},
            {"name": "mistral:7b", "desc": "多言語対応モデル", "status": "良い"}
        ]
        
        for i, agent in enumerate(agents):
            y_pos = height - 350 - (i * 120)
            self.draw_agent_card(ax, width, agent, y_pos)
        
        filename = f"screenshots/professional/{size_key}/agents_list_{width}x{height}.png"
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        plt.savefig(filename, dpi=200, bbox_inches='tight',
                   facecolor=self.pearl, edgecolor='none')
        plt.close()
        
        return filename
    
    def draw_agent_card(self, ax, width, agent, y_pos):
        """Draw individual agent card"""
        card_height = 100
        card_width = width - 80
        
        # Card background
        card = patches.FancyBboxPatch(
            (40, y_pos), card_width, card_height,
            boxstyle="round,pad=10", facecolor='white', alpha=0.9,
            edgecolor=self.sakura_pink, linewidth=1
        )
        ax.add_patch(card)
        
        # Agent icon
        ax.text(70, y_pos + 70, "🤖", fontsize=24, va='center')
        
        # Agent name
        ax.text(120, y_pos + 75, agent["name"], fontsize=20, fontweight='bold',
               color=self.charcoal, va='center')
        
        # Description
        ax.text(120, y_pos + 45, agent["desc"], fontsize=14,
               color=self.charcoal, alpha=0.7, va='center')
        
        # Status badge
        status_colors = {
            "推奨": self.sakura_pink,
            "良い": self.teal,
            "実験的": self.sky_blue
        }
        
        status_color = status_colors.get(agent["status"], self.charcoal)
        badge = patches.FancyBboxPatch(
            (width - 150, y_pos + 60), 80, 30,
            boxstyle="round,pad=5", facecolor=status_color, alpha=0.2,
            edgecolor=status_color, linewidth=1
        )
        ax.add_patch(badge)
        
        ax.text(width - 110, y_pos + 75, agent["status"], fontsize=12,
               color=status_color, ha='center', va='center', fontweight='bold')
    
    def create_all_screenshots(self):
        """Generate all professional screenshots"""
        print("🌸 ChirAI Professional Screenshots Generation Started...")
        
        generated_files = []
        
        for size_key in self.screen_sizes.keys():
            print(f"\n📱 Generating {size_key} screenshots...")
            
            # Chat screenshots
            japanese_chat = self.create_chat_interface(size_key, 'japanese')
            english_chat = self.create_chat_interface(size_key, 'english')
            agents_list = self.create_agents_list(size_key)
            
            generated_files.extend([japanese_chat, english_chat, agents_list])
            
            print(f"✅ {size_key}: 3 screenshots generated")
        
        print(f"\n🎉 Total screenshots generated: {len(generated_files)}")
        print("\n📁 Generated files:")
        for file in generated_files:
            print(f"   - {file}")
        
        return generated_files

def main():
    """Main execution"""
    generator = ChirAIScreenshotGenerator()
    
    try:
        generated_files = generator.create_all_screenshots()
        
        # Create summary report
        summary = {
            "generation_time": datetime.now().isoformat(),
            "total_screenshots": len(generated_files),
            "files": generated_files,
            "quality": "App Store Professional",
            "sizes_generated": list(generator.screen_sizes.keys())
        }
        
        with open("screenshots/professional/generation_report.json", "w", encoding="utf-8") as f:
            json.dump(summary, f, indent=2, ensure_ascii=False)
        
        print("\n🌸 Professional screenshot generation completed successfully!")
        print("📊 Summary report saved to: screenshots/professional/generation_report.json")
        
    except Exception as e:
        print(f"❌ Error generating screenshots: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())