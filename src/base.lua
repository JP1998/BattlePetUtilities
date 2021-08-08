
local name, app = ...;
function app:GetName()
    return name;
end
_G[name] = app;

-- Create an Event Processor.
local events = {};
local updates = {};
local _ = CreateFrame("FRAME", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate");
_:SetScript("OnEvent", function(self, e, ...) (rawget(events, e) or print)(...); end);
_:SetScript("OnUpdate", function(self, elapsed) for _,v in pairs(updates) do v(elapsed); end end);
_:SetPoint("BOTTOMLEFT", UIParent, "TOPLEFT", 0, 0);
_:SetSize(1, 1);
_:Show();
app._ = _;
app.events = events;
app.updates = updates;
app.refreshDataForce = true;
app.RegisterEvent = function(self, ...)
    _:RegisterEvent(...);
end
app.UnregisterEvent = function(self, ...)
    _:UnregisterEvent(...);
end
app.RegisterUpdate = function(self, key, handler)
    updates[key] = handler;
end
app.UnregisterUpdate = function(self, key)
    updates[key] = nil;
end
