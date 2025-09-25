
local _env = getgenv and getgenv() or {}

local Ver = "Version: 1.0.1"
local Dis = "https://discord.gg/ezbBqDXeq5"

_env.Discord = Dis
_env.Version = Ver

-- Configurações Globais da UI
_env.Settings = _env.Settings or {}
_env.Settings.MainColor = Color3.fromRGB(153, 102, 204) -- Cor principal da UI (Dark Amethyst)
_env.Settings.AccentColor = Color3.fromRGB(7, 63, 237) -- Cor de destaque (azul para títulos brancos)
_env.Settings.BackgroundColor = Color3.fromRGB(28, 28, 28) -- Cor de fundo padrão
_env.Settings.TextColor = Color3.fromRGB(255, 255, 255) -- Cor do texto padrão
_env.Settings.DescriptionTextColor = Color3.fromRGB(230, 230, 230) -- Cor do texto de descrição
_env.Settings.ShadowColor = Color3.fromRGB(0, 0, 0) -- Cor da sombra

-- Configurações de Tradução
_env.Settings.EnableTranslation = true -- Define se a UI deve ser traduzida automaticamente (true/false)
_env.Settings.DefaultLanguage = "en" -- Idioma padrão caso a tradução automática falhe (ex: "en", "pt", "es")
_env.Settings.Translations = _env.Settings.Translations or {}

-- Configurações do Key System
_env.Settings.EnableKeySystem = false -- Define se o sistema de chaves está ativo (true/false)
_env.Settings.Key = "YOUR_DEFAULT_KEY_HERE" -- Chave padrão (substitua por uma chave real)

return _env

