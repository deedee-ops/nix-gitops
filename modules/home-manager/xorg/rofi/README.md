# rofi themes

> source: <https://github.com/adi1090x/rofi>

To convert hardcoded `px` units in themes, to relative `em` counterparts, use this ruby script:

```ruby
File.write('output.rasi', File.read('input.rasi').gsub(/[0-9]+px/) { |size| "#{(size[0..-3].to_i / 18.0).round(3)}em" })
```

## Invocation commands

| View           | Command                                                    |
|----------------|------------------------------------------------------------|
| Applications   | `rofi -show drun -theme ~/.config/rofi/drun/config.rasi`   |
| Active Windows | `rofi -show window -theme ~/.config/rofi/drun/config.rasi` |
