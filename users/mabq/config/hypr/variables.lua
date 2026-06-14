-- https://wiki.hypr.land/Configuring/Basics/Variables

local active_border_color = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 }
local inactive_border_color = "rgba(595959aa)"

hl.config {

  -------------------------------------------------------------------------------
  -- General
  -------------------------------------------------------------------------------

  general = {
    border_size = 2,
    gaps_out = 10,

    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },

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
  -- Input
  -------------------------------------------------------------------------------

  input = {
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
  -- Group
  -------------------------------------------------------------------------------

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
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
