uint constant X = 42;
contract C layout at 0xffff * (50 - X) { }
// ----
// TypeError 6396: (43-60): Only number literals are accepted in the expression specifying the contract base storage location.
