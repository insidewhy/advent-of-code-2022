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
  std::string line;
  unsigned int total_score = 0;
  while (std::getline(file, line)) {
    std::set<char> compartment1 { line.begin(), line.begin() + line.size() / 2 };
    std::set<char> compartment2 { line.begin() + line.size() / 2, line.end() };
    std::vector<char> intersection;
    std::set_intersection(
      compartment1.begin(),
      compartment1.end(),
      compartment2.begin(),
      compartment2.end(),
      std::back_inserter(intersection)
    );

    if (intersection.size() != 1) {
      throw std::runtime_error("There should be exactly one item in common between the compartments");
    }

    total_score += get_score(intersection[0]);
  }

  std::cout << total_score << std::endl;
  return 0;
}
