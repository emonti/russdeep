#include "ruby.h"
#include <fuzzy.h>
#include <stdio.h>

static VALUE module_FuzzyHash = Qnil;
static VALUE error_HashError = Qnil;

VALUE fuzzyhash_from_string(VALUE klass, VALUE buf) {
  char hash[FUZZY_MAX_RESULT];
  int ret;
  Check_Type(buf, T_STRING);

  ret = fuzzy_hash_buf(RSTRING_PTR(buf), RSTRING_LEN(buf), hash);
  if (ret == 0)
    return rb_str_new2(hash);
  else
    rb_raise(error_HashError, "An error occurred hashing a string: ret=%i", ret);
}

VALUE fuzzyhash_from_filename(VALUE klass, VALUE filename) {
  char hash[FUZZY_MAX_RESULT];
  int ret;
  Check_Type(filename, T_STRING);

  ret=fuzzy_hash_filename(RSTRING_PTR(filename), hash);
  if (ret == 0)
    return rb_str_new2(hash);
  else
    rb_raise(error_HashError, "An error occurred the file: %s -- ret=%i", RSTRING_PTR(filename), ret);
}

VALUE fuzzyhash_from_fileno(VALUE klass, VALUE fileno) {
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

VALUE fuzzyhash_compare(VALUE klass, VALUE sig1, VALUE sig2) {
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

void Init_fuzzyhash_native() {
  module_FuzzyHash = rb_define_module("FuzzyHash");

  error_HashError = rb_define_class_under(module_FuzzyHash, "HashError", rb_eStandardError);

  rb_define_singleton_method(module_FuzzyHash, "from_string", fuzzyhash_from_string, 1);
  rb_define_singleton_method(module_FuzzyHash, "from_file", fuzzyhash_from_filename, 1);
  rb_define_singleton_method(module_FuzzyHash, "from_fileno", fuzzyhash_from_fileno, 1);
  rb_define_singleton_method(module_FuzzyHash, "compare", fuzzyhash_compare, 2);

  rb_define_const(module_FuzzyHash, "FUZZY_MAX_RESULT", INT2NUM(FUZZY_MAX_RESULT));
  rb_define_const(module_FuzzyHash, "SPAMSUM_LENGTH", INT2NUM(SPAMSUM_LENGTH));
}

