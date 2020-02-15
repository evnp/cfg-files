#!/usr/bin/env python3.7

import asyncio
import iterm2
import subprocess

from datetime import datetime
from os.path import expanduser

date = None
typed = 0
committed = 0


async def main(connection):
    app = await iterm2.async_get_app(connection)
    tasks = {}

    component = iterm2.StatusBarComponent(
        short_description="KeyScore: keystroke counter",
        detailed_description="KeyScore: see how many keys yout press each day. Go for the high score!",
        knobs=[],
        exemplar="[esc]",
        update_cadence=None,
        identifier="com.iterm2.keyscore",
    )

    async def reset(session):
        await asyncio.sleep(2)
        await session.async_set_variable("user.showEscIndicator", False)

    async def keystroke_handler(keystroke):
        """This function is called every time a key is pressed."""

        # There might not be a current session, so there might be an exception
        # while trying to get it.
        try:
            session = app.current_terminal_window.current_tab.current_session
        except Exception:
            return

        global date
        global typed
        global committed

        today = datetime.now().date()
        home = expanduser("~")
        filename = "{}/keyscore".format(home)

        def touch():
            subprocess.call("touch {}".format(filename).split())

        def last_line():
            return subprocess.check_output('tail -1 {}'.format(filename).split())

        def delete_last_line():
            why is this fucker not working
            subprocess.call(['sed', '-i', '', '-e', '$ d', filename])

        # if typed counter hasn't started, try to load from file
        #if not typed:
            touch()

            try:
                date, typed, committed = last_line().split()
                date, typed, committed = (
                    datetime.strptime(date, '%d-%m-%Y').date(),
                    int(typed),
                    int(committed),
                )
            except Exception:
                date = today
                typed = 0
                committed = 0

        # back up to file every 10 keystrokes
        #if not typed % 10:
            touch()

            date = last_line().split()[0]

            if date != today.strftime('%d-%m-%Y'):
                date = today.strftime('%d-%m-%Y')
            else:
                delete_last_line()

            with open(filename, "a+") as f:
                f.write("{} {} {}\n".format(date, typed, committed))

        typed += 1

        await session.async_set_variable("user.keyscore", typed)

    # The user variable `keyscore` is used as a communications channel
    # between the keyboard monitor and the status bar component coro. Since it
    # may not always be defined (e.g., when a new session is created) it must be
    # labeled as optional with the trailing ? to prevent an exception.
    @iterm2.StatusBarRPC
    async def coro(
        knobs,
        keyscore=iterm2.Reference("user.keyscore?"),
        session_id=iterm2.Reference("id"),
    ):
        """This function gets called when keyscore changes in any
        session."""
        if keyscore:
            if session_id in tasks:
                tasks[session_id].cancel()
                del tasks[session_id]

            task = asyncio.create_task(reset(app.get_session_by_id(session_id)))
            tasks[session_id] = task
            return "typed {} committed {}".format(format(typed, ",d"), date)
        else:
            return ""

    # Register the status bar component.
    await component.async_register(connection, coro)

    # Monitor the keyboard
    async with iterm2.KeystrokeMonitor(connection) as monitor:
        while True:
            keystroke = await monitor.async_get()
            await keystroke_handler(keystroke)


iterm2.run_forever(main)
