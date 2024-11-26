{
    let b := mload(2)
    sstore(0, b)
    if calldataload(1) {
        mstore(2, 7)
    }
    sstore(0, mload(2))
}
// ----
// step: loadResolver
//
// {
//     {
//         sstore(0, mload(2))
//         if calldataload(1) { mstore(2, 7) }
//         sstore(0, mload(2))
//     }
// }
