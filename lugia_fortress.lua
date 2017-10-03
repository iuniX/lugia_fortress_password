local lugiaFortressOPCode = 147
local p_password = {}
local passwordCharsCount = 4
local _onRecieveOpCode
local p_passwordWindow
local p_panel

function init()
  p_passwordWindow = g_ui.loadUI('lugia_fortress', rootWidget)
  g_game.handleExtended(lugiaFortressOPCode, _onRecieveOpCode)
  p_panel = p_passwordWindow:getChildById('dataPanel')
end

function onClickButton(button)
  if button == "ok" then
    hide()
    g_game.sendExtended(lugiaFortressOPCode, p_password)
    p_password = {}
    return
  end

  if button == "clear" then
    p_password = {}
    --_addNumberToPanel("reset")
  end

  if #p_password < 4 then
    table.insert(p_password, button)
    --_addNumberToPanel(button)
  end
end

function _onRecieveOpCode(t)
  show()
end

function terminate()
  g_game.unhandleExtended(lugiaFortressOPCode, receiveData)
  p_passwordWindow:destroy()
end

function show()
  p_passwordWindow:show()
  p_passwordWindow:raise()
  p_passwordWindow:focus()
end

function hide()
  p_passwordWindow:hide()
end

function _addNumberToPanel(number)

end