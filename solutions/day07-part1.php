#!/usr/bin/env php
<?php

define('CD_PREFIX', "$ cd ");
define('LS_CMD', "$ ls");
define('DIR_PREFIX', "dir ");
define('MAX_INTERESTING_DIR_SIZE', 100000);

class Dir {
  public array $child_dirs = [];
  public int $size_of_all_files = 0;
  public readonly Dir $parent_dir;

  public function __construct(?Dir $parent_dir) {
    $this->parent_dir = $parent_dir ?? $this;
  }

  private function get_content_size(): int {
    return $this->size_of_all_files + array_sum(
      array_map(fn ($dir) => $dir->get_content_size(), $this->child_dirs)
    );
  }

  public function get_sum_of_interesting_dir_sizes(): int {
    $sum = $this->get_content_size();
    if ($sum >= MAX_INTERESTING_DIR_SIZE) {
      $sum = 0;
    }
    return $sum + array_sum(
      array_map(fn ($dir) => $dir->get_sum_of_interesting_dir_sizes(), $this->child_dirs)
    );
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

echo $root_dir->get_sum_of_interesting_dir_sizes() . "\n";

?>
