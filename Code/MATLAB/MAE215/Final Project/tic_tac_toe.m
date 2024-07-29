function tic_tac_toe()
% initialize the game board
board = zeros(3, 3);
% initialize the player
player = 1;

% game loop
while true
    % print the current state of the board
    disp(board);
    % get the player's move
    [row, col] = get_move(board, player);
    % update the board
    board(row, col) = player;
    % check if the game is over
    if check_win(board)
        disp(['Player ', num2str(player), ' wins!']);
        break;
    elseif check_tie(board)
        disp('Game over. It is a tie!');
        break;
    end
    % switch to the other player
    player = 3 - player;
end
end

function [row, col] = get_move(board, player)
% get the player's move
while true
    prompt = ['Player ', num2str(player), ', enter your move [row, col]: '];
    move = input(prompt);
    if board(move(1), move(2)) == 0
        row = move(1);
        col = move(2);
        break;
    else
        disp('Invalid move. Please try again.');
    end
end
end

function win = check_win(board)
% check if the game is won
win = false;
% check rows
for row = 1:3
    if all(board(row, :) == board(row, 1)) && board(row, 1) ~= 0
        win = true;
        return;
    end
end
% check columns
for col = 1:3
    if all(board(:, col) == board(1, col)) && board(1, col) ~= 0
        win = true;
        return;
    end
end
% check diagonals
if all(diag(board) == board(1, 1)) && board(1, 1) ~= 0
    win = true;
    return;
elseif all(diag(flip(board)) == board(1, 3)) && board(1, 3) ~= 0
    win = true;
    return;
end
end

function tie = check_tie(board)
% check if the game is tied
tie = all(board(:) ~= 0);
end
