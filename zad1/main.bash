#!/bin/bash

draw_board() {
    clear
    echo "  ${board[0]} | ${board[1]} | ${board[2]} "
    echo " -----------"
    echo "  ${board[3]} | ${board[4]} | ${board[5]} "
    echo " -----------"
    echo "  ${board[6]} | ${board[7]} | ${board[8]} "
}

check_game_over() {
    local player=$1

    # Sprawdzanie poziomo
    for ((i = 0; i < 9; i += 3)); do
        if [[ ${board[$i]} == $player && ${board[$i]} == ${board[$((i + 1))]} && ${board[$i]} == ${board[$((i + 2))]} ]]; then
            echo "$player"
            return 0
        fi
    done

    # Sprawdzanie pionowo
    for ((i = 0; i < 3; i++)); do
        if [[ ${board[$i]} == $player && ${board[$i]} == ${board[$((i + 3))]} && ${board[$i]} == ${board[$((i + 6))]} ]]; then
            echo "$player"
            return 0
        fi
    done

    # Sprawdzanie po przekątnych
    if [[ ${board[0]} == $player && ${board[0]} == ${board[4]} && ${board[0]} == ${board[8]} ]]; then
        echo "$player"
        return 0
    fi
    if [[ ${board[2]} == $player && ${board[2]} == ${board[4]} && ${board[2]} == ${board[6]} ]]; then
        echo "$player"
        return 0
    fi

    # Sprawdzanie remisu
    if ! [[ "${board[*]}" =~ [[:digit:]] ]]; then
        echo "Draw"
        return 0
    fi
    return 1
}

is_valid_move() {
    local move=$1
    [[ ${board[$((move - 1))]} == [[:digit:]] ]]
}

display_menu() {
    echo "Witaj w grze Kółko i Krzyżyk!"
    echo "1. Nowa gra"
    echo "2. Wyjdź"
}

while true; do
    display_menu
    read -p "Wybierz opcję: " option
    case $option in
    1)
        board=(1 2 3 4 5 6 7 8 9)
        current_player="X"
        game_over=false
        while ! $game_over; do
            draw_board
            read -p "Gracz $current_player, wybierz pole (1-9): " move
            if [[ $move =~ ^[1-9]$ ]] && is_valid_move "$move"; then
                board[$((move - 1))]="$current_player"
                if result=$(check_game_over "$current_player"); then
                    draw_board
                    if [[ "$result" == "Draw" ]]; then
                        echo "Remis!"
                    else
                        echo "Wygrał gracz $result"
                    fi
                    game_over=true
                else
                    current_player=$(if [[ $current_player == "X" ]]; then echo "O"; else echo "X"; fi)
                fi
            else
                echo "Nieprawidłowy ruch. Spróbuj ponownie."
            fi
        done
        ;;
    2)
        echo "Dziękujemy za grę!"
        exit 0
        ;;
    *)
        echo "Nieprawidłowa opcja. Spróbuj ponownie."
        ;;
    esac
done
