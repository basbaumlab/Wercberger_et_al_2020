function [answer] = identify_cells(input)

first_show_cells(input)

% User choice. 
quest = 'How many cells are in this image?';
address = 'Choose one';
btn1 = 'One Cell'; 
btn2 = 'Two or more cells';
btn3 = 'Not a cell'; 
defbtn = btn1; 
answer = questdlg(quest,address,btn1,btn2,btn3,defbtn); 

end

