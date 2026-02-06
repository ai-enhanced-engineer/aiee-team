# Angular AI Examples

Production-ready AI integration patterns for Angular 21+.

## AI Chat Component

```typescript
import { Component, signal, computed, inject, effect } from '@angular/core';
import { FormsModule } from '@angular/forms';

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
}

@Component({
  selector: 'app-ai-chat',
  standalone: true,
  imports: [FormsModule],
  template: `
    <div class="chat-container" role="log" aria-live="polite">
      <!-- Messages -->
      <div class="messages">
        @for (msg of messages(); track msg.id) {
          <article
            class="message"
            [class.user]="msg.role === 'user'"
            [class.assistant]="msg.role === 'assistant'"
            [attr.aria-label]="msg.role + ' message'">
            <div class="content">{{ msg.content }}</div>
            <time class="timestamp">{{ formatTime(msg.timestamp) }}</time>
          </article>
        } @empty {
          <p class="empty-state">Start a conversation...</p>
        }

        @if (isStreaming()) {
          <article class="message assistant streaming">
            <div class="content">{{ streamingContent() }}</div>
            <span class="typing-indicator" aria-label="AI is typing">...</span>
          </article>
        }
      </div>

      <!-- Input -->
      <form (submit)="sendMessage($event)" class="input-form">
        <input
          type="text"
          [(ngModel)]="inputText"
          name="message"
          placeholder="Type your message..."
          [disabled]="isStreaming()"
          aria-label="Message input"
        />
        <button
          type="submit"
          [disabled]="!canSend()"
          aria-label="Send message">
          Send
        </button>
      </form>
    </div>
  `,
  styles: [`
    .chat-container { display: flex; flex-direction: column; height: 100%; }
    .messages { flex: 1; overflow-y: auto; padding: 1rem; }
    .message { margin-bottom: 1rem; padding: 0.75rem; border-radius: 8px; }
    .message.user { background: var(--primary-100); margin-left: 20%; }
    .message.assistant { background: var(--surface-100); margin-right: 20%; }
    .streaming .typing-indicator { animation: pulse 1s infinite; }
    .input-form { display: flex; gap: 0.5rem; padding: 1rem; }
    .input-form input { flex: 1; padding: 0.75rem; }
  `]
})
export class AIChatComponent {
  private chatService = inject(ChatService);

  messages = signal<Message[]>([]);
  inputText = signal('');
  isStreaming = signal(false);
  streamingContent = signal('');

  canSend = computed(() =>
    this.inputText().trim().length > 0 && !this.isStreaming()
  );

  async sendMessage(event: Event) {
    event.preventDefault();
    if (!this.canSend()) return;

    const userMessage: Message = {
      id: crypto.randomUUID(),
      role: 'user',
      content: this.inputText(),
      timestamp: new Date()
    };

    this.messages.update(msgs => [...msgs, userMessage]);
    this.inputText.set('');
    this.isStreaming.set(true);
    this.streamingContent.set('');

    try {
      let fullResponse = '';

      for await (const chunk of this.chatService.streamChat(userMessage.content)) {
        fullResponse += chunk;
        this.streamingContent.set(fullResponse);
      }

      const assistantMessage: Message = {
        id: crypto.randomUUID(),
        role: 'assistant',
        content: fullResponse,
        timestamp: new Date()
      };

      this.messages.update(msgs => [...msgs, assistantMessage]);
    } finally {
      this.isStreaming.set(false);
      this.streamingContent.set('');
    }
  }

  formatTime(date: Date): string {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
}
```
