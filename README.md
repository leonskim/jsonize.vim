# jsonize.vim

Pretty-print and **structure** almost-JSON so it *looks* like JSON — **no jq**, and **no value changes**.

This plugin was born from the need to quickly inspect debug output that isn’t valid JSON. Single-line, unquoted, or partially structured data that `jq` can’t parse while keeping the original values visible.

This plugin is intentionally conservative: it quotes keys and single-quoted strings, fixes commas/newlines/indentation, and removes trailing commas — but it **does not normalize values** like `NaN`, `Infinity`, `undefined`, or placeholders such as `[Object]` / `[Array]`. Those are preserved verbatim.

---

## What It Does (Structure-only)

- Quotes **unquoted object keys** → `"key": value`
- Converts **'single-quoted strings'** → `"double-quoted strings"`
- Adds consistent **newlines** and **indentation**
- **Removes trailing commas** before `]` or `}`
- Tidies up extra spaces/line breaks

What it **does not** do:

- ❌ No parsing or validation (output may not be valid JSON)
- ❌ No value normalization (keeps `NaN`, `Infinity`, `undefined`, `[Object]`, `[Array]`, etc.)
- ❌ No type coercion or schema checks

---

## Requirements

- Vim 8+ or Neovim
- No external tools required

---

## Installation

**vim-plug**

```vim
Plug 'leonskim/jsonize.vim'
```
**Vundle**

```vim
Plugin 'leonskim/jsonize.vim'
```

**packer.nvim**

```lua
use 'leonskim/jsonize.vim'
```

Restart Vim/Neovim and run `:helptags ALL` if needed.

---

## Key Mappings

- **Visual mode** → `<leader>jf` formats the selected text
- **Normal mode** → `<leader>jf` runs `:Jsonize` (defaults to whole buffer)


---

## Commands

- `:Jsonize` — Format entire buffer
- `:[range]Jsonize` — Format only the given range

**Examples**

```vim
:Jsonize
:42Jsonize
:3,15Jsonize
:'<,'>Jsonize
:%Jsonize
```

---

## Examples (Structure preserved, values unchanged)

**Input**

```js
{ user: 'alice', plan: Pro, lastLogin: NaN, meta: [Object] }
```

**Output**

```json
{
  "user": "alice",
  "plan": Pro,
  "lastLogin": NaN,
  "meta": [Object]
}
```

**Input**

```js
[
  {id:1, name:'A', extra:[Array], price:Infinity},
  {id:2, name:'B', extra:[Object], price:undefined},
]
```

**Output**

```json
[
  {
    "id": 1,
    "name": "A",
    "extra": [Array],
    "price": Infinity
  },
  {
    "id": 2,
    "name": "B",
    "extra": [Object],
    "price": undefined
  }
]
```

> Note: Trailing commas are removed, keys/strings are quoted, spacing/indentation are normalized. Values like `Infinity`, `NaN`, `undefined`, `[Object]`, `[Array]` are **left as-is**.

---

## Caveats

- The result **looks** like JSON but may not be valid JSON because special tokens are preserved.
- If you need strict JSON, run a real normalizer/serializer after inspection (e.g., convert `NaN`/`Infinity`/`undefined` to `null` in your pipeline).

---

## License

MIT License — © [Leon Kim](https://github.com/leonskim)
