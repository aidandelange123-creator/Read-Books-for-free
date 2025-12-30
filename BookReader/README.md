# Multilingual Book Reader

A .NET 8 application that allows reading books in multiple languages with automatic language detection.

## Features

- Supports 9 languages: English, Spanish, French, German, Chinese, Japanese, Russian, Arabic, and Hindi
- Automatic language detection based on text content
- Simple command-line interface
- Auto-installs .NET 8 if not present

## Supported Languages

1. English
2. Spanish
3. French
4. German
5. Chinese
6. Japanese
7. Russian
8. Arabic
9. Hindi

## How to Run

Simply run the batch file `run_bookreader.bat` which will:
1. Check if .NET 8 is installed
2. If not installed, automatically download and install .NET 8
3. Build and run the application

## Adding Books

Place your .txt books in the `Books` directory. The application will automatically detect and list them.

## Languages Detection

The application detects languages based on character sets:
- Latin characters for English, Spanish, French, German
- Chinese characters for Chinese
- Hiragana/Katakana for Japanese
- Cyrillic for Russian
- Arabic script for Arabic
- Devanagari script for Hindi