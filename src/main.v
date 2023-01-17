module main

import term
import term.ui as tui
import os

struct AppConfig {
mut:
	editor_mode bool = false
}

const appcfg = AppConfig{}

struct App {
mut:
    tui &tui.Context = 0
}

fn event(e &tui.Event, x voidptr) {
    if e.typ == .key_down && e.code == .q && !appcfg.editor_mode {
        exit(0)
    }
	if e.typ == .key_down && e.code == .i && !appcfg.editor_mode  {
        appcfg.editor_mode = true
    }
    if e.typ == .key_down && e.code == .escape && !appcfg.editor_mode {
        appcfg.editor_mode = true
    }
}

fn frame(x voidptr) {
    mut app := &App(x)
	mut text := ""

    app.tui.clear()
    app.tui.draw_text(0, 0, '---- notee ----')

	if appcfg.editor_mode {
		text = os.get_line()
	    app.tui.set_cursor_position(0, 0)
    }
	app.tui.draw_text(1, 0, text)
    app.tui.reset()
    app.tui.flush()
}

fn main() {
    mut app := &App{}
    app.tui = tui.init(
        user_data: app
        event_fn: event
        frame_fn: frame
        hide_cursor: true
		window_title: term.header("notee", " ")
	)

    app.tui.run()?

}
