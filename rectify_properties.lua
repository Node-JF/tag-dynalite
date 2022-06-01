props["Logical Channels"].IsHidden = props["Enable Logical Channels"].Value == "No"
props["Enable Polling"].IsHidden = props["DyNet Protocol"].Value == "Text"
props["Poll Rate (s)"].IsHidden = props["Enable Polling"].Value == "No" or props["DyNet Protocol"].Value == "Text"
-- props["Connection Type"].IsHidden = props["DyNet Protocol"].Value == "Text"
-- if props["DyNet Protocol"].Value == "Text" then
--   props["Connection Type"].Value = "TCP"
-- end