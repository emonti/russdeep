#include "ruby.h"
#include <fuzzy.h>
#include <stdio.h>

static VALUE module_Ssdeep = Qnil;
static VALUE error_HashError = Qnil;

/* call-seq: from_string(buf)
 *
 * Create a fuzzy hash from a ruby string
 *
 * @param  String buf   The string to hash
 *
 * @return String       The fuzzy hash of the string
 *
 * @raise HashError  
 *   An exception is raised if the libfuzzy library encounters an error.
 */
VALUE ssdeep_from_string(VALUE klass, VALUE buf) {
  char hash[FUZZY_MAX_RESULT];
  int ret;
  Check_Type(buf, T_STRING);

  ret = fuzzy_hash_buf((unsigned char *) RSTRING_PTR(buf), RSTRING_LEN(buf), hash);
  if (ret == 0)
    return rb_str_new2(hash);
  else
    rb_raise(error_HashError, "An error occurred hashing a string: ret=%i", ret);
}

/* call-seq: from_file(filename)
 *
 * Create a fuzzy hash from a file
 *
 * @param  String fielname  The file to read and hash
 *
 * @return String           The fuzzy hash of the file input
 *
 * @raise HashError  
 *   An exception is raised if the libfuzzy library encounters an error.
 */
VALUE ssdeep_from_filename(VALUE klass, VALUE filename) {
  char hash[FUZZY_MAX_RESULT];
  int ret;
  Check_Type(filename, T_STRING);

  ret=fuzzy_hash_filename(RSTRING_PTR(filename), hash);
  if (ret == 0)
    return rb_str_new2(hash);
  else
    rb_raise(error_HashError, "An error occurred the file: %s -- ret=%i", RSTRING_PTR(filename), ret);
}

/* call-seq: from_fileno(fileno)
 *
 * Create a fuzzy hash from a file descriptor fileno
 *
 * @param  Integer fileno  The file descriptor to read and hash
 * 
 * @return String          The fuzzy hash of the file descriptor input
 *
 * @raise HashError  
 *   An exception is raised if the libfuzzy library encounters an error.
 */
VALUE ssdeep_from_fileno(VALUE klass, VALUE fileno) {
  char hash[FUZZY_MAX_RESULT];
  int ret, fd;
  FILE *file;

  Check_Type(fileno, T_FIXNUM);

  fd = FIX2INT(fileno);

  if (!(file=fdopen(fd, "r"))) {
    rb_sys_fail(0);
    return Qnil;
  }

  ret=fuzzy_hash_file(file, hash);
  if (ret == 0)
    return rb_str_new2(hash);
  else
    rb_raise(error_HashError, "An error occurred the fileno: %i -- ret=%i", fd, ret);
}

/* call-seq: compare(sig1, sig2)
 *
 * Compare two hashes
 *
 * @param String sig1  A fuzzy hash which will be compared to sig2
 *
 * @param String sig2  A fuzzy hash which will be compared to sig1
 *
 * @return Integer
 *   A value between 0 and 100 indicating the percentage of similarity.
 */
VALUE ssdeep_compare(VALUE klass, VALUE sig1, VALUE sig2) {
  int ret;

  Check_Type(sig1, T_STRING);
  Check_Type(sig2, T_STRING);

  if (strncmp(RSTRING_PTR(sig1), RSTRING_PTR(sig2), FUZZY_MAX_RESULT) == 0)
    return INT2NUM(100);
  else if ( (ret=fuzzy_compare(RSTRING_PTR(sig1), RSTRING_PTR(sig2))) < 0)
    rb_raise(error_HashError, "An error occurred comparing hashes");
  else
    return INT2NUM(ret);
}

void Init_ssdeep_native() {
  module_Ssdeep = rb_define_module("Ssdeep");

  error_HashError = rb_define_class_under(module_Ssdeep, "HashError", rb_eStandardError);

  rb_define_singleton_method(module_Ssdeep, "from_string", ssdeep_from_string, 1);
  rb_define_singleton_method(module_Ssdeep, "from_file", ssdeep_from_filename, 1);
  rb_define_singleton_method(module_Ssdeep, "from_fileno", ssdeep_from_fileno, 1);
  rb_define_singleton_method(module_Ssdeep, "compare", ssdeep_compare, 2);

  rb_define_const(module_Ssdeep, "FUZZY_MAX_RESULT", INT2NUM(FUZZY_MAX_RESULT));
  rb_define_const(module_Ssdeep, "SPAMSUM_LENGTH", INT2NUM(SPAMSUM_LENGTH));
}

