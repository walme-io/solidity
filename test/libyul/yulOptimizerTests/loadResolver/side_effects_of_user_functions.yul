{
    function stores() { mstore(0, 1) }
    function reads() { sstore(9, mload(7)) }

    mstore(2, 9)
    reads()
    sstore(0, mload(2))
    stores()
    sstore(0, mload(2))
}
// ----
// step: loadResolver
//
// {
//     {
//         mstore(2, 9)
//         reads()
//         sstore(0, mload(2))
//         stores()
//         sstore(0, mload(2))
//     }
//     function stores()
//     { mstore(0, 1) }
//     function reads()
//     { sstore(9, mload(7)) }
// }
