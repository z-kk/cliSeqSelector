import
  std / [terminal, enumutils, typetraits]

proc show(item: string, prefix = "> ") =
  ## Show selected item.
  stdout.eraseLine
  stdout.write prefix, item

proc select*(list: seq[string], idx = 0): tuple[val: string, idx: int] =
  ## Select item from string list.
  result.idx =
    if idx < 0:
      -1
    elif idx > list.high:
      list.high
    else:
      idx

  if result.idx in 0 .. list.high:
    result.val = list[result.idx]
    result.val.show

  var prevChars: seq[int]
  while true:
    let ch = getch()
    case ch.ord
    of 3:  # CTRL-C
      stdout.eraseLine
      raise newException(CatchableError, "Pressed Ctrl-C")
    of 13:  # Enter
      echo ""
      break
    of 27, 91:  # Up/Down/Right/Left prefix
      prevChars.add ch.ord
    of 65 .. 68:  # Up/Down/Right/Left suffix
      if prevChars != @[27, 91]:
        continue
      case ch.ord:
      of 65:  # Up
        if result.idx < 1:
          result.idx = 0
        else:
          result.idx.dec
      of 66:  # Down
        if result.idx < list.high:
          result.idx.inc
        else:
          result.idx = list.high
      of 67:  # Right
        result.idx = list.high
      of 68:  # Left
        result.idx = 0
      else: discard
      prevChars = @[]
    else:
      prevChars = @[]
      case ch
      of 'j', 'n':  # next
        if result.idx < list.high:
          result.idx.inc
        else:
          result.idx = list.high
      of 'k', 'p':  # prev
        if result.idx < 1:
          result.idx = 0
        else:
          result.idx.dec
      of 'h', 'H', 'g':  # head
        result.idx = 0
      of 'l', 'L', 'G':  # bottom
        result.idx = list.high
      else: discard

    if result.idx in 0 .. list.high:
      result.val = list[result.idx]
      result.val.show

proc select*(list: seq[string], message: string, idx = 0): tuple[val: string, idx: int] =
  ## Display message and select item from string list.
  echo message
  return list.select(idx)

proc select*[T: OrdinalEnum](enm: typedesc[T], val: T): T =
  ## Select enum.
  var list: seq[string]
  for item in enm:
    list.add $item
  return enm(list.select(val.ord - enm.low.ord).idx + enm.low.ord)

proc select*[T: OrdinalEnum](enm: typedesc[T]): T =
  ## Select enum.
  return enm.select(enm.low)

proc select*[T: OrdinalEnum](enm: typedesc[T], message: string, val: T): T =
  ## Display message and select enum.
  echo message
  return enm.select(val)

proc select*[T: OrdinalEnum](enm: typedesc[T], message: string): T =
  ## Display message and select enum.
  return enm.select(message, enm.low)

proc select*[T: HoleyEnum](enm: typedesc[T], val: T): T =
  ## Select enum.
  var
    strList: seq[string]
    enmList: seq[T]
    idx, i = -1
  {.push warning[HoleEnumConv]: off.}
  for item in enumutils.items(enm):
    strList.add $item
    enmList.add item
    i.inc
    if item == val:
      idx = i
  {.pop.}
  return enmList[strList.select(idx).idx]

proc select*[T: HoleyEnum](enm: typedesc[T]): T =
  ## Select enum.
  return enm.select(enm.low)

proc select*[T: HoleyEnum](enm: typedesc[T], message: string, val: T): T =
  ## Display message and select enum.
  echo message
  return enm.select(val)

proc select*[T: HoleyEnum](enm: typedesc[T], message: string): T =
  ## Display message and select enum.
  return enm.select(message, enm.low)
