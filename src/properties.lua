local props = {
  {
    Name = "Protocol",
    Type = "enum",
    Choices = {
      "DyNet 1",
      "DyNet Text"
    },
    Value = "DyNet 1"
  },
  {
    Name = "Enable Polling",
    Type = "enum",
    Choices = {"Yes", "No"},
    Value = "Yes"
  },
  {
      Name = "Poll Rate (s)",
      Type = "integer",
      Min  = 5,
      Max = 60,
      Value = 5
  },
  {
    Name = "Connection Type",
    Type = "enum",
    Choices = {
      "TCP",
      "Serial"
    },
    Value = "TCP"
  },
  {
      Name = "Area Slots",
      Type = "integer",
      Min  = 2,
      Max = 50,
      Value = 2
  },
  {
      Name = "Presets",
      Type = "integer",
      Min  = 2,
      Max = 50,
      Value = 10
  },
  {
    Name = "Preset Recall Mode",
    Type = "enum",
    Choices = {"Linear", "Non-Linear"},
    Value = "Linear"
  },
  {
      Name = "Enable Logical Channels",
      Type = "enum",
      Choices = {"Yes", "No"},
      Value = "No"
  },
  {
      Name = "Logical Channels",
      Type = "integer",
      Min  = 1,
      Max = 50,
      Value = 4
  }

}