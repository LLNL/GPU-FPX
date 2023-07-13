#include <stdint.h>
#include <iostream>
#include <cmath>

void print_binary(uint32_t value) {
	uint64_t one = 1;
	for (uint32_t i = (one << 32 - 1); i > 0; i = i / 2) {
		putc((value & i) ? '1' : '0',stdout);
	}
	putc('\n',stdout);
}

int main(){
  uint32_t value = 131071;
  value = value << 4;
  uint32_t fp_type = 3;
  fp_type = fp_type << 2;
  uint32_t index = value | fp_type;
  print_binary(index);
  uint32_t loc_id = 131071;
  uint32_t fp_format = 3;
  uint32_t index2 = loc_id << 4 | fp_format << 2;
  print_binary(index2);
  bool type = true;
  print_binary((uint32_t)type);
  uint32_t mask = 0xf;
  uint32_t reverse_loc_id = index & ~mask;
  print_binary(reverse_loc_id >> 4);
  std::cout << (reverse_loc_id >> 4) << std::endl;
  uint32_t reverse_format = ((index & mask) >>2);
  print_binary(reverse_format);
  uint32_t execpt = 1;
  uint32_t execpindex = index | execpt ;
  print_binary(execpindex);
}
