function _tide_item_heroku
    set app (echo $HEROKU_APP | sed "s/thermondo-/(t°)-/")

    if test ! -z $app
        set_color blue
        echo " $app"
    end
end
