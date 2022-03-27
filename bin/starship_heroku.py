#!/usr/bin/env python3
import netrc
import os


def get_account():
    n = netrc.netrc(os.path.expanduser("~/.netrc"))

    login, _, _ = n.authenticators("api.heroku.com")

    if login == "denis@cornehl.org":
        return ""
    elif login == "denis.cornehl@thermondo.de":
        return ""
    else:
        return login


def get_app():
    app = os.getenv("HEROKU_APP", "")
    app = app.replace("automagically-", " ")
    app = app.replace("medicaljobs-", "MJ ")
    app = app.replace("thermondo-", "⭘ ")
    return app


print(f"{get_app()} {get_account()}".strip())
