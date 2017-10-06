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
  resetPassword()
  show()
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
