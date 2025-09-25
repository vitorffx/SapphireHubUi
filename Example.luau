-- Este é um arquivo de exemplo para demonstrar o uso da SapphireHubUi.
-- Para usar este script, você precisará ter os módulos SettingsLib e TranslationLib
-- configurados corretamente no ReplicatedStorage do Roblox.

-- Obter serviços do Roblox
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Mover os módulos para ReplicatedStorage para que os requires funcionem
local SapphireHubUiFolder = Instance.new("Folder")
SapphireHubUiFolder.Name = "SapphireHubUi"
SapphireHubUiFolder.Parent = ReplicatedStorage

-- Mover os módulos reais para a pasta
local SapphireUiModule = script.Parent.SapphireUi.SapphireUi
SapphireUiModule.Parent = SapphireHubUiFolder

local SettingsLibFolder = script.Parent.SettingsLib
SettingsLibFolder.Parent = SapphireHubUiFolder

local TranslationFolder = script.Parent.translation
TranslationFolder.Parent = SapphireHubUiFolder

-- Requerer as bibliotecas corretamente
local SapphireHubUi = require(ReplicatedStorage.SapphireHubUi.SapphireUi)
local Settings = require(ReplicatedStorage.SapphireHubUi.SettingsLib.Settings)
local Translation = require(ReplicatedStorage.SapphireHubUi.translation.translation)

-- Configurar traduções (exemplo)
if Settings and Settings.EnableTranslation then
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
    Placeholder = Translation:Translate("Enter your name"),
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
            Color = Color3.fromRGB(0, 255, 0)
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
    Default = Settings.EnableKeySystem,
    Callback = function(value)
        Settings.EnableKeySystem = value
        print("Key System Enabled: " .. tostring(value))
    end
})

KeySystemSettingsSection:TextInput({
    Title = Translation:Translate("Set Key"),
    Content = "",
    Placeholder = Translation:Translate("Enter new key"),
    Default = Settings.Key,
    Callback = function(text)
        Settings.Key = text
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
    Placeholder = "en, pt, es, etc.",
    Default = Translation:GetCurrentLanguage(),
    Callback = function(langCode)
        Translation:SetLanguage(langCode)
        print("UI Language changed to: " .. langCode)
        SapphireHubUi:Notify({
            Title = "Language Changed",
            Description = "UI language updated",
            Content = "The UI language has been set to " .. langCode .. ".",
            Color = Color3.fromRGB(0, 150, 255)
        })
    end
})

-- Exemplo de notificação inicial
SapphireHubUi:Notify({
    Title = "Bem-vindo!",
    Description = "SapphireHub está pronto.",
    Content = "Este é um exemplo de notificação.",
    Color = Color3.fromRGB(153, 102, 204),
    Time = 0.5,
    Delay = 5
})

-- Para abrir/fechar a UI com um Keybind:
-- local UserInputService = game:GetService("UserInputService")
-- UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
--     if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
--         UI:ToggleUI()
--     end
-- end)
