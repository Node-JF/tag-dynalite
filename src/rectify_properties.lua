props["Logical Channels"].IsHidden = props["Enable Logical Channels"].Value == "No"
props["Enable Polling"].IsHidden = props["Protocol"].Value == "DyNet Text"
props["Poll Rate (s)"].IsHidden = props["Enable Polling"].Value == "No" or props["Protocol"].Value == "DyNet Text"
props["Preset Recall Mode"].IsHidden = props["Protocol"].Value ~= "DyNet 1"
-- props["Connection Type"].IsHidden = props["DyNet Protocol"].Value == "Text"
-- if props["DyNet Protocol"].Value == "Text" then
--   props["Connection Type"].Value = "TCP"
-- end