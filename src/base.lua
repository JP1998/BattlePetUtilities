
local name, app = ...;
function app:GetName()
    return name;
end
_G["BattlePetUtilities"] = app;

-- Create an Event Processor.
local events = {};
local _ = CreateFrame("FRAME", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate");
_:SetScript("OnEvent", function(self, e, ...) (rawget(events, e) or print)(...); end);
_:SetPoint("BOTTOMLEFT", UIParent, "TOPLEFT", 0, 0);
_:SetSize(1, 1);
_:Show();
app._ = _;
app.events = events;
app.refreshDataForce = true;
app.RegisterEvent = function(self, ...)
    _:RegisterEvent(...);
end
app.UnregisterEvent = function(self, ...)
    _:UnregisterEvent(...);
end
