#!/usr/bin/env -S dotnet fsi --exec --quiet

module Day13Part1

type Token =
  | NumToken of int
  | StartList
  | EndList

module Tokenizer =
  let inline charToInt c = int c - int '0'

  let buildCurrentNum (num: Option<int>) (next: char): int =
    match num with
    | None -> charToInt next
    | Some var -> var * 10 + charToInt next

  type ListAcc = { CurrentNum: Option<int>; Built: List<Token> }

  let buildTokenAtComma (acc: ListAcc): List<Token> =
    match acc.CurrentNum with
    | None -> acc.Built
    | Some var -> NumToken var :: acc.Built

  let buildTokenAtListBoundary (nextToken: Token) (acc: ListAcc): List<Token> =
    match acc.CurrentNum with
    | None -> nextToken :: acc.Built
    | Some var -> nextToken :: NumToken var :: acc.Built

  let tokenizeNext (acc: ListAcc) (next: char): ListAcc =
    match next with
    | '[' -> { CurrentNum = None; Built = buildTokenAtListBoundary StartList acc; }
    | ']' -> { CurrentNum = None; Built = buildTokenAtListBoundary EndList acc; }
    | ',' -> { CurrentNum = None; Built = buildTokenAtComma acc; }
    | var -> { CurrentNum = Some (buildCurrentNum acc.CurrentNum next); Built = acc.Built; }

  let tokenize = Seq.fold tokenizeNext { CurrentNum = None; Built = [] }

type RecursiveNumList =
  | Num of int
  | NumList of List<RecursiveNumList>

module Parser =
  exception Error

  type ParseListResult = { Next: List<Token>; Built: List<RecursiveNumList> }
  type ParseResult = { Next: List<Token>; Built: Option<RecursiveNumList> }

  let rec parseListTokens (tokens: List<Token>): ParseListResult =
    let parsedHead = parseTokens tokens
    match parsedHead.Built with
    | None -> { Built = []; Next = parsedHead.Next }
    | Some result ->
      let parsedTail = parseListTokens parsedHead.Next
      { Built = result :: parsedTail.Built; Next = parsedTail.Next }

  and parseTokens (tokens: List<Token>): ParseResult =
    match tokens with
    | StartList :: tail ->
      let parsedList = parseListTokens tail
      { Next = parsedList.Next; Built = Some(NumList parsedList.Built) }
    | NumToken var :: tail -> { Next = tail; Built = Some(Num var) }
    | EndList :: tail -> { Next = tail; Built = None }
    | _ -> raise Error

let parseLine (line: string): RecursiveNumList =
  let tokens = List.rev (Tokenizer.tokenize line).Built
  match (Parser.parseTokens tokens).Built with
  | None -> raise Parser.Error
  | Some parsed -> parsed

type Comparison = Lt | Eq | Gt

let rec compareSides (left: RecursiveNumList) (right: RecursiveNumList): Comparison =
  match left with
  | NumList [] ->
    match right with
      | NumList [] -> Eq
      | _ -> Lt
  | NumList (leftHead :: tail) ->
    match right with
      | Num rightVal -> compareSides left (NumList [right])
      | NumList [] -> Gt
      | NumList (rightHead :: rightTail) ->
        match (compareSides leftHead rightHead) with
        | Eq -> compareSides (NumList tail) (NumList rightTail)
        | cmp -> cmp
  | Num leftVal ->
    match right with
      | Num rightVal ->
        if leftVal < rightVal then Lt
        else if leftVal > rightVal then Gt
        else Eq
      | rightList -> compareSides (NumList [left]) rightList

let output =
  System.IO.File.ReadLines("input-13.txt")
    |> Seq.chunkBySize 3
    |> Seq.map (fun lines -> (parseLine lines.[0], parseLine lines.[1]))
    |> Seq.indexed
    |> Seq.map (fun (i, v) -> (i + 1, v))
    |> Seq.filter (fun (i, (left, right)) ->
      match (compareSides left right) with
      | Lt -> true
      | _ -> false)
    |> Seq.map fst
    |> Seq.sum

printfn "%d" output
