;; Best to make sure that no setxkbmap variant is set (i.e. it's qwerty)
;; Otherwise weird stuff happens no matter what `defsrc` is set to..

(defsrc ;; qwerty
  esc  f1  f2  f3  f4  f5  f6  f7  f8  f9  f10 f11 f12 home end ins del
  `    1    2    3    4    5    6    7    8    9    0    -    =     bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]
  caps a    s    d    f    g    h    j    k    l    ;    '          ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
       lctl lmet lalt       spc           ralt prnt rctl  pgup up   pgdn
                                                          lft  down rght
)

(defalias
  ext  (tap-next esc (layer-toggle extend))

  cpy C-S-c
  pst C-S-v
)

(deflayer colemak
  esc  f1  f2  f3  f4  f5  f6  f7  f8  f9  f10 f11 f12 home end ins del
  `    1    2    3    4    5    6    7    8    9    0    -    =     bspc
  tab  q    w    f    p    g    j    l    u    y    ;    [    ]
  @ext a    r    s    t    d    h    n    e    i    o    '          ret
  lsft z    x    c    v    b    k    m    ,    .    /    rsft
       lctl lmet lalt       spc           ralt prnt rctl  pgup up   pgdn
                                                          lft  down rght
)

(deflayer colemak-2
  esc  f1  f2  f3  f4  f5  f6  f7  f8  f9  f10 f11 f12 home end ins del
  `    1    2    3    4    5    6    7    8    9    0    -    =     bspc
  tab  q    w    f    p    g    j    l    u    y    ;    [    ]
  @ext a    r    s    t    d    h    n    e    i    o    '          ret
  lsft z    x    c    v    b    k    m    ,    .    /    rsft
       lctl lmet lalt       spc           ralt prnt rctl  pgup up   pgdn
                                                          lft  down rght
)

(deflayer extend
  _    _   _   _   _   _   _   _   _   _   _   _   _   _    _   _   _
  _    _    _    _    _    _    _    _    _    _    _    _    _     _
  _    _    _    _    _    [    ]    home up   end  _    _    _
  _    lalt _    lsft lctl \(   \)   lft  down rght bspc _          _
  _    _    _    @cpy @pst {    }    _    _    _    _    _
       _    _    _          ret           _    _    _     _    _    _
                                                          _    _    _
)

(deflayer empty
  _    _   _   _   _   _   _   _   _   _   _   _   _   _    _   _   _
  _    _    _    _    _    _    _    _    _    _    _    _    _     _
  _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    _    _    _    _    _    _    _          _
  _    _    _    _    _    _    _    _    _    _    _    _
       _    _    _          _             _    _    _     _    _    _
                                                          _    _    _
)
