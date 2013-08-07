/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]        = "-*-*-medium-*-*-*-11-*-*-*-*-*-*-*";
static const char normbgcolor[] = "#090909";
static const char normfgcolor[] = "#FFFFFF";
static const char selbgcolor[]  = "#090909";
static const char selfgcolor[]  = "#07CD01";
static const char before[]      = "<";
static const char after[]       = ">";
static const int  tabwidth      = 180;
static const Bool foreground    = True;

/*
 * Where to place a new tab when it is opened. When npisrelative is True,
 * then the current position is changed + newposition. If npisrelative
 * is False, then newposition is an absolute position.
 */
static int  newposition   = 0;
static Bool npisrelative  = False;

#define MODKEY ControlMask
static Key keys[] = { \
	/* modifier                     key        function        argument */
	{ MODKEY|ShiftMask,             XK_Return, focusonce,      { 0 } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          { 0 } },

	{ MODKEY|ShiftMask,             XK_l,      rotate,         { .i = +1 } },
	{ MODKEY|ShiftMask,             XK_h,      rotate,         { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,      movetab,        { .i = -1 } },
	{ MODKEY,             			XK_Right,  rotate,         { .i = +1 } },
	{ MODKEY,             			XK_Left,   rotate,         { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_Right,  movetab,        { .i = +1 } },
	{ MODKEY|ShiftMask,             XK_Left,   movetab,        { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_k,      movetab,        { .i = +1 } },
	{ MODKEY,                       XK_Tab,    rotate,         { .i = 0 } },

	{ MODKEY,                       XK_1,      move,           { .i = 0 } },
	{ MODKEY,                       XK_2,      move,           { .i = 1 } },
	{ MODKEY,                       XK_3,      move,           { .i = 2 } },
	{ MODKEY,                       XK_4,      move,           { .i = 3 } },
	{ MODKEY,                       XK_5,      move,           { .i = 4 } },
	{ MODKEY,                       XK_6,      move,           { .i = 5 } },
	{ MODKEY,                       XK_7,      move,           { .i = 6 } },
	{ MODKEY,                       XK_8,      move,           { .i = 7 } },
	{ MODKEY,                       XK_9,      move,           { .i = 8 } },
	{ MODKEY,                       XK_0,      move,           { .i = 9 } },

	{ MODKEY,                       XK_q,      killclient,     { 0 } },
	{ 0,                            XK_d,      killclient,     { 0 } },

	{ 0,                            XK_F11,    fullscreen,     { 0 } },
};

