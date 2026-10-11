-- Personal overrides for the variables in ~/.config/hypr/variables.lua.
-- Keybinds can be a string or a list of strings; "" disables one.
return {
    -- Apps
    terminal               = "app2unit -- kitty",
    browser                = "app2unit -- zen-browser",
    editor                 = "app2unit -- code",

    kbBrowser              = "SUPER + F",
    kbFileExplorer         = "",

    -- Window actions
    kbToggleWindowFloating = "SUPER + W",
    kbWindowFullscreen     = "F11",
    kbWindowDecreaseWidth  = "SUPER + Minus",
    kbWindowIncreaseWidth  = "SUPER + Equal",
    kbWindowDecreaseHeight = "SUPER + SHIFT + Minus",
    kbWindowIncreaseHeight = "SUPER + SHIFT + Equal",

    -- Window cycling (Alt+Tab cycle + raise is bound in hypr-user.lua)
    kbWindowCycleNext      = "",
    kbWindowCyclePrev      = "",
    kbWindowGroupCycleNext = "",
    kbWindowGroupCyclePrev = "SHIFT + ALT + TAB",
    kbUngroup              = "",

    -- Special workspaces (plain toggles that don't launch apps are bound in hypr-user.lua)
    kbMusicWs              = "",
    kbCommunicationWs      = "",
    kbTodoWs               = "",

    -- Moved/disabled to free Super+hjkl and Super+Shift+hjkl for vim-style focus/move
    kbShowPanels           = "SUPER + ALT + K",
    kbLock                 = "",
    kbSleep                = "",

    -- Bound in hypr-user.lua instead, with the launcher interrupt
    kbLauncher             = "",
}
