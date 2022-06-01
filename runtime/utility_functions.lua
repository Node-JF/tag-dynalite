function ResetTimers()
  pollTimer:Stop()
  queueTimer:Stop()
end

function DisableTcpControls(bool)
  Controls["ip_address"].IsDisabled = bool
  Controls["port"].IsDisabled = bool
end
