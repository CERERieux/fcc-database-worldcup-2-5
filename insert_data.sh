#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TEAMS=("TEST")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #
  if [[ $YEAR != "year" ]]
  then
    #echo $YEAR $ROUND $WINNER
    #check for Winner, if it already exist, just get the ID
    if [[ "${TEAMS[*]}" =~ "$WINNER" ]]
    then
      TEAM_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    else
    #if winner don't exist in db insert it
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #get the new id from the team inserted
      TEAM_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #insert team into the array
      TEAMS+=("$WINNER")
    fi
    
    #check for Opponent, if it already exist, just get the ID
    if [[ "${TEAMS[*]}" =~ "$OPPONENT" ]]
    then
      TEAM_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    else
    #if opponent don't exist in db insert it
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #get the new id from the team inserted
      TEAM_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #insert team into the array
      TEAMS+=("$OPPONENT")
    fi
    
    #Insert game into games
    echo $($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $TEAM_WIN_ID, $TEAM_OPP_ID)")
  fi
done
