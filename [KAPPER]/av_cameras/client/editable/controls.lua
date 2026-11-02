local uiScript = exports['av_laptop']:getUI()

function UpdateCameraUI(state)
    dbug("Updating camera UI for state:", state)
    if state == "placing" then
        if uiScript == "lation_ui" then
            exports['av_laptop']:showTextUI(Lang['camera_placement_title'], {
                options = {
                    {label = Lang['camera_place'], keybind = Lang['key_e']},
                    {label = Lang['camera_change_model'], keybind = Lang['key_scroll']},
                    {label = Lang['camera_rotate_base'], keybind = Lang['key_left_right']},
                    {label = Lang['camera_cancel'], keybind = Lang['key_backspace']}
                }
            })
        else
            local text = {}
            table.insert(text, Lang['camera_placement_title'])
            table.insert(text, Lang['key_e'] .. " - " .. Lang['camera_place'])
            table.insert(text, Lang['key_scroll'] .. " - " .. Lang['camera_change_model'])
            table.insert(text, Lang['key_left_right'] .. " - " .. Lang['camera_rotate_base'])
            table.insert(text, Lang['key_backspace'] .. " - " .. Lang['camera_cancel'])
            exports['av_laptop']:showTextUI(table.concat(text, "   \n"))
        end
    elseif state == "adjusting" then
        if uiScript == "lation_ui" then
            exports['av_laptop']:showTextUI(Lang['adjust_camera_title'], {
                options = {
                    {label = Lang['adjust_move'], keybind = Lang['key_arrow_keys']},
                    {label = Lang['adjust_fine_rotate'], keybind = Lang['key_scroll']},
                    {label = Lang['adjust_confirm'], keybind = Lang['key_e']},
                    {label = Lang['camera_cancel'], keybind = Lang['key_backspace']}
                }
            })
        else
            local text = {}
            table.insert(text, Lang['adjust_camera_title'])
            table.insert(text, Lang['key_arrow_keys'] .. " - " .. Lang['adjust_move'])
            table.insert(text, Lang['key_scroll'] .. " - " .. Lang['adjust_fine_rotate'])
            table.insert(text, Lang['key_e'] .. " - " .. Lang['adjust_confirm'])
            table.insert(text, Lang['key_backspace'] .. " - " .. Lang['camera_cancel'])
            exports['av_laptop']:showTextUI(table.concat(text, "   \n"))
        end
    elseif state == "viewing" then
        if uiScript == "lation_ui" then
            exports['av_laptop']:showTextUI(Lang['adjust_view_title'], {
                options = {
                    {label = Lang['adjust_move_view'], keybind = Lang['key_arrow_keys']},
                    {label = Lang['adjust_rotation'], keybind = Lang['key_shift_arrow']},
                    {label = Lang['adjust_view_height'], keybind = Lang['key_pageup'] .. " / " .. Lang['key_pagedown']},
                    {label = Lang['adjust_confirm_view'], keybind = Lang['key_e']},
                    {label = Lang['camera_cancel'], keybind = Lang['key_backspace']}
                }
            })
        else
            local text = {}
            table.insert(text, Lang['adjust_view_title'])
            table.insert(text, Lang['key_arrow_keys'] .. " - " .. Lang['adjust_move_view'])
            table.insert(text, Lang['key_shift_arrow_short'] .. " - " .. Lang['adjust_rotation'])
            table.insert(text, Lang['key_pageup'] .. " / " .. Lang['key_pagedown'] .. " - " .. Lang['adjust_view_height'])
            table.insert(text, Lang['key_e'] .. " - " .. Lang['adjust_confirm_view'])
            table.insert(text, Lang['key_backspace'] .. " - " .. Lang['camera_cancel'])
            exports['av_laptop']:showTextUI(table.concat(text, "   \n"))
        end
    else
        exports['av_laptop']:hideTextUI()
    end
end