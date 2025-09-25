local Settings = {}

Settings.Version = "Version: 1.0.1"
Settings.Discord = "https://discord.gg/ezbBqDXeq5"

-- Configurações Globais da UI
Settings.MainColor = Color3.fromRGB(153, 102, 204) -- Cor principal da UI (Dark Amethyst)
Settings.AccentColor = Color3.fromRGB(7, 63, 237) -- Cor de destaque (azul para títulos brancos)
Settings.BackgroundColor = Color3.fromRGB(28, 28, 28) -- Cor de fundo padrão
Settings.TextColor = Color3.fromRGB(255, 255, 255) -- Cor do texto padrão
Settings.DescriptionTextColor = Color3.fromRGB(230, 230, 230) -- Cor do texto de descrição
Settings.ShadowColor = Color3.fromRGB(0, 0, 0) -- Cor da sombra

-- Configurações de Tradução
Settings.EnableTranslation = true -- Define se a UI deve ser traduzida automaticamente (true/false)
Settings.DefaultLanguage = "en" -- Idioma padrão caso a tradução automática falhe (ex: "en", "pt", "es")
Settings.Translations = Settings.Translations or {}

-- Configurações do Key System
Settings.EnableKeySystem = false -- Define se o sistema de chaves está ativo (true/false)
Settings.Key = "YOUR_DEFAULT_KEY_HERE" -- Chave padrão (substitua por uma chave real)

return Settings

