import unittest

import cliSeqSelector

const
  PressEnterMsg = "Press Enter"

suite "select item":
  let list = @["item1", "item2", "itm3", "itm4", "item5", "item6"]

  test "cancel":
    try:
      discard list.select("Press Ctrl-C")
      check false
    except:
      check getCurrentExceptionMsg() == "Pressed Ctrl-C"

  test "first":
    let
      ans = 0
      res = list.select(PressEnterMsg)
    check res.idx == ans
    check res.val == list[ans]

  test "last":
    let
      ans = list.high
      res = list.select(PressEnterMsg, ans)
    check res.idx == ans
    check res.val == list[ans]

  test "out of index":
    let
      ans = -1
    var
      res = list.select(PressEnterMsg, ans)
    check res.idx == ans
    check res.val == ""

    res = list.select(PressEnterMsg, -5)
    check res.idx == ans
    check res.val == ""

  test "select item":
    let
      ans = 3
      res = list.select("Select " & list[ans])
    check res.idx == ans
    check res.val == list[ans]

suite "select enum":
  type
    testEnum = enum
      item1
      item2 = "itm2"
      item3 = 5
      item4
      item5 = (10, "itm5")
      item6

  test "first":
    let
      ans = testEnum.low
      res = testEnum.select(PressEnterMsg)
    check res == ans

  test "last":
    let
      ans = testEnum.high
      res = testEnum.select(PressEnterMsg, ans)
    check res == ans

  test "select enum":
    let
      ans = item5
      res = testEnum.select("Select " & $ans)
    check res == ans
