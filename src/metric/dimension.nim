#
# metric - bringing the SI to Nim.
#
# (c) Copyright 2018 Michael Jendrusch. All rights reserved.
# This library is licensed under the MIT license.
# For more information see LICENSE.

import macros
import algorithm, sequtils, tables

type
  BaseDimension* = object {. pure, inheritable .} ## \
    ## The basic dimension object all dimensions should inherit from.
  SomeDimension* = concept type Dim
    ## A concept ensuring a matched type inherits from ``BaseDimension``.
    var
      x: ptr Dim
      y: ptr BaseDimension
    y = x
  ProductDimension*[X: tuple] = object of BaseDimension ## \
    ## A type encoding a product of dimensions inside a static parameter.
    ## The designated type for ``X`` may be ``static[auto]``, but is actually
    ## a static tuple of arbitrary length. ``static[auto]`` seems to be the
    ## only way of actually matching this.
  QuotientDimension*[X, Y] = object of BaseDimension ## \
    ## A type encoding a quotient of two dimensions in its type parameters.
  DimensionLess* = object of BaseDimension ## \
    ## A special dimension type encoding the lack of dimensionality, that is
    ## [1] in units.

proc mulImpl(x, y: NimNode): NimNode
proc divImpl(x, y: NimNode): NimNode
proc powImpl(x: NimNode; y: int): NimNode

proc expandTypeInstImpl(node: NimNode): NimNode =
  ## Recursively expands symbol nodes using ``getTypeInst``.
  if node.kind == nnkSym:
    let
      typeInst = node.getTypeInst
    if typeInst.len > 1:
      let
        typ = typeInst[1]
      return expandTypeInstImpl(typ)
    else:
      let
        impl = typeInst.getImpl
      if impl.kind == nnkTypeDef:
        let
          body = impl[2]
        if body.kind == nnkObjectTy:
          return node
        else:
          return expandTypeInstImpl(body)
      return typeInst
  elif node.kind == nnkInfix:
    case $node[0]
    of "*":
      return expandTypeInstImpl mulImpl(node[1], node[2])
    of "/":
      return expandTypeInstImpl divImpl(node[1], node[2])
    of "^":
      return expandTypeInstImpl powImpl(node[1], int node[2].intVal)
    else:
      error("internal error: expandTypeInstImpl. This should not be possible. Please submit an issue on GitHub so we can fix it.")

  result = node.copyNimNode
  for child in node.children:
    result.add expandTypeInstImpl(child)

proc expandTypeInst(node: NimNode): NimNode =
  ## Expands a type node using ``getTypeInst``, until all generic parameters
  ## are resolved.
  result = expandTypeInstImpl node

proc getTerms(dims: NimNode): seq[NimNode] =
  ## Retrieves all symbols inside a dimension or product dimension.
  result = newSeq[NimNode]()
  if dims.kind == nnkBracketExpr and dims[0].eqIdent("ProductDimension"):
    for dim in dims[1]:
      result.add ident($dim)
  elif dims.kind in {nnkSym, nnkIdent}:
    result.add ident($dims)
  else:
    error("internal error: getTerms. This should not be possible. Please submit an issue on GitHub so we can fix it.")
  result.sort(proc(x, y: NimNode): int = cmp($x, $y))

proc getNumDen*(dims: NimNode): tuple[num, den: seq[NimNode]] =
  ## Retrieves all symbols in the numerator of a dimension.
  let
    expanded = dims.expandTypeInst
  case expanded.kind
  of nnkBracketExpr:
    if expanded[0].eqIdent("QuotientDimension"):
      result.num = getTerms(expanded[1])
      result.den = getTerms(expanded[2])
    elif expanded[0].eqIdent("ProductDimension"):
      result.num = getTerms(expanded)
      result.den = newSeq[NimNode]()
  of nnkSym, nnkIdent:
    result.num = @[ident($expanded)]
    result.den = @[]
  else:
    error("internal error: getNumDen. This should not be possible. Please submit an issue on GitHub so we can fix it.")

proc makeProductTerms(terms: seq[NimNode]): NimNode =
  ## Creates a single dimension node, or a product node from a set
  ## of terms to be multiplied.
  if terms.len == 0:
    result = ident"DimensionLess"
  elif terms.len == 1:
    result = terms[0]
  else:
    result = newTree(nnkBracketExpr,
      bindsym"ProductDimension",
      newTree(nnkPar).add terms
    )

proc divide(oldNum, oldDen: seq[NimNode]): tuple[
  num, den: seq[NimNode]] =
  ## Performs the division of a numerator and denominator sequence.
  var
    totalNum = oldNum
    totalDen = oldDen
  totalNum.sort(proc(x, y: NimNode): int = cmp($x, $y))
  totalDen.sort(proc(x, y: NimNode): int = cmp($x, $y))
  result.num = newSeq[NimNode]()
  result.den = newSeq[NimNode]()
  for num in totalNum:
    if num.eqIdent("DimensionLess"):
      continue
    block divide:
      var
        idx = 0
      for den in totalDen:
        if num == den:
          totalDen.del idx
          break divide
        inc idx
      result.num.add num
  for den in totalDen:
    if den.eqIdent("DimensionLess"):
      continue
    result.den.add den

proc makeQuotientTerms(num, den: seq[NimNode]): NimNode =
  ## Creates a single dimension node, or a quotient node from a set of terms
  ## to be divided.
  let
    (num, den) = divide(num, den)
  if den.len == 0:
    result = makeProductTerms(num)
  else:
    result = newTree(nnkBracketExpr,
      ident"QuotientDimension",
      makeProductTerms(num),
      makeProductTerms(den))

proc mulImpl(x, y: NimNode): NimNode =
  var
    (xNum, xDen) = getNumDen(x)
    (yNum, yDen) = getNumDen(y)
    totalNum = xNum
    totalDen = xDen
  totalNum.add yNum
  totalDen.add yDen
  totalNum.sort(proc(x, y: NimNode): int = cmp($x, $y))
  totalDen.sort(proc(x, y: NimNode): int = cmp($x, $y))
  result = makeQuotientTerms(totalNum, totalDen)

macro `*`*(x: SomeDimension, y: distinct SomeDimension): untyped =
  ## The ``ProductDimension`` between two dimensions.
  result = mulImpl(x, y)

proc divImpl(x, y: NimNode): NimNode =
  var
    (xNum, xDen) = getNumDen(x)
    (yNum, yDen) = getNumDen(y)
    totalNum = xNum
    totalDen = xDen
  totalNum.add yDen
  totalDen.add yNum
  totalNum.sort(proc(x, y: NimNode): int = cmp($x, $y))
  totalDen.sort(proc(x, y: NimNode): int = cmp($x, $y))
  result = makeQuotientTerms(totalNum, totalDen)

macro `/`*(x: SomeDimension, y: distinct SomeDimension): untyped =
  ## The ``QuotientDimension`` between two dimensions.
  result = divImpl(x, y)

proc powImpl(x: NimNode; y: int): NimNode =
  var
    (xNum, xDen) = getNumDen(x)
    totalNum = xNum.cycle(y)
    totalDen = xDen.cycle(y)
  result = makeQuotientTerms(totalNum, totalDen)

macro `^`*(x: SomeDimension, y: static[int]): untyped =
  ## The ``ProductDimension`` resulting from taking the ``yth`` power of a
  ## dimension.
  result = powImpl(x, y)

macro stringify*(dim: SomeDimension): string =
  ## Stringifies any dimension type.
  let
    (num, den) = dim.getNumDen

  var
    numerator = initTable[string, int]()
    denominator = initTable[string, int]()

  for elem in num:
    numerator.mgetOrPut($elem, 0) += 1
  for elem in den:
    denominator.mgetOrPut($elem, 0) += 1

  if numerator.len == 0 and denominator.len == 0:
    result = newStrLitNode("1 ")
  elif numerator.len == 0:
    result = newStrLitNode("1 / ")
    for key in denominator.keys:
      var
        id = ident key
        times = denominator[key]
        toAppend = quote do:
          $`id` & " "
      if denominator[key] > 1:
        toAppend = quote do:
          $`id` & "^" & $`times` & " "
      result = newTree(nnkCall,
        bindsym"&",
        result.copyNimTree,
        toAppend
      )
  elif denominator.len == 0:
    result = newStrLitNode("")
    for key in numerator.keys:
      var
        id = ident key
        times = numerator[key]
        toAppend = quote do:
          $`id` & " "
      if numerator[key] > 1:
        toAppend = quote do:
          $`id` & "^" & $`times` & " "
      result = newTree(nnkCall,
        bindsym"&",
        result.copyNimTree,
        toAppend
      )
  else:
    result = newStrLitNode("")
    for key in numerator.keys:
      var
        id = ident key
        times = numerator[key]
        toAppend = quote do:
          $`id` & " "
      if numerator[key] > 1:
        toAppend = quote do:
          $`id` & "^" & $`times` & " "
      result = newTree(nnkCall,
        bindsym"&",
        result.copyNimTree,
        toAppend
      )
    result = newTree(nnkCall,
      bindsym"&",
      result.copyNimTree,
      newStrLitNode("/ ")
    )
    for key in denominator.keys:
      var
        id = ident key
        times = denominator[key]
        toAppend = quote do:
          $`id` & " "
      if denominator[key] > 1:
        toAppend = quote do:
          $`id` & "^" & $`times` & " "
      result = newTree(nnkCall,
        bindsym"&",
        result.copyNimTree,
        toAppend
      )
  result = quote do:
    `result`[0 ..< `result`.len - 1]

macro `$`*(dim: SomeDimension): string =
  ## Stringifies a dimension type.
  result = quote do:
    stringify(`dim`)
