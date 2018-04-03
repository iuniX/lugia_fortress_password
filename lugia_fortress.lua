local p_lugiaFortressOPCode = 147
local p_password = {}
local p_passwordCharsCount = 4
local p_passwordWindow
local p_passwordPanel
local _onRecieveOpCode
local p_removeRedScreen
local _destroyRedScreen

function init()
  p_passwordWindow = g_ui.loadUI('lugia_fortress', rootWidget)
  p_passwordPanel = p_passwordWindow:getChildById('panel')
  g_game.handleExtended(p_lugiaFortressOPCode, _onRecieveOpCode)
  connect(g_game, { onGameEnd = _destroyRedScreen()})
end

function terminate()
  g_game.unhandleExtended(p_lugiaFortressOPCode, receiveData)
  p_passwordWindow:destroy()
  _destroyRedScreen()
end

function show()
  p_passwordWindow:show()
  p_passwordWindow:raise()
  p_passwordWindow:focus()
end

function hide()
  p_passwordWindow:hide()
end

function _onRecieveOpCode(params)
  if params.action == "password" then
    resetPassword()
    show()
    return
  end
  local panel = modules.game_interface.getMapPanel()

  if params.action == "alarm-stop" then
    _destroyRedScreen()
    return
  end

  if params.action == "alarm-start" then
    local redscreen = g_ui.createWidget('RedScreen', panel)
    _turnRedScreenOn(redscreen, params.duration, params.interval)
  end
end

function _destroyRedScreen()
  local panel = modules.game_interface.getMapPanel()
  local widget = panel:getChildById('redscreen')
  if widget then
    widget:destroy()
  end
  if p_removeRedScreen then
    p_removeRedScreen:cancel()
  end
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
    p_removeRedScreen = scheduleEvent(function()
      g_effects.stopBlink(widget)
      widget:destroy()
    end, duration)
  end
end
