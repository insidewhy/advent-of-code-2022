#!/usr/bin/env php
<?php

define('CD_PREFIX', "$ cd ");
define('LS_CMD', "$ ls");
define('DIR_PREFIX', "dir ");
define('TOTAL_DISK_SPACE', 70000000);
define('NEEDED_DISK_SPACE', 30000000);

class Dir {
  public array $child_dirs = [];
  public int $size_of_all_files = 0;
  public readonly Dir $parent_dir;

  public function __construct(?Dir $parent_dir) {
    $this->parent_dir = $parent_dir ?? $this;
  }

  public function get_content_size(): int {
    return $this->size_of_all_files + array_sum(
      array_map(fn ($dir) => $dir->get_content_size(), $this->child_dirs)
    );
  }

  public function get_smallest_directory_with_size_more_than(int $min_size, int &$best_answer): void {
    foreach ($this->child_dirs as $child_dir) {
      $content_size = $child_dir->get_content_size();
      if ($content_size > $min_size) {
        if ($content_size < $best_answer) {
          $best_answer = $content_size;
        }
        $child_dir->get_smallest_directory_with_size_more_than($min_size, $best_answer);
      }
    }
  }
}

$root_dir = $current_dir = new Dir(null);

$lines = file("input-7.txt");

for ($i = 0; $i < count($lines); ) {
  $line = trim($lines[$i]);

  if ($line[0] != "$") {
    throw new Exception("Expected command beginning with \$ but got $line");
  }

  if (str_starts_with($line, CD_PREFIX)) {
    $cd_arg = substr($line, strlen(CD_PREFIX));
    if ($cd_arg == "/") {
      $current_dir = $root_dir;
    } else if ($cd_arg == "..") {
      $current_dir = $current_dir->parent_dir;
    } else {
      $next_dir = $current_dir->child_dirs[$cd_arg] ?? null;
      if (! $next_dir) {
        $next_dir = $current_dir->child_dirs[$cd_arg] = new Dir($current_dir);
      }
      $current_dir = $next_dir;
    }
    ++$i;
  } else if ($line == LS_CMD) {
    $current_dir->size_of_all_files = 0;
    for (++$i; $i < count($lines); ++$i) {
      $line = trim($lines[$i]);
      if ($line[0] == "$") {
        break;
      } else if (! str_starts_with($line, DIR_PREFIX)) {
        $current_dir->size_of_all_files += intval($line);
      }
    }
  }
}

$free_space = TOTAL_DISK_SPACE - $root_dir->get_content_size();
$must_rm_size = NEEDED_DISK_SPACE - $free_space;

$smallest_directory_size = TOTAL_DISK_SPACE;
$root_dir->get_smallest_directory_with_size_more_than($must_rm_size, $smallest_directory_size);
echo $smallest_directory_size . "\n";

?>
