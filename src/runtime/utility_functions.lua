function ResetTimers()
  pollTimer:Stop()
  queueTimer:Stop()
end

function DisableTcpControls(bool)
  Controls["ip_address"].IsDisabled = bool
  Controls["port"].IsDisabled = bool
end

function getJoin(position)
  if Properties["Protocol"].Value ~= "DyNet 1" then return 0xFF end
  local join
  local bits = ''

  for byte = 0, 7 do
    local bit = Controls[string.format('join_byte_%d', byte)][position].String
    bits = bits .. bit
  end

  print(bits)
  join = string.byte( bitstring.frombinstream(bits) )
  
  Controls[string.format('join_hex')][position].String = bitstring.hexstream( bitstring.pack('8:int', join) )
  return join
end
