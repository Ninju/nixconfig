(defsrc
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  caps a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt           spc            ralt rmet cmp  rctl
)

(defalias
  num  (layer-toggle numbers) ;; Bind num to a button that switches to a layer
  kil  C-A-del                ;; Bind kil to a button that Ctrl-Alt-deletes
)

(deflayer qwerty
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  caps a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl @num lalt           spc            ralt rmet cmp rctl
)

(deflayer numbers
  _    _    _    _    _    _    _    _    _    _    _    _    _    _
  _    _    _    _    _    XX   /    7    8    9    -    _    _    _
  _    _    _    _    _    XX   *    4    5    6    +    _    _
  _    _    \(   \)   .    XX   0    1    2    3    _    _
  _    _    _              _              _    _    _    _
)
