#ifndef HOSTUTIL_H
#define HOSTUTIL_H

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <string>
#include <map>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <set>
#include "common.h"
#include <fstream>
#include <exception>
#include <errno.h>
#define FILE_NAME_SIZE 256
#define PATH_NAME_SIZE 5000
//int verbose = 0;

const char * exceptionTypeNames[NUM_EXCE_TYPES] = {
"UNUSED","NaN","INF","SUB","DIV0"
 };
// const char * exceptionTypeNames[NUM_EXCE_TYPES] = {
// "NORMAL","NaN","INF","SUB"
//  };
//
const char * exceptionAnaTypeNames[NUM_ANA_TYPES] = {
"VAL","NaN","INF"
 };




const char * FPFormatTypeNames[NUM_FP_TYPES] = {
"UNUSED","FP32","FP64"
 };


typedef std::tuple<std::string, std::string, uint32_t> LocationTuple;
std::map<LocationTuple, uint32_t> loc_to_id_map;
std::map<uint32_t, LocationTuple> id_to_loc_map;


std::map<std::string, uint64_t> locExc_count;

/* Set of analyzed kernels */
//std::set<const char *> analyzed_kernels;
// std::set<std::string> analyzed_kernels;
std::map<std::string, int> analyzed_kernels;
std::map<std::string, int> kernel_id_map;
std::map<int, std::string> id_kernel_map;


std::map<std::string, int> sass_to_id_map;
std::map<int, std::string> id_to_sass_map;
int verbose = 0;
int inst_count=0;
int print_ill_instr=0;
int progagated=0;
int enable_compare=0;


/* Instructions count */
// uint64_t inst_count;

/* Take the enable/disable kernels from files*/
void read_from_file(std::string filename, std::vector<std::string> & my_vect)
{
  try
  {
    std::ifstream f(filename.c_str());

    if(!f)
    {
        std::cerr << "No " << filename << " !" << std::endl;
    }
    else{
        std::string line;
        while (std::getline(f,line))
        {
                my_vect.push_back(line);
        }
      f.close();
    }
  }
  catch(const std::exception& ex)
  {
    std::cerr << "Exception: '" << ex.what() << "'!" << std::endl;
    exit(1);
  }
}
int encode_index(uint32_t loc_id, uint32_t fp_format) {
  uint32_t index = loc_id << 4 | fp_format << 2;
  return index;
}

void decode_index(uint32_t index, uint32_t &loc_id, uint32_t &fp_format) {
  uint32_t mask = 0xf;
  loc_id = ((index & ~mask)>>4);
  fp_format = ((index & mask) >>2);
}

 uint32_t getLocationID(LocationTuple &loc) { 
  //char *ret = nullptr;
  int ret = 0;
  std::map< LocationTuple, uint32_t>::iterator got = loc_to_id_map.find(loc);

  if ( got == loc_to_id_map.end() ) { /* not found */
    uint32_t line_id = loc_to_id_map.size();
    std::pair<LocationTuple, uint32_t> tmp(loc, line_id);
    loc_to_id_map.insert(tmp);
    std::pair<uint32_t, LocationTuple> tmp2(line_id, loc);
    id_to_loc_map.insert(tmp2);
    ret = line_id;
    //free(loc_string);
  } else { /* string found */
    ret = got->second;
  }

  return ret;
}
std::string locTupleToLoc(LocationTuple &loc){
  std::string loc_string; 
  //std::cout << "1 = " << std::get<1>(loc) << ", 0 = " << std::get<0>(loc) << ", 2 = " << std::get<2>(loc) << std::endl;
  loc_string = std::get<1>(loc)+"/";
  loc_string = loc_string.append(std::get<0>(loc));
  loc_string = loc_string.append(":");
  loc_string = loc_string.append(std::to_string(std::get<2>(loc)));
  return loc_string;
 }

// TODO: strstr time consuming? 
bool is_FP32_instruction(std::string inst) {
  if(inst.find("FADD")!= std::string::npos ||
      inst.find("FADD32I")!=std::string::npos||
      inst.find("FFMA32I")!=std::string::npos||
      inst.find("FFMA")!=std::string::npos||
      inst.find("FMUL")!=std::string::npos||
      inst.find("MUFU")!=std::string::npos ||
      inst.find("FMNMX")!= std::string::npos ||
      inst.find("FSEL")!= std::string::npos ||
      inst.find("FSET")!= std::string::npos ||
      inst.find("FCHK")!= std::string::npos ||
      inst.find("FSETP")!= std::string::npos
      ) {
        if(inst.find("64H")==std::string::npos){
          return true;
        }
      }
 return false;            
}

bool is_FP64_instruction(std::string inst) {
  if(inst.find("DMUL")!= std::string::npos ||
  inst.find("DADD")!= std::string::npos ||
  inst.find("DFMA")!= std::string::npos || 
  inst.find("DSETP")!= std::string::npos || 
  inst.find("64H")!= std::string::npos)
    return true;
  return false; 
}

std::string cut_kernel_name(std::string kname){
 std::size_t found = kname.find('<');
  std::size_t found2 = kname.find('(');
  if(found !=std::string::npos) {
    return kname.substr(0,found);
  }
  else if (found2 != std::string::npos) {
    return kname.substr(0,found2);
  }
  else {
    return kname;
  }
  
}

int is_DIV(std::string inst){
   if(inst.find("MUFU.RCP") != std::string::npos){
    if(inst.find("MUFU.RCP64H")!=std::string::npos)
    {
      return 2;
    }
    return 1;
  }
  return 0;
}

void print_exc(std::string loc, std::string f_type, std::string exc, int opcode_id, int kernel_id, int f_type_id, uint32_t loc_id, int exc_id){

  std::string ind = std::to_string(f_type_id)+"_"+std::to_string(exc_id) +"_"+std::to_string(loc_id)+"_"+std::to_string(kernel_id);

  //todo: find, end in O(n)? 
  auto it = locExc_count.find(ind);
  if(it == locExc_count.end()){
    locExc_count.insert(std::pair<std::string, int>(ind, 1));
    if(exc_id == E_SUB){
          std::cout << "#GPU-FPX LOC-EXCEP INFO: Warning: in kernel [" << id_kernel_map[kernel_id] << "], " << "very small quantity (" << exc << ") found @ " << loc << " [" <<f_type <<"]"<<std::endl;
    }
    else{
          std::cout << "#GPU-FPX LOC-EXCEP INFO: in kernel [" << id_kernel_map[kernel_id] << "], " << exc << " found @ " << loc << " [" << f_type << "]" << std::endl;
    }
  if(print_ill_instr){
    std::cout << "#GPU-FPX VERBOSE:the ill instruction is: " << id_to_sass_map[opcode_id] << std::endl;
    }
  }
  else{
  it->second++;
 }

}

// TODO: have preserved keywords 
int computeExcNum(int exc_id, int f_type_id){
  int num = 0;
  std::string pre = std::to_string(f_type_id)+"_"+std::to_string(exc_id) +"_";
  for (auto it = locExc_count.cbegin(); it != locExc_count.cend(); ++it)
  {
    //std::string instr(it->first);
    if(it->first.find(pre) == 0){
      num++;

    }
  }
  return num;
  

}

void print_real_exceptions(){
  uint64_t total = 0;
  for (auto it = locExc_count.cbegin(); it != locExc_count.cend(); ++it)
  {
    //std::cout << it->first << ": " << it->second << std::endl;
    total = total + it->second;
  }
  std::cout << "The total number of exceptions are: " << total << std::endl;
  
}

void print_ana_exceps(std::string loc, int opcode_id, int kernel_id, uint32_t loc_id, uint32_t ei_list[], int ops, uint32_t w_lit_except, uint32_t after_before){

  std::string sass_instr = id_to_sass_map[opcode_id];
  int first_space = sass_instr.find(" ");
 // std::string opcode_instr = sass_instr.substr(0, first_space);
  std::string ind = std::to_string(loc_id)+"_"+std::to_string(opcode_id)+"_"+std::to_string(after_before);
  for(int i =0;i < 4; i++){
    std::string ind = ind + "_" + std::to_string(ei_list[i]);
  }
  //todo: find, end in O(n)? 
  auto it = locExc_count.find(ind);
  if(it == locExc_count.end()){
    locExc_count.insert(std::pair<std::string, int>(ind, 1));
    if(after_before){
      if(after_before==1){
        std::cout << "#GPU-FPX-ANA SHARED REGISTER: Before executing the instruction ";
        std::cout << " @ " << loc << " ";
        std::cout << "Instruction: " << sass_instr;
        std::cout << " We have " << ops << " registers in total. ";
        for(int i = 0; i< ops; i++ ){
          std::cout << "Register " << i << " is " << exceptionAnaTypeNames[ei_list[i]] << ". ";
        }
        std::cout << "\n\n";   
      }
      else if(after_before==2){
        std::cout << "#GPU-FPX-ANA SHARED REGISTER: After executing the instruction ";
        std::cout << " @ " << loc << " ";
        std::cout << "Instruction: " << sass_instr;
        std::cout << " We have " << ops << " registers in total. ";
        for(int i = 0; i< ops; i++ ){
          std::cout << "Register " << i << " is " << exceptionAnaTypeNames[ei_list[i]] << ". ";
        }
        std::cout << "\n\n";   
      }
          
    }
    else if(sass_instr.find("SEL")!=std::string::npos || 
        sass_instr.find("SETP")!=std::string::npos||
        sass_instr.find("CHK")!=std::string::npos||
        sass_instr.find("SET")!=std::string::npos||
        sass_instr.find("FMNMX")!=std::string::npos) {
          if(enable_compare){
            std::cout << "#GPU-FPX-ANA COMPARE: Exceptional value may appear in a comparision or min/max statement"; 
            std::cout << " @ " << loc << " ";
            std::cout << "Instruction: " << sass_instr;
            std::cout << " We have " << ops << " registers in total. ";
            for(int i = 0; i< ops; i++ ){
              std::cout << "Register " << i << " is " << exceptionAnaTypeNames[ei_list[i]] << ". ";
            }
            std::cout << "\n\n";
          }
        }
    else {
      uint32_t dest_except = ei_list[0];
      bool dest_src_same_e=false;
      for(int i = 1; i< ops; i++ ){ 
        if(dest_except==ei_list[i]){
          dest_src_same_e = true;
          break;
        }
      }
      if(dest_except == w_lit_except){
        dest_src_same_e = true;
      }
      if(dest_src_same_e && dest_except){
        if(progagated){
          std::cout << "#GPU-FPX-ANA PROGAGATION: Exceptional values are progagated from source to destination ";
          std::cout << " @ " << loc << " ";
          std::cout << "Instruction: " << sass_instr;
          std::cout << " We have " << ops << " registers in total. ";
          for(int i = 0; i< ops; i++ ){
            std::cout << "Register " << i << " is " << exceptionAnaTypeNames[ei_list[i]] << ". ";
          }
          std::cout << "\n\n";     
        } 
      }
      else if(!dest_src_same_e && dest_except){
        std::cout << "#GPU-FPX-ANA APPEAR : " << exceptionAnaTypeNames[ei_list[0]] << " appear at the destination ";
        std::cout << " @ " << loc << " ";
        std::cout << "Instruction: " << sass_instr;
        std::cout << " We have " << ops << " registers in total. ";
        for(int i = 0; i< ops; i++ ){
          std::cout << "Register " << i << " is " << exceptionAnaTypeNames[ei_list[i]] << ". ";
        }
        std::cout << "\n\n";
      }
      else{
        std::cout << "#GPU-FPX-ANA DISAPPEAR : Exceptional values are disappeared ";
        std::cout << " @ " << loc << " ";
        std::cout << "Instruction: " << sass_instr;
        std::cout << " We have " << ops << " registers in total. ";
        for(int i = 0; i< ops; i++ ){
          std::cout << "Register " << i << " is " << exceptionAnaTypeNames[ei_list[i]] << ". ";
        }
        std::cout << "\n\n";
      }
    }
  }
  else{
  it->second++;
 }

}

#endif
