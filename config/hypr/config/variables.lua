-- https://wiki.hypr.land/Configuring/Basics/Variables
-- Shared path constants for Omarchy's Hyprland Lua modules.
-- Lua files loaded with require() have separate local scopes, so modules that
-- need these paths import this table instead of repeating os.getenv() lookups.

local currentThemePath = os.getenv "NC_CURRENT_THEME_PATH"
dofile(currentThemePath .. "/hyprland.lua")

hl.config {

  -------------------------------------------------------------------------------
  -- Input
  -------------------------------------------------------------------------------

  input = {
    -- See https://wiki.hypr.land/Configuring/Basics/Binds/#switchable-keyboard-layouts
    kb_layout = "us,us",
    kb_variant = ",intl",
    kb_options = "grp:alt_space_toggle, compose:caps",

    numlock_by_default = true,

    repeat_rate = 32,
    repeat_delay = 250,

    touchpad = {
      scroll_factor = 0.4,
      clickfinger_behavior = true, -- use two-finger clicks for right-click instead of lower-right corner.
    },
  },

  -------------------------------------------------------------------------------
  -- General
  -------------------------------------------------------------------------------

  general = {
    border_size = 2,
    gaps_out = 10,
    layout = "scrolling",
  },

  -------------------------------------------------------------------------------
  -- Decoration
  -------------------------------------------------------------------------------

  decoration = {
    blur = {
      enabled = false,
      -- size = 2,
      -- passes = 2,
      -- contrast = 0.75,
      -- brightness = 0.60,
    },
    shadow = {
      enabled = false,
      -- range = 2,
    },
  },

  -------------------------------------------------------------------------------
  -- Animations
  -------------------------------------------------------------------------------

  animations = {
    enabled = false,
  },

  -------------------------------------------------------------------------------
  -- Misc
  -------------------------------------------------------------------------------

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_scale_notification = true,

    mouse_move_enables_dpms = true, -- wake up the monitors if the mouse moves
    key_press_enables_dpms = true, -- wake up the monitors if a key is pressed

    focus_on_activate = true, -- focus an app that requests to be focused

    on_focus_under_fullscreen = 1,
  },

  -------------------------------------------------------------------------------
  -- Binds
  -------------------------------------------------------------------------------

  binds = {
    hide_special_on_workspace_change = true,
  },

  -------------------------------------------------------------------------------
  -- Cursor
  -------------------------------------------------------------------------------

  cursor = {
    warp_on_change_workspace = 1,
    hide_on_key_press = true,
  },
}
