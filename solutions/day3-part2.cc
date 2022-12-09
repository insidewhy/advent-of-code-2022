import <iostream>;
import <fstream>;
import <set>;
import <exception>;
import <vector>;
import <algorithm>;

int get_score(char c) {
  if (c >= 'a' && c <= 'z') {
    return (c - 'a') + 1;
  } else if (c >= 'A' && c <= 'Z') {
    return (c - 'A') + 27;
  } else {
    throw std::runtime_error(std::string("invalid item code: ") + c);
  }
}

int main(int size, char *argv[]) {
  std::ifstream file("input-3.txt");
  std::string line1;
  std::string line2;
  std::string line3;
  unsigned int total_score = 0;
  while (std::getline(file, line1)) {
    if (! std::getline(file, line2) || ! std::getline(file, line3)) {
      throw std::runtime_error(std::string("file length was not divisible by 3"));
    }

    std::set<char> set1(line1.begin(), line1.end());
    std::set<char> set2(line2.begin(), line2.end());
    std::set<char> set3(line3.begin(), line3.end());

    std::vector<char> intersection1;
    std::set_intersection(
      set1.begin(),
      set1.end(),
      set2.begin(),
      set2.end(),
      std::back_inserter(intersection1)
    );
    std::vector<char> intersection2;
    std::set_intersection(
      intersection1.begin(),
      intersection1.end(),
      set3.begin(),
      set3.end(),
      std::back_inserter(intersection2)
    );

    if (intersection2.size() > 1) {
      throw std::runtime_error("There should only be one item in common between each group of 3 rows");
    }

    total_score += get_score(intersection2[0]);
  }

  std::cout << total_score << std::endl;
  return 0;
}
