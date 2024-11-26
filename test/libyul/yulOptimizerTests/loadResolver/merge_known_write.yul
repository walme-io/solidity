{
    mstore(calldataload(0), calldataload(10))
    if calldataload(1) {
        mstore(calldataload(0), 1)
    }
    let t := mload(0)
    let q := mload(calldataload(0))
    sstore(t, q)
}
// ----
// step: loadResolver
//
// {
//     {
//         mstore(calldataload(0), calldataload(10))
//         if calldataload(1) { mstore(calldataload(0), 1) }
//         let t := mload(0)
//         sstore(t, mload(calldataload(0)))
//     }
// }
