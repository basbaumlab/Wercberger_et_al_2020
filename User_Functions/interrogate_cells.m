function [output] = interrogate_cells(input)

% Show cell 
second_show_cells(input)

% Count RB
prompt = 'How many RB?'; 
RB_answer = inputdlg(prompt);  
 
% Look at other stuff 
things = {'DAPI', 'CCK', 'FOS'}; 
for aa = 1:length(things)
    quest = ['Is this cell ' things{aa} ' (+)?'];  
    address = 'Choose one';
    btn1 = 'Yes'; 
    btn2 = 'No';
    defbtn = btn1; 
    answers{aa} = questdlg(quest,address,btn1,btn2,defbtn);
    
    if aa > 1
        switch answers{aa}
            case btn1
                prompt = ['How many ' things{aa} '?']; 
                temp = inputdlg(prompt);
                answers{aa} = str2num(temp{:}); 
            case btn2
                answers{aa} = 0; 
        end
        
    end
end

C = [{input.x} {input.y} RB_answer answers]; 
output = cell2table(C,...
    'VariableNames',{'X_pos' 'Y_pos' 'RB' 'DAPI' 'CCK' 'FOS'}); 


end

