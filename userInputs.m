function [thresholdChoice,UserInputs] = userInputs()
% Opens dialogue box and takes user input as integer 1 or 2
% 
% Allows user to pick a threshold method. This is, if user inputs 1 the code 
% will use manual thresholding and asks the user to input threshold values
% for each Channel. If the user inputs 2 Otsu's method is used for global
% thresholding. See MATLAB's documentation on Otsu's method for more 
% information. This can be done by typing help otsuthresh in the command window. 

prompt = sprintf('Enter 1 for manual thresholding or \n \n\nEnter 2 for otsuthresh');
dlgtitle = 'Input';
dims = [1 40];
definput = {'1'};
thresholdChoice = inputdlg(prompt,dlgtitle,dims,definput);

    if thresholdChoice{1,1} == '1'
        prompt = {'Enter Threshold Green Channel' , 'Enter Threshold Red Channel'};
        dlgtitle = 'Manual Thresholding';
        dims = [1 45];
        definput = {'100','100'};
        UserInputs = inputdlg(prompt,dlgtitle,dims,definput);
    elseif thresholdChoice{1,1} == '2'
        UserInputs = 0;
        msgbox('Otsuthresh selected');
    else
      warningMessage = sprintf('Wrong input.\n\nYou are the worst!');
      uiwait(warndlg(warningMessage));
      errormessage = sprintf('Program terminated due to user error! \n\nPLEASE: \n -Enter 1 for manual thresholding. \n -Enter 2 for auto thresholding.');
      error(errormessage);
    end
end

