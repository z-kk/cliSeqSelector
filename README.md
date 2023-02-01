# cliSeqSelector
Nim library seq selector in CLI

## Usage

### Select from string list

```nim
import cliSeqSelector
let
  list = @["item1", "item2", "item3", "item4", "item5"]
  res = list.select("message")
```
```
$ ./yourAppName
message
> item1
```
press Down or 'j' then
```
$ ./yourAppName
message
> item2
```
press Right or 'l' or 'G' then
```
$ ./yourAppName
message
> item5
```
press Up or 'k' then
```
$ ./yourAppName
message
> item4
```
press Enter then
```nim
res.val == "item4"
res.idx == 3
```

### Select from enum

```nim
type
  sample = enum
    item1
    item2
    item3
    item4
    item5
let res = sample.select("message")
```
display contents is same as string list.
```nim
res == sample.itemx
```

### proc definitions

```nim
proc select*(list: seq[string], idx = 0): tuple[val: string, idx: int]
proc select*(list: seq[string], message: string, idx = 0): tuple[val: string, idx: int]
proc select*[T: enum](enm: typedesc[T]): T
proc select*[T: enum](enm: typedesc[T], val: T): T
proc select*[T: enum](enm: typedesc[T], message: string): T
proc select*[T: enum](enm: typedesc[T], message: string, val: T): T
```
