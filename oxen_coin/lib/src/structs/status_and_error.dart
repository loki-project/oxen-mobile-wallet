// ignore_for_file: camel_case_types

import 'dart:ffi';
import 'dart:convert';

class status_and_error extends Struct {
    @Bool()
    external bool good;

    @Array(1023)
    external Array<Int8> error;

    String errorString() {
        final list = <int>[];
        for (var i = 0; error[i] != 0; i++) {
            list.add(error[i]);
        }
        return utf8.decode(list);
    }
}
