
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Settings = require(script.Parent.Parent.SettingsLib.Settings)


local Translation = {}

-- Dicionário de traduções
-- Exemplo: Translations["en"] = {["Hello"] = "Hello", ["World"] = "World"}
-- Translations["pt"] = {["Hello"] = "Olá", ["World"] = "Mundo"}
Translation.Translations = Settings.Settings.Translations

-- Função para obter o idioma do jogador
function Translation:GetPlayerLanguage()
    if LocalPlayer then
        return LocalPlayer.LocaleId:sub(1, 2) -- Retorna as duas primeiras letras do LocaleId (ex: "pt" de "pt-br")
    end
    return Settings.Settings.DefaultLanguage -- Retorna o idioma padrão se não conseguir obter o do jogador
end

-- Função para traduzir um texto
function Translation:Translate(textKey)
    if not Settings.Settings.EnableTranslation then
        return textKey -- Retorna a chave original se a tradução estiver desativada
    end

    local lang = self:GetPlayerLanguage()
    local translatedText = self.Translations[lang] and self.Translations[lang][textKey]

    if translatedText then
        return translatedText
    else
        -- Se não encontrar a tradução para o idioma do jogador, tenta o idioma padrão
        local defaultLang = Settings.Settings.DefaultLanguage
        local defaultTranslatedText = self.Translations[defaultLang] and self.Translations[defaultLang][textKey]
        if defaultTranslatedText then
            warn("Translation not found for key '" .. textKey .. "' in language '" .. lang .. "'. Using default language '" .. defaultLang .. "'.")
            return defaultTranslatedText
        else
            warn("Translation not found for key '" .. textKey .. "' in any language. Returning original key.")
            return textKey -- Retorna a chave original se não houver tradução em nenhum idioma
        end
    end
end

-- Função para adicionar traduções (pode ser chamada de outros scripts)
function Translation:AddTranslations(newTranslations)
    for lang, keys in pairs(newTranslations) do
        self.Translations[lang] = self.Translations[lang] or {}
        for key, value in pairs(keys) do
            self.Translations[lang][key] = value
        end
    end
end

return Translation

