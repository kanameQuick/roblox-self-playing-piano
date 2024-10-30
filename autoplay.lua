-- paste this under the PianoGui's Main script --

----------------------------------
----------------------------------
----------------------------------
------------AUTOPLAY--------------
----------------------------------
----------------------------------
----------------------------------

function playNote(letter)
	PlayNoteClient(LetterToNote(string.byte(letter), false))
end


function onSheetEnter(enterPressed)
	if enterPressed then
		local tempo = .5

		local startingPoint = 1
		local currentLetter = 1
		
		local sheetText = script.Parent.SheetsGui.Sheet.ScrollingFrame.TextBox.Text
		
		local foundComma = string.find(sheetText, ",", 1, true)
		
		if foundComma then -- if a comma was found
			tempo = 60 / tonumber(string.sub(sheetText, 1, foundComma-1))
			startingPoint = foundComma+1
		end
		
		local sheet = string.sub(sheetText, startingPoint)
		
		repeat
			local letter = string.sub(sheet, currentLetter, currentLetter)
			
			--print('"' .. letter .. '"')
			
			if letter == " " then -- space
				wait(tempo / 4)
			elseif letter == "|" then -- vertical line
				wait(tempo / 2)
			elseif letter == "\n" or letter == "\r" then -- para break
				wait(tempo / 2)
				
				if letter == "\r" then
					currentLetter += 1
				end
			elseif letter == "[" then -- open bracket   [asdf]
				currentLetter += 1
				
				for subLetterNo, comboLetter in pairs(string.split(string.sub(sheet, currentLetter, string.find(sheet, "]", currentLetter, true)-1), "")) do
					if comboLetter ~= " " then
						playNote(comboLetter)
					else
						wait(tempo / 8)
					end
					--warn('"' .. comboLetter .. '"')
					currentLetter += 1
				end
				
				wait(tempo / 4)
			elseif letter ~= "]" then -- if it's a letter
				playNote(letter)
				wait(tempo / 4)
			end
			
			currentLetter += 1
		until currentLetter > #sheet
	end
end

local sheetText = script.Parent.SheetsGui.Sheet.ScrollingFrame.TextBox.FocusLost:Connect(onSheetEnter)