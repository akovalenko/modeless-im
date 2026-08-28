# modeless-im

Modeless (non-toggling) input method commands for Emacs.

Emacs traditionally binds a single key (`C-\`) that *toggles* the
current input method. When you know exactly which state you want, a
toggle forces you to check the current state first. modeless-im
provides commands that set the input method state directly — one key
always turns it on, another always turns it off — in ordinary buffers
as well as in isearch (which manages its own input method state and
needs dedicated commands).

## Usage

```elisp
(require 'modeless-im)
;; S-<f11> always turns the input method on, S-<f12> always turns it off
(modeless-im-define-keys '("S-<f11>") '("S-<f12>"))
```

Or bind the individual commands yourself:

- `modeless-im-turn-on` / `modeless-im-turn-off`
- `modeless-im-isearch-turn-on` / `modeless-im-isearch-turn-off` (for
  `isearch-mode-map`)

## Installation

Until the package lands in an archive, install manually — e.g. put
`modeless-im.el` on your `load-path`, or:

```elisp
(use-package modeless-im
  :vc (:url "https://github.com/akovalenko/modeless-im")
  :config
  (modeless-im-define-keys '("S-<f11>") '("S-<f12>")))
```

## License

This is free and unencumbered software released into the public
domain — see [UNLICENSE](UNLICENSE).
