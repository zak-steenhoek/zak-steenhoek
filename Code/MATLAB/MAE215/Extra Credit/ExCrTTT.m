function ExCrTTT()
% References: 
% figure properties (turn off toolbar, menu): https://www.mathworks.com/help/matlab/ref/matlab.ui.figure-properties.html?searchHighlight=figure%20properties&s_tid=srchtitle_figure%20properties_1
% plot (for linespec, markers, size): https://www.mathworks.com/help/matlab/ref/plot.html?searchHighlight=plot&s_tid=srchtitle_plot_1
% switch/case: https://www.mathworks.com/help/matlab/ref/switch.html
% try/catch: https://www.mathworks.com/help/matlab/ref/try.html?s_tid=doc_ta
% any: https://www.mathworks.com/help/matlab/ref/any.html?searchHighlight=any&s_tid=srchtitle_any_1
% find: https://www.mathworks.com/help/matlab/ref/find.html
% intersect: https://www.mathworks.com/help/matlab/ref/double.intersect.html

clc; clear

hfig = figure(99); clf; hold on; axis square; axis off;
pos = get(hfig,'Position'); pos(3)=500; pos(4)=500;
set(hfig,'Position',pos) %can't set position if docked
% set(hfig,'WindowStyle','docked'); %used docked
set(hfig,'ToolBar','none');
set(hfig,'MenuBar','none');

%defaults
p1 = 'bx';
p2 = 'ro';
moves = zeros(9,1);

drawBoard(hfig,moves,p1,p2);


%% Get player inputs
% Two player game or play against the computer?
% Let Player 1 pick their marker color
% Let Player 2 pick the marker shape
% Provide some instructions
validAns = false;
while validAns == false
    twoPlayer = upper(input('Would you like to play with a friend? Y/N [Y]: ','s'));
    if isempty(twoPlayer)
        twoPlayer = 'Y';
    end
    if (or(twoPlayer == 'Y', twoPlayer == 'N'))
        validAns = true;
    else
        fprintf('You answer (%s) is not a valid response.  Please try again.\n',twoPlayer)
    end
end

if strcmp(twoPlayer,'Y')
    fprintf('\nWelcome!  You have selected a two-player game!\n');
    validAns = false;
    while validAns == false
        p1_color = upper(input('Player 1, would you like to be Blue(B) or Red(R)? [B]: ','s'));
        if isempty(p1_color)
            p1_color = 'B';
        end
        if (or(p1_color == 'B', p1_color == 'R'))
            validAns = true;
            % create text for output and save colors for plot markers
            if strcmp(p1_color,'B')
                p1_color = 'Blue';
                p2_color = 'Red'; 
                p1='b'; p2='r';
            else
                p1_color = 'Red';
                p2_color = 'Blue'; 
                p1='r'; p2='b';
            end
        else
            fprintf('You answer (%s) is not a valid response.  Please try again.\n',p1_color)
        end
    end
    validAns = false;
    while validAns == false
        p2_marker = upper(input('Player 2, would you like to be X''s (X) or O''s (O)? [X]: ','s'));
        if isempty(p2_marker)
            p2_marker = 'X';
        end
        if (or(p2_marker == 'X', p2_marker == 'O'))
            validAns = true;
            if strcmp(p2_marker,'X')
                p1_marker = 'O'; 
            else
                p1_marker = 'X';
            end
        else
            fprintf('You answer (%s) is not a valid response.  Please try again.\n',p2_marker)
        end
    end
else
    fprintf('Sorry, the computer is tired.  Go find a friend to play with.\n\n')
    return;
end
p1 = lower([p1 p1_marker]);
p2 = lower([p2 p2_marker]);
fprintf('\nThank you!  Player 1 will be %s %s''s and Player 2 will be %s %s''s.\n\n',p1_color,p1_marker,p2_color,p2_marker);
fprintf('Directions:\nValid moves (empty squares) are shown on the board as numbered squares 1 to 9.\n')
fprintf('On your turn, must select an empty square to place your marker by selecting \nthe number of the square.\n')
fprintf('\nLet''s play!\n')

%% Play the game
% Define a player sequence (player 1 always starts, followed by player 2, etc. up to 9 moves)
playerSeq = [1 2 1 2 1 2 1 2 1];
squares = 1:9; %define a vector to check against for a valid move
for m = squares %up to 9 moves
    validMove = false;
    while validMove == false
        try % avoid the error printout if a number isn't entered
            prompt = sprintf('\nPlayer %d, please select the number of an empty square for your move: ',playerSeq(m));
            curMove = input(prompt);
        catch
            curMove = 0;  % if not a number set to an invalid move to force another try
        end
        if isempty(curMove)
            curMove = 0; % if empty set to an invalid move to force another try
        end
        % Check for a valid move (i.e. square 1-9), then check if it is an
        % open square; the moves vector shows which player (or none) has
        % moved in that square.
        if (any(squares == curMove)) % the move is a valid square
            if (moves(curMove) == 0) % the square is not already marked
                moves(curMove) = playerSeq(m);
                validMove = true;
                drawBoard(hfig,moves,p1,p2)
            else
                fprintf('That square has already been played! Please try again.\n')
            end
        else
            fprintf('You move (%d) is not a valid square.  Please try again.\n',curMove)
        end
    end %while
    % we have a valid move, check for a win
    winner = checkForWinner(moves,playerSeq(m));
    if (winner == true)
        fprintf('\n\n *** Congratulations, Player %d wins!! ***\n\n',playerSeq(m));
        break;
    end
end
if (winner == false)
    % All moves exhausted without a winner
    fprintf('\n\n --- Cat''s game! Thanks for playing! ---\n\n');
end

%publish('script.m','pdf');


end % function ticTacToe

% ===============================================================================================
function drawBoard(hfig,moves,p1,p2)
% Uses a figure to plot draw a tic-tac-toe board using lines and points
% with markers.  The axis are turned off to look more game board like.  

figure(hfig); clf; hold on; axis off;

%draw boxes
plot([0 3], [1 1],'k-',[0 3], [2 2],'k-');  % plot the two horizontal lines
plot([1 1], [0 3],'k-',[2 2], [0 3],'k-');  % plot the two verticle lines

% Define the x, y coordinates for the 9 markers in the squares
nPositions = 9;
positions = [0 2; 1 2; 2 2; ...
             0 1; 1 1; 2 1; ...
             0 0; 1 0; 2 0] + 0.5; %add 0.5 to all coordinates to push them to the middle of the square

% Define the squares as 1-9
positionNums = 1:9;

% For each posible move (position on the board), mark it as 
%   0:  unplayed -- use the text function to identify the square (1-9)
%   1:  player 1 -- use the marker defined by the user input
%   2:  player 2 -- use the marker defined by the user input
% Use text properties and line properties to make the markers big
for p = 1:nPositions
    switch moves(p)
        case 0
            text(positions(p,1),positions(p,2),num2str(positionNums(p)),'FontSize',20);
        case 1
            plot(positions(p,1),positions(p,2),p1,'MarkerSize',30)
        case 2
            plot(positions(p,1),positions(p,2),p2,'MarkerSize',30)
    end %switch 
end %for
    
end % function drawBoard


% ===============================================================================================
function winner = checkForWinner(moves,player)
% Check the moves for a winnner.
winner = false; % initialize to false

% Using the positions assigned, define the 8 ways to win
ways_to_win = 8;
wins = [ 1 2 3; ... row 1
         4 5 6; ... row 2
         7 8 9; ... row 3
         1 4 7; ... col 1
         2 5 8; ... col 2
         3 6 9; ... col 3
         1 5 9; ... diag 1
         3 5 7; ... diag 2
         ];

% Define the endpoints of the line that draws through each win.  Each row corresponds to  
% a wins row. Columns 1-2 are the x-points, columns 3-4 are the y-points used to draw the 
% win line.
win_line = [ 0 3   2.5 2.5; ... row 1
             0 3   1.5 1.5; ... row 2
             0 3   0.5 0.5; ... row 3
             0.5 0.5   0 3; ... col 1
             1.5 1.5   0 3; ... col 2
             2.5 2.5   0 3; ... col 3
             0 3   3 0; ... diag 1
             0 3   0 3; ... diag 2
             ];

% find all the squares (moves) by the player by comparing the moves vector
% to the the player number.  This returns a vector of logical 1 or 0.  The
% find function then gives all the indicies that are non-zero.  These
% indices map to the squares so we can check them against each of the wins.
%  We check them by using the intersect function.  If the player moves
%  intersect with all three of the squares defined in one of the wins, then
%  the player has won and we plot the win line.
player_moves = find(moves == player);
for w = 1:ways_to_win
    matching_moves = intersect(wins(w,:),player_moves);
    if (length(matching_moves) == 3) 
        winner = true;
        plot(win_line(w,1:2),win_line(w,3:4),'g-','LineWidth',2);
        break;
    end
end

end %function checkForWinner