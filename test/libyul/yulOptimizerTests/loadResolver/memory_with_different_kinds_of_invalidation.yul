{
    mstore(2, 9)
    sstore(0, mload(2))
    pop(call(0, 0, 0, 0, 0, 0, 0))
    sstore(0, mload(2))

    mstore(2, 10)
    mstore8(calldataload(0), 4)
    sstore(0, mload(2))

    mstore(2, 10)
    g()
    sstore(0, mload(2))

    function g() {}
}
// ----
// step: loadResolver
//
// {
//     {
//         mstore(2, 9)
//         sstore(0, mload(2))
//         pop(call(0, 0, 0, 0, 0, 0, 0))
//         sstore(0, mload(2))
//         mstore(2, 10)
//         mstore8(calldataload(0), 4)
//         sstore(0, mload(2))
//         mstore(2, 10)
//         sstore(0, mload(2))
//     }
// }
