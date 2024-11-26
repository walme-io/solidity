{
    let x := mload(calldataload(0))
    if calldataload(1) {
        mstore(add(calldataload(0), 0x20), 1)
    }
    let t := mload(add(calldataload(0), 0x20))
    let q := mload(calldataload(0))
    sstore(t, q)
}
// ----
// step: loadResolver
//
// {
//     {
//         if calldataload(1)
//         {
//             mstore(add(calldataload(0), 0x20), 1)
//         }
//         let t := mload(add(calldataload(0), 0x20))
//         sstore(t, mload(calldataload(0)))
//     }
// }
