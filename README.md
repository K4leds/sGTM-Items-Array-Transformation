# sGTM Items Array Transformation

A server-side Google Tag Manager variable template that transforms the GA4
`items` array before it is sent on.

Returns a new array; the incoming event data is never mutated. If the source
does not resolve to an array, the variable returns `undefined`.

## What it does

Sections run in a fixed order, which is also the order they appear in the UI:

1. **Item filtering** — keep only, or drop, whole items by field conditions.
2. **Parameter actions** — drop empty parameters, always drop named ones, or
   add, drop and replace parameters when a condition matches.
3. **Value transformation** — find and replace inside values, literal or regex.
4. **Data type casting** — coerce named keys to number, integer or string.
5. **Added values** — static key-value pairs, plus an optional per-item index.
6. **Key mapping** — rename keys, optionally discarding unmapped ones.

Contains, Equals, Starts With, Ends With and Regex matching are available
throughout. Matching is case-insensitive unless a section opts in.

## Notes on behavior

- Within parameter actions, every condition is evaluated against the item as
  it was when the section started, so rules cannot cascade into one another
  and the result does not depend on rule order.
- For the same key, an explicit new value wins over a drop.
- An invalid regex skips its own rule and logs a message, rather than failing
  the whole variable.
- Key mapping runs last, so rules in earlier sections match original key
  names.
- With "keep only" filtering and an empty rule table, the array comes back
  empty.

## Installation

1. In a server container, go to **Templates** → **Variable Templates** → **New**.
2. From the editor menu choose **Import**, and select `template.tpl`.
3. Save, then create a variable from the template.

## Required permissions

- `read_event_data` — to read the incoming `items` array
- `logging` — to log skipped rules and invalid regex patterns

## Tests

The template ships with test cases in its `___TESTS___` section. Open it in the
Template Editor and click **Run Tests**.

## License

Copyright 2026 Khaled Saif

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
