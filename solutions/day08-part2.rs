#!/usr/bin/env run-cargo-script
use std::fs::File;
use std::io::{self, BufRead, Error, ErrorKind};
use std::cmp::max;

fn main() {
    let res = solve();
    match res {
        Ok(solution) => { println!("{}", solution) }
        Err(e) => { println!("Failed to solve: {}", e) }
    }
}

struct Tree {
    height: u32,
    scenic_score: u64,
}

fn solve() -> io::Result<u64> {
    let mut col_count = 0;
    let mut rows: Vec<Vec<Tree>> = Vec::new();

    for line_result in io::BufReader::new(File::open("input-8.txt")?).lines() {
        let line = line_result?;
        if col_count == 0 {
            col_count = line.len();
        } else if line.len() != col_count {
            return Err(Error::new(ErrorKind::Other, "all rows should have the same length"));
        }

        let mut row: Vec<Tree> = Vec::new();
        for height_char in line.chars() {
            let height: u32 = height_char.to_digit(10).unwrap();
            row.push(Tree {
                height: height,
                scenic_score: 0,
            });
        }
        rows.push(row);
    }

    for row in &mut rows {
        // from left to right along the row
        let mut left_blockers = vec![0; col_count];
        for col_idx in 1..col_count {
            let tree_height = row[col_idx].height;
            let mut blocker_count = 1;
            let mut next_blocker_idx = col_idx - 1;

            while row[next_blocker_idx].height < tree_height && next_blocker_idx > 0 {
                blocker_count += left_blockers[next_blocker_idx];
                next_blocker_idx -= left_blockers[next_blocker_idx];
            }

            left_blockers[col_idx] = blocker_count;
            row[col_idx].scenic_score = blocker_count as u64;
        }

        // from right to left
        let max_col_idx = col_count - 1;
        let mut right_blockers = vec![0; col_count];
        for col_idx in (0..max_col_idx).rev() {
            let tree_height = row[col_idx].height;
            let mut blocker_count = 1;
            let mut next_blocker_idx = col_idx + 1;

            while row[next_blocker_idx].height < tree_height && next_blocker_idx < max_col_idx {
                blocker_count += right_blockers[next_blocker_idx];
                next_blocker_idx += right_blockers[next_blocker_idx];
            }

            right_blockers[col_idx] = blocker_count;
            row[col_idx].scenic_score *= blocker_count as u64;
        }
    }

    let mut highest_scenic_score = 0;
    let row_count = rows.len();
    for col_idx in 0..col_count {
        // from top to bottom
        let mut top_blockers = vec![0; row_count];
        for row_idx in 1..row_count {
            let tree_height = rows[row_idx][col_idx].height;
            let mut blocker_count = 1;
            let mut next_blocker_idx = row_idx - 1;

            while rows[next_blocker_idx][col_idx].height < tree_height && next_blocker_idx > 0 {
                blocker_count += top_blockers[next_blocker_idx];
                next_blocker_idx -= top_blockers[next_blocker_idx];
            }

            top_blockers[row_idx] = blocker_count;
            rows[row_idx][col_idx].scenic_score *= blocker_count as u64;
        }

        // finally from bottom to top, this time don't need to store the scenic score in every
        // tree, just need to calculate the max
        let max_row_idx = row_count - 1;
        let mut bottom_blockers = vec![0; col_count];
        for row_idx in (0..max_row_idx).rev() {
            let tree_height = rows[row_idx][col_idx].height;
            let mut blocker_count = 1;
            let mut next_blocker_idx = row_idx + 1;

            while rows[next_blocker_idx][col_idx].height < tree_height &&
                  next_blocker_idx < max_row_idx
            {
                blocker_count += bottom_blockers[next_blocker_idx];
                next_blocker_idx += bottom_blockers[next_blocker_idx];
            }

            bottom_blockers[row_idx] = blocker_count;
            highest_scenic_score = max(
                highest_scenic_score,
                rows[row_idx][col_idx].scenic_score * blocker_count as u64
            );
        }
    }

    return Ok(highest_scenic_score);
}
