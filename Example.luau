
-- Este é um arquivo de exemplo para demonstrar o uso da SapphireHubUi.
-- Para usar este script, você precisará ter os módulos SettingsLib e TranslationLib
-- configurados corretamente no ReplicatedStorage do Roblox.

-- Obter serviços do Roblox
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requerer as bibliotecas
local SapphireHubUi = https://raw.githubusercontent.com/vitorffx/SapphireHubUi/refs/heads/main/SapphireUi/SapphireUi.luau
local Settings = https://raw.githubusercontent.com/vitorffx/SapphireHubUi/refs/heads/main/SettingsLib/Settings.luau
local Translation = https://raw.githubusercontent.com/vitorffx/SapphireHubUi/refs/heads/main/translation/translation.luau

-- Configurar traduções (exemplo)
-- Em um cenário real, estas traduções seriam carregadas de um servidor ou de um módulo mais complexo.
-- Para este exemplo, vamos adicionar algumas traduções diretamente.
if Settings.Settings.EnableTranslation then
    Translation:AddTranslation("en", "Key System", "Key System")
    Translation:AddTranslation("pt", "Key System", "Sistema de Chave")
    Translation:AddTranslation("en", "Enter Key...", "Enter Key...")
    Translation:AddTranslation("pt", "Enter Key...", "Digite a Chave...")
    Translation:AddTranslation("en", "Submit", "Submit")
    Translation:AddTranslation("pt", "Submit", "Enviar")
    Translation:AddTranslation("en", "Invalid Key", "Invalid Key")
    Translation:AddTranslation("pt", "Invalid Key", "Chave Inválida")
    Translation:AddTranslation("en", "Main Tab", "Main Tab")
    Translation:AddTranslation("pt", "Main Tab", "Aba Principal")
    Translation:AddTranslation("en", "Settings Tab", "Settings Tab")
    Translation:AddTranslation("pt", "Settings Tab", "Aba de Configurações")
    Translation:AddTranslation("en", "Welcome to SapphireHub!", "Welcome to SapphireHub!")
    Translation:AddTranslation("pt", "Welcome to SapphireHub!", "Bem-vindo ao SapphireHub!")
    Translation:AddTranslation("en", "General Settings", "General Settings")
    Translation:AddTranslation("pt", "General Settings", "Configurações Gerais")
    Translation:AddTranslation("en", "Toggle Feature", "Toggle Feature")
    Translation:AddTranslation("pt", "Toggle Feature", "Ativar Recurso")
    Translation:AddTranslation("en", "This is a toggleable feature.", "This is a toggleable feature.")
    Translation:AddTranslation("pt", "This is a toggleable feature.", "Este é um recurso que pode ser ativado/desativado.")
    Translation:AddTranslation("en", "Enter your name", "Enter your name")
    Translation:AddTranslation("pt", "Enter your name", "Digite seu nome")
    Translation:AddTranslation("en", "Your Name", "Your Name")
    Translation:AddTranslation("pt", "Your Name", "Seu Nome")
    Translation:AddTranslation("en", "Click me!", "Click me!")
    Translation:AddTranslation("pt", "Click me!", "Clique em mim!")
    Translation:AddTranslation("en", "Example Button", "Example Button")
    Translation:AddTranslation("pt", "Example Button", "Botão de Exemplo")
    Translation:AddTranslation("en", "This is an example button.", "This is an example button.")
    Translation:AddTranslation("pt", "This is an example button.", "Este é um botão de exemplo.")
    Translation:AddTranslation("en", "Key System Settings", "Key System Settings")
    Translation:AddTranslation("pt", "Key System Settings", "Configurações do Sistema de Chave")
    Translation:AddTranslation("en", "Enable Key System", "Enable Key System")
    Translation:AddTranslation("pt", "Enable Key System", "Ativar Sistema de Chave")
    Translation:AddTranslation("en", "Set Key", "Set Key")
    Translation:AddTranslation("pt", "Set Key", "Definir Chave")
    Translation:AddTranslation("en", "Enter new key", "Enter new key")
    Translation:AddTranslation("pt", "Enter new key", "Digite a nova chave")
    Translation:AddTranslation("en", "Change UI Language", "Change UI Language")
    Translation:AddTranslation("pt", "Change UI Language", "Mudar Idioma da UI")
    Translation:AddTranslation("en", "Select Language", "Select Language")
    Translation:AddTranslation("pt", "Select Language", "Selecionar Idioma")
    Translation:AddTranslation("en", "Click", "Click")
    Translation:AddTranslation("pt", "Click", "Clique")
end

-- Criar a UI principal
local UI = SapphireHubUi:Create({
    Name = "SapphireHub",
    Description = "v1.0",
    -- Outras configurações podem ser definidas aqui, como cores, logos, etc.
})

-- Criar abas
local MainTab = UI:MakeTab(Translation:Translate("Main Tab"))
local SettingsTab = UI:MakeTab(Translation:Translate("Settings Tab"))

-- Adicionar seções e itens à aba principal
local MainSection = MainTab:Section({
    Title = Translation:Translate("General Settings"),
    Content = ""
})

MainSection:Toggle({
    Title = Translation:Translate("Toggle Feature"),
    Content = Translation:Translate("This is a toggleable feature."),
    Default = false,
    Callback = function(value)
        print("Toggle Feature: " .. tostring(value))
    end
})

MainSection:TextInput({
    Title = Translation:Translate("Your Name"),
    Content = "",
    ["Place Holder Text"] = Translation:Translate("Enter your name"),
    Default = "Player",
    Callback = function(text)
        print("Name entered: " .. text)
    end
})

MainSection:Button({
    Title = Translation:Translate("Example Button"),
    Content = Translation:Translate("This is an example button."),
    Callback = function()
        print("Example Button Clicked!")
        SapphireHubUi:Notify({
            Title = "Notification",
            Description = "Button Clicked",
            Content = "You clicked the example button!",
            Color = Color3.fromRGB(0, 255, 0) -- Green notification
        })
    end
})

-- Adicionar seções e itens à aba de configurações
local KeySystemSettingsSection = SettingsTab:Section({
    Title = Translation:Translate("Key System Settings"),
    Content = ""
})

KeySystemSettingsSection:Toggle({
    Title = Translation:Translate("Enable Key System"),
    Content = "",
    Default = Settings.Settings.EnableKeySystem,
    Callback = function(value)
        Settings.Settings.EnableKeySystem = value
        print("Key System Enabled: " .. tostring(value))
    end
})

KeySystemSettingsSection:TextInput({
    Title = Translation:Translate("Set Key"),
    Content = "",
    ["Place Holder Text"] = Translation:Translate("Enter new key"),
    Default = Settings.Settings.Key,
    Callback = function(text)
        Settings.Settings.Key = text
        print("New Key Set: " .. text)
    end
})

local LanguageSettingsSection = SettingsTab:Section({
    Title = Translation:Translate("Change UI Language"),
    Content = ""
})

LanguageSettingsSection:TextInput({
    Title = Translation:Translate("Select Language"),
    Content = "",
    ["Place Holder Text"] = "en, pt, es, etc.",
    Default = Translation:GetCurrentLanguage(),
    Callback = function(langCode)
        Translation:SetLanguage(langCode)
        print("UI Language changed to: " .. langCode)
        SapphireHubUi:Notify({
            Title = "Language Changed",
            Description = "UI language updated",
            Content = "The UI language has been set to " .. langCode .. ".",
            Color = Color3.fromRGB(0, 150, 255) -- Blue notification
        })
    end
})

-- Exemplo de como usar a notificação
SapphireHubUi:Notify({
    Title = "Bem-vindo!",
    Description = "SapphireHub está pronto.",
    Content = "Este é um exemplo de notificação.",
    Color = Color3.fromRGB(153, 102, 204), -- Dark Amethyst
    Time = 0.5,
    Delay = 5
})

-- Para abrir/fechar a UI, você pode usar um Keybind ou um botão no jogo.
-- Exemplo de Keybind (pode ser adicionado em um LocalScript separado ou aqui):
-- UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
--     if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
--         UI:ToggleUI()
--     end
-- end)

-- Note: Este script deve ser um LocalScript e estar em um local acessível pelo cliente,
-- como StarterPlayerScripts ou PlayerGui.

