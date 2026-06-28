# Security notes

This generated project is a clean, auditable iOS 16 WKWebView wrapper.

It intentionally avoids:

- JavaScript injection
- reading cookies from the WebView
- sending credentials to any custom server
- proxying ChatGPT traffic
- loading arbitrary non OpenAI domains inside the WebView

The WebView starts at `https://chatgpt.com/` and allows navigation only to a small OpenAI related domain allowlist in `SecureChatGPTWebView.swift`.

This project does not prove that any upstream release IPA is safe. It is a clean replacement project that can be built and audited from source.
