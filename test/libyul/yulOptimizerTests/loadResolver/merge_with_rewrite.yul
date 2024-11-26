{
    mstore(2, 3)
    if calldataload(1) {
        mstore(2, 7)
        // Re-writing the old value, should allow to eliminate the load below.
        mstore(2, 3)
    }
    sstore(0, mload(2))
}
// ----
// step: loadResolver
//
// {
//     {
//         mstore(2, 3)
//         if calldataload(1)
//         {
//             mstore(2, 7)
//             mstore(2, 3)
//         }
//         sstore(0, mload(2))
//     }
// }
