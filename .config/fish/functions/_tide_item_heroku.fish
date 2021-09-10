function _tide_item_heroku
    set app (echo $HEROKU_APP | sed "s/thermondo-/(t°)-/")

    if test ! -z $app
        _tide_print_item heroku " $app"
    end
end
