#!/usr/bin/env run-cargo-script
use std::fs::File;
use std::io::{self, BufRead, Error, ErrorKind};

fn main() {
    let res = solve();
    match res {
        Ok(solution) => { println!("{}", solution) }
        Err(e) => { println!("Failed to solve: {}", e) }
    }
}

struct Tree {
    height: u32,
    visible: bool,
}

fn solve() -> io::Result<u64> {
    let mut col_count = 0;
    let mut rows: Vec<Vec<Tree>> = Vec::new();

    for line_result in io::BufReader::new(File::open("input-8.txt")?).lines() {
        let line = line_result?;
        if col_count == 0 {
            col_count = line.len();
        } else if line.len() != col_count {
            return Err(Error::new(ErrorKind::Other, "oh no!"));
        }

        let mut row: Vec<Tree> = Vec::new();
        for height_char in line.chars() {
            let height: u32 = height_char.to_digit(10).unwrap();
            row.push(Tree {
                height: height,
                visible: false,
            });
        }
        rows.push(row);
    }

    let mut visible_count: u64 = 0;

    for row in &mut rows {
        // from left to right along the row
        let mut highest = 0;
        for (col_idx, tree) in row.iter_mut().enumerate() {
            if col_idx == 0 || tree.height > highest {
                visible_count += 1;
                tree.visible = true;
                highest = tree.height;
            }
        }

        // from right to left along the row, stopping at the highest tree
        highest = 0;
        for (col_idx, tree) in row.iter_mut().rev().enumerate() {
            if tree.visible {
                // the last visible tree from the first iteration is the highest tree so
                // cannot continue further
                break
            } else if col_idx == 0 || tree.height > highest {
                visible_count += 1;
                tree.visible = true;
                highest = tree.height;
            }
        }
    }

    for col_idx in 0..col_count {
        // from top to bottom along column
        let mut highest = 0;
        let mut highest_idx = 0;
        for (row_idx, row) in rows.iter_mut().enumerate() {
            let mut tree = &mut row[col_idx];
            if row_idx == 0 || tree.height > highest {
                if ! tree.visible {
                    visible_count += 1;
                }
                highest = tree.height;
                highest_idx = row_idx
            }
        }

        // from bottom to top along column, stopping at highest tree
        highest = 0;
        for (row_idx, row) in rows.iter_mut().rev().enumerate() {
            let mut tree = &mut row[col_idx];
            if (col_count - row_idx - 1) == highest_idx {
                break
            }
            if row_idx == 0 || tree.height > highest {
                if ! tree.visible {
                    visible_count += 1;
                }
                highest = tree.height;
            }
        }
    }

    return Ok(visible_count);
}
