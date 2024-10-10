// Autosplitter originally created by DxtrPog, maintained by 1K2C3M

state("RaccoonCh1-Win64-Shipping", "1.1.0")
{
    byte loading : 0x076F1470, 0xB0;
    byte moving : 0x07730DD0, 0x8, 0x8, 0x130, 0x3E0, 0x5C0;
    byte paused : 0x07733740, 0x150, 0x328;
    string40 scene : 0x0728CFF8, 0x10, 0x0, 0x8, 0x30, 0xE8, 0x18;
}

state("Raccoon", "1.0.2")
{
    byte loading : 0x0F889A38, 0x50;
    byte paused : 0x0FE22FC0, 0x8, 0xB8;
    byte moving : 0x0FDF3150, 0x30, 0x418, 0x5A0;
    string40 scene : 0x0FDF3150, 0x78, 0x20, 0xAE0, 0x18;
}

init {
    vars.readyToStart = 0;
    var moduleMemorySize = modules.First().ModuleMemorySize;

    switch (moduleMemorySize) {
        case 167936:
            version = "1.0.2";
            break;
        case 132218880:
            version = "1.1.0";
            break;
    }
}



update {
    if (current.scene != old.scene && current.scene == "/ParkEntrance") {
        vars.readyToStart = 1;
    }
}

startup {
    vars.missions = new Dictionary<string, string> {
        {"/ParkEntrance", "Park Entrance"},
        {"/RailroadTunnel", "Railroad Tunnel"},
        {"/RambleyRailroad", "Rambley Railroad / On train"},
        {"/MainStreet", "Main Street after train and after theater (I dunno how to make it separate)"},
        {"/Theater", "Theater/Lloyd's area"},
        {"/JetstreamJunction", "Jetstream Junction"},
        {"/LandingPad", "Landing Pad"},
        {"/ChaseScene", "Chase Scene/Mollie's Area"},
        {"/RoadtoOcean", "Road to Ocean/Last Area (needed if you are playing through the whole game)"}
    };
    foreach (var tag in vars.missions) {
        settings.Add(tag.Key, true, tag.Value);
    }   
}

start {
    if (current.moving != 0 && vars.readyToStart == 1 || current.moving == null && vars.readyToStart == 1) {
        vars.readyToStart = 0;
        return true;
    }
}

split {
    if (current.scene != old.scene) {
        return settings[old.scene] && current.scene != "formerkit/levelmaps/";
    }
}

reset {
    return current.scene == "/StartScreen" && old.scene != "/CreditsCutscene" || current.scene == null;
}

isLoading {
    return current.loading == 1 || current.loading == null || current.paused == 1 || current.paused == null || current.scene == "/StartScreen";
}

exit {
    return true;
}