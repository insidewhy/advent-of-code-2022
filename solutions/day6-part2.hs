#!/usr/bin/env runghc

import Data.Text (unpack, pack, strip)
import qualified Data.Set as Set
import Data.Set (Set)
import Data.List (findIndex, nub, splitAt)

buildQueue :: [Char] -> Char -> [Char]
buildQueue (head:tail) next = tail ++ [next]

markerLength = 14

main :: IO ()
main = do
  s <- readFile "input-6.txt"
  let codes = unpack $ strip $ pack s
  let (queue, remaining) = splitAt markerLength codes
  let search = scanl buildQueue queue remaining
  let index = findIndex (\queue -> (length $ nub queue) == markerLength) search
  case index of
    Just(val) -> print $ val + markerLength
    otherwise -> print "not found"
