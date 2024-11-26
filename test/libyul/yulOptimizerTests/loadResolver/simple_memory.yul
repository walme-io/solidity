{
    mstore(calldataload(0), calldataload(10))
    let t := mload(calldataload(10))
    let q := mload(calldataload(0))
    sstore(t, q)
}
// ----
// step: loadResolver
//
// {
//     {
//         mstore(calldataload(0), calldataload(10))
//         let t := mload(calldataload(10))
//         sstore(t, mload(calldataload(0)))
//     }
// }
