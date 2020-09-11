BaseState = Class {}
-- call these when there's no override for a given state
function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
