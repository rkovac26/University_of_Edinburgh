// =========================================================================
//
// Find most occuring word in a sentence
//
// Inf2C-CS Coursework 1. Task B
// OUTLINE code, to be completed as part of coursework.
//
// Boris Grot, Priyank Faldu
// October 11, 2016
//
// =========================================================================


// C Header files
#include <stdio.h>

#include <stdio.h>

void read_string(char* s, int size) { fgets(s, size, stdin); }

void print_char(char c)    { printf("%c", c); }
void print_int(int num)    { printf("%d", num); }
void print_string(char* s) { printf("%s", s); }


// Maximum characters in an input sentence including terminating null character
#define MAX_CHARS 1001

// Maximum characters in a word including terminating null character
#define MAX_WORD_LENGTH 51

char input_sentence[MAX_CHARS];
char word[MAX_WORD_LENGTH];
int num_unique_words = 0;
int max_frequency = -1;
int num_words_with_max_frequency = 0;

int read_input(char* inp) {
    print_string("\ninput: ");
    read_string(input_sentence, MAX_CHARS);
}

void output(int unique_words, int max_freq, int num_words_w_max_freq, char* out) {
    print_string("output:\n");
    print_int(unique_words);
    print_string("\n");
    print_int(max_freq);
    print_string("\n");
    print_int(num_words_w_max_freq);
    print_string("\n");
    print_string(out);
    print_string("\n");
}

///////////////////////////////////////////////////////////////////////////////
//
// DO NOT MODIFY CODE ABOVE
//
///////////////////////////////////////////////////////////////////////////////

// ADD CUSTOM FUNCTIONS AND OTHER GLOBAL VARIABLES AS NEEDED

int is_delimiting_char(char ch) {
    if ( ch == ' ') {
        return 1;
    } else if ( ch == ',') {
        return 1;
    } else if ( ch == '.') {
        return 1;
    } else if ( ch == '!') {
        return 1;
    } else if ( ch == '?') {
        return 1;
    } else if ( ch == '_') {
        return 1;
    } else if ( ch == '-') {
        return 1;
    } else if ( ch == '(') {
        return 1;
    } else if ( ch == ')') {
        return 1;
    } else if ( ch == '\n') {
        return 1;
    } else if ( ch == '\0') {
        return 1;
    } else {
        return 0;
    }
}


void process_input(char* inp) {
  char current_word[MAX_WORD_LENGTH];
  char unique_words[MAX_CHARS];  //array of unique words
  int current_word_index = 0; //index of word that is being processed by histogram_creator
  int current_word_len = 0; //length of word that is being processed by histogram_creator
  int lengths[501]; //lengths of words in unique array
  int histogram[501]; //histogram of uniqe array
  int lengths_number = 0; //number of unique words
  int total_length = 0; //length of unique array
  char cur_char;
  int end_of_sentence = 0;
  int is_delim_ch = 0;
  int result = 0;
  int result1 = 0;
  int unique_words_index = 0;


 while( end_of_sentence == 0 ) {
      // This loop runs until end of sentence

      cur_char = *inp;

      // Check if it is a delimiting character
      is_delim_ch = is_delimiting_char(cur_char);

      if ( is_delim_ch == 1 ) {
          if ( current_word_len > 0 ) {
            // Histogram_creator:
            int i = 0;   // Loop counters
            int j = 0;

            for( i = 0; i<lengths_number; i++){
              if(current_word_len == lengths[i]){
                for( j = 0; j<lengths[i]; j++){
                  if(current_word[j] == unique_words[j + unique_words_index]) {
                    result++;
                  }
                }
                if( result == lengths[i]) {  // Each char is the same
                  histogram[i]++;
                  result1 = 1;
                  result = 0;
                  break;
                  }
                  result = 0;
                }
                unique_words_index += lengths[i];

              }
              if (result1 == 0) {     //current_word is not in unique_words array
                lengths[lengths_number] = current_word_len;
                histogram[lengths_number] = 1;
                for( i = 0; i<lengths[lengths_number]; i++) { //put current word into unique array
                  unique_words[i + total_length] = current_word[i];
                }
                lengths_number++;                      //num_unique_words++
                total_length += current_word_len;      //length of unique_words array
              }
              if (result1 == 1) {
                result1 = 0;
              }
              //end of histogram_creator
              unique_words_index = 0;
              current_word_len = 0;
          } else {
              // Do nothing - Skip the delimiting character.
          }

          if ( cur_char == '\n') {
              end_of_sentence = 1;
          }

      } else {
          // Not a delimiting charcter
          // Copy the current character to "current_word"
          current_word[current_word_len] = cur_char;
          current_word_len++; //increment the length of current word


      }

      // Current character is processed
      // Point "inp" to the next character
      inp++;
  }


    // Populating following global variables:
    //num_unique_words
    num_unique_words = lengths_number;
    //max_frequency
    int k = 0;
    for(k = 0; k < lengths_number; k++){
      if(histogram[k]>max_frequency){
        max_frequency=histogram[k];
      }
    }
    //num_words_with_max_frequency
    for(k = 0; k< lengths_number; k++) {
      if(histogram[k]==max_frequency){
        num_words_with_max_frequency++;
      }
    }
    //word
    for(k = 0; k< lengths_number; k++){
      if(histogram[k]==max_frequency){
        int i = 0;
        for( i = 0; i<lengths[k]; i++){
          word[i] = unique_words[unique_words_index + i];
        }
        word[i] = '\0';
        break;
      }
      unique_words_index += lengths[k];
    }
     //clears up histogram and lengths arrays for next iteration
    for(k = 0; k < lengths_number; k++) {
      histogram[k] = 0;
    }
    for(k = 0; k < lengths_number; k++) {
      lengths[k] = 0;
    }

}

///////////////////////////////////////////////////////////////////////////////
//
// DO NOT MODIFY CODE BELOW
//
///////////////////////////////////////////////////////////////////////////////

int main() {

    while(1) {

        num_unique_words = 0;
        max_frequency = -1;
        num_words_with_max_frequency = 0;
        word[0] = '\0';

        read_input(input_sentence);

        process_input(input_sentence);

        output(num_unique_words, max_frequency, num_words_with_max_frequency, word);

    }
}
