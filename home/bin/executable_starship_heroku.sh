#!/bin/bash
heroku_login=$(
    awk '/api.heroku.com/ {f=NR} f&&f+1==NR {print $2}' ~/.netrc | 
        sed 's/denis@cornehl.org//g' | 
        sed 's/denis.cornehl@thermondo.de//g' 
)

if [ -z "$HEROKU_APP" ]
then
    heroku_app=""
else
    heroku_app=$(
        echo $HEROKU_APP | 
            sed 's/automagically-/ /g' | 
            sed 's/medicaljobs-/MJ /g' | 
            sed 's/thermondo-/⭘ /g'  
        )
fi

echo $heroku_app $heroku_login
