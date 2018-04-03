local p_lugiaFortressOPCode = 147
local p_password = {}
local p_passwordCharsCount = 4
local p_passwordWindow
local p_passwordPanel
local _onRecieveOpCode

function init()
  p_passwordWindow = g_ui.loadUI('lugia_fortress', rootWidget)
  p_passwordPanel = p_passwordWindow:getChildById('panel')
  g_game.handleExtended(p_lugiaFortressOPCode, _onRecieveOpCode)
end

function terminate()
  g_game.unhandleExtended(p_lugiaFortressOPCode, receiveData)
  p_passwordWindow:destroy()

  local panel = modules.game_interface.getMapPanel()
  local widget = panel:getChildById('redscreen')
  if widget then
    widget:destroy()
  end
end

function show()
  p_passwordWindow:show()
  p_passwordWindow:raise()
  p_passwordWindow:focus()
end

function hide()
  p_passwordWindow:hide()
end

function _onRecieveOpCode(t)
  if t == 1 then
    resetPassword()
    show()
    return
  end
  local panel = modules.game_interface.getMapPanel()

  if not t then
    local widget = panel:getChildById('redscreen')
    if widget then
      g_effects.stopBlink(widget)
      widget:destroy()
    end
    return
  end

  local redscreen = g_ui.createWidget('RedScreen', panel)
  _turnRedScreenOn(redscreen, t.duration, t.interval)
end

function onClickButton(button)
  if #p_password < p_passwordCharsCount then
    table.insert(p_password, button)
    updatePasswordText()
  end
end

function onClickOkButton()
  hide()
  g_game.sendExtended(p_lugiaFortressOPCode, p_password)
end

function updatePasswordText()
  p_passwordPanel:setText(string.rep('* ', #p_password) .. string.rep('_', p_passwordCharsCount - #p_password))
end

function resetPassword()
  p_password = {}
  updatePasswordText()
end

function _turnRedScreenOn(widget, duration, interval)
  duration = duration or 0
  interval = interval or 500

  g_effects.startBlink(widget, duration, interval)

  if duration > 0 then
    scheduleEvent(function()
      g_effects.stopBlink(widget)
      widget:destroy()
    end, duration)
  end
end
