contract A layout at 0x1234 {}
contract B layout at 1024 {}
contract C layout at "C" {}
// ----
// TypeError 76: (81-84): Contract storage base location must be in range of type uint256. Current type is literal_string "C"
