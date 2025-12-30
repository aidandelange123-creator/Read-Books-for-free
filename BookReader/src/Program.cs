using System;
using System.IO;
using System.Text;
using System.Globalization;

namespace BookReader
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== Multilingual Book Reader ===");
            Console.WriteLine("Auto-detecting .NET version...");
            
            // Language detection and support
            var supportedLanguages = new string[] { 
                "English", "Spanish", "French", "German", 
                "Chinese", "Japanese", "Russian", "Arabic", "Hindi" 
            };
            
            Console.WriteLine($"Supported languages: {string.Join(", ", supportedLanguages)}");
            
            // List available books
            var books = Directory.GetFiles("../Books", "*.txt");
            if (books.Length > 0)
            {
                Console.WriteLine("\nAvailable books:");
                for (int i = 0; i < books.Length; i++)
                {
                    Console.WriteLine($"{i + 1}. {Path.GetFileName(books[i])}");
                }
                
                Console.Write("\nSelect a book to read (enter number): ");
                if (int.TryParse(Console.ReadLine(), out int selection) && 
                    selection > 0 && selection <= books.Length)
                {
                    ReadBook(books[selection - 1]);
                }
                else
                {
                    Console.WriteLine("Invalid selection.");
                }
            }
            else
            {
                Console.WriteLine("No books found in the Books directory. Add some .txt files to get started.");
            }
        }
        
        static void ReadBook(string bookPath)
        {
            try
            {
                string content = File.ReadAllText(bookPath, Encoding.UTF8);
                Console.WriteLine($"\n--- Reading: {Path.GetFileName(bookPath)} ---\n");
                
                // Detect language based on file name or content
                string detectedLanguage = DetectLanguage(content);
                Console.WriteLine($"Detected language: {detectedLanguage}");
                
                // Display content
                Console.WriteLine(content);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error reading book: {ex.Message}");
            }
        }
        
        static string DetectLanguage(string text)
        {
            // Simple language detection based on character sets
            int english = 0, spanish = 0, french = 0, german = 0;
            int chinese = 0, japanese = 0, russian = 0, arabic = 0, hindi = 0;
            
            foreach (char c in text.Substring(0, Math.Min(text.Length, 1000))) // Check first 1000 chars
            {
                if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z') english++;
                else if ("áéíóúñ".Contains(char.ToLower(c))) spanish++;
                else if ("àâäéèêëïîôöùûüÿç".Contains(char.ToLower(c))) french++;
                else if ("äöüß".Contains(char.ToLower(c))) german++;
                else if (c >= '\u4e00' && c <= '\u9fff') chinese++; // Chinese characters
                else if (c >= '\u3040' && c <= '\u309f' || c >= '\u30a0' && c <= '\u30ff') japanese++; // Hiragana/Katakana
                else if (c >= '\u0400' && c <= '\u04ff') russian++; // Cyrillic
                else if (c >= '\u0600' && c <= '\u06ff') arabic++; // Arabic
                else if (c >= '\u0900' && c <= '\u097f') hindi++; // Devanagari script
            }
            
            // Return the language with highest count
            var langCounts = new[] { 
                ("English", english), ("Spanish", spanish), ("French", french),
                ("German", german), ("Chinese", chinese), ("Japanese", japanese),
                ("Russian", russian), ("Arabic", arabic), ("Hindi", hindi)
            };
            
            string detectedLang = "English"; // default
            int maxCount = 0;
            
            foreach (var (lang, count) in langCounts)
            {
                if (count > maxCount)
                {
                    maxCount = count;
                    detectedLang = lang;
                }
            }
            
            return detectedLang;
        }
    }
}