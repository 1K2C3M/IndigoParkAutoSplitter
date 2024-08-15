// Autosplitter originally created by DxtrPog, corrections and edits by 1K2C3M

state("Raccoon") {
  byte loading : 0x0F889A38, 0x50;
  byte paused : 0x0FE22FC0, 0x8, 0xB8;
  byte moving : 0x0FDF3150, 0x30, 0x418, 0x5A0;
  string40 scene : 0x0FDF3150, 0x78, 0x20, 0xAE0, 0x18;
}

init {
  vars.startTimer = 0;
  vars.sceneLoaded = "";

  if (modules.First().ModuleMemorySize == 167936) {
    var allComponents = timer.Layout.Components;
    // Grab the autosplitter from splits
    if (timer.Run.AutoSplitter != null && timer.Run.AutoSplitter.Component != null) {
      allComponents = allComponents.Append(timer.Run.AutoSplitter.Component);
    }
    foreach (var component in allComponents) {
      var type = component.GetType();
      if (type.Name == "ASLComponent") {
        var script = type.GetProperty("Script").GetValue(component);
        script.GetType().GetField("_game", BindingFlags.NonPublic | BindingFlags.Instance).SetValue(script, null);
      }
    }
    return;
  }
}

update {
  if (current.loading == 1 && current.scene == "/LandingPad") {
    vars.startTimer = 1;
  }
}

start {
  if (current.scene == "/LandingPad" && (current.moving != 0 || current.moving == null) && vars.startTimer == 1) {
    vars.startTimer = 0;
    vars.sceneLoaded = current.scene;
    return true;
  }
}

split {
  if (current.scene != old.scene && old.scene == "/LandingPad") {
    return true;
  }
  return false;
}

reset { return current.scene == "/StartScreen" || current.scene == null || (current.scene == old.scene && current.loading == 1); }

isLoading { return current.loading == 1 || current.paused == 1 || current.scene == "/StartScreen"; }
