__all__ = ("configure",)


def configure(repl):
    repl.confirm_exit = False
    repl.vi_mode = True
    repl.show_line_numbers = False
