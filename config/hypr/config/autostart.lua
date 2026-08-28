hl.on("hyprland.start", function()
  hl.exec_cmd "systemctl --user enable --now hyprpolkitagent.service"
  -- hl.exec_cmd "uwsm app -- elephant"
  -- hl.exec_cmd "uwsm app -- walker --gapplication-service"
end)
