#!/usr/bin/env bash

# Add here birthdays in the following format
B_DAYS=(
    "01-01  Name Surname"
)

days_until_next_bday=365
next_in_line=""

for d in "${B_DAYS[@]}"; do
    birth_day=${d%%[[:space:]]*}
    name=${d#*[[:space:]]}

    ## Calculate the closest birthday ##
    closer_year=$(date +'%4Y')
    today=$(date +'%F')
    birth_day_date="$closer_year"-"$birth_day"

    if [[ $today > $birth_day_date ]]; then
        # The next celebration is next year
        closer_year=$(date -d '1 year' +'%4Y')
    fi

    birth_day_date="$closer_year"-"$birth_day"
    ## ----- ##

    birthday_seconds=$(date -d ""$birth_day_date" + 1 day" +'%s')
    current_seconds=$(date +'%s')

    num_days_until_bday=$(( ("$current_seconds" - "$birthday_seconds") / 86400 * -1))
    if [[ "$num_days_until_bday" -lt "$days_until_next_bday" ]]; then
        days_until_next_bday="$num_days_until_bday"
        next_in_line="$name"
    fi
done

msg="<b>"$next_in_line"</b> festeggierà il suo compleanno tra "$days_until_next_bday" giorni!"
class="no-style"

if [[ "$days_until_next_bday" -eq 0 ]]; then
    class="bday"
    msg="È il compleanno di <b>"$next_in_line"</b>!"
elif [[ "$days_until_next_bday" -eq 1 ]]; then
    class="countdown"
    msg="Domani è il compleanno di <b>"$next_in_line"</b>!"
elif [[ "$days_until_next_bday" -lt 4 ]]; then
    class="countdown"
fi

printf '{"text": "  ", "tooltip":"%s", "amount": "%d", "class":"%s"}\n' "$msg" "$days_until_next_bday" "$class"
